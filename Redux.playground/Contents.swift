import UIKit

// MARK: - Dependencies

struct ApiRequest {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    let method: Method
    let parameters: [String: String]
}

enum ApiError {
    case httpError(Int)
    case invalidData
}

typealias ApiResponse = Result<ApiError, Data>

final class Api {
    func execute(_ request: ApiRequest) -> Future<ApiResponse> {
        let user = User(id: 500, name: "TestUser")
        let encoded = try! JSONEncoder().encode(user)
        return delayed(.success(encoded))
    }
}

enum ApiEndpoint {
    case logIn(email: String, password: String)
    
    var request: ApiRequest {
        switch self {
        case let .logIn(email, password):
            return ApiRequest(method: .post, parameters: ["email": email, "password": password])
        }
    }
}

final class MemoryStorage<K: Hashable, V> {
    private var storage: [K: V] = [:]
    
    func value(forKey key: K) -> V? {
        return storage[key]
    }
    
    func setValue(_ value: V, forKey key: K) {
        storage[key] = value
    }
}

enum AnalyticsEvent {
    enum AccountEvent {
        case logInPressed
    }
    case accountEvent(AccountEvent)
}

final class Analytics {
    func track(_ event: AnalyticsEvent) {
        print("Tracked \(event)")
    }
}

struct Dependencies {
    let api = Api()
    let analytics = Analytics()
    let storage = MemoryStorage<String, AppState>()
}

// MARK: - Model

struct User: Codable {
    let id: Int
    let name: String
}

struct Video {
    let id: Int
    let title: String
    let videoUrl: String
}

struct Settings {
    var notificationsOn: Bool = false
}

// MARK: - State

struct VideosState {
    var videos: [Video] = []
}

struct AccountState {
    var loggedInUser: User? = nil
    var settings: Settings = .init()
}

struct AppState {
    var videosState: VideosState = .init()
    var accountState: AccountState = .init()
    var watchedVideos: [Video] = []
}

// MARK: - Actions

enum VideosAction {
    case tappedVideo(Video)
}

enum AccountAction {
    case logIn(email: String, password: String)
    case loggedIn(User)
    case loginFailed
    case tappedLogout
    case tappedNotification(on: Bool)
}

enum AppAction {
    case accountAction(AccountAction)
    case videosAction(VideosAction)
}

// MARK: - SideEffects

enum AppSideEffect {
    case sequence([AppSideEffect])
    
    case api(ApiEndpoint)
    case log(String)
    case save
    case track(AnalyticsEvent)
}

extension AppSideEffect: Monoid {
    static var identity: AppSideEffect { return .sequence([]) }
    
    static func <> (lhs: AppSideEffect, rhs: AppSideEffect) -> AppSideEffect {
        switch (lhs, rhs) {
        case let (.sequence(a), .sequence(b)): return .sequence(a + b)
        case let (.sequence(a), _): return .sequence(a + [rhs])
        case let (_, .sequence(b)): return .sequence([lhs] + b)
        default: return .sequence([lhs, rhs])
        }
    }
}

// MARK: - Reducers

let accountReducer = Reducer<(AccountState, [Video]), AccountAction, AppSideEffect> { state, action in
    var (accountState, watchedVideos) = state
    defer { state = (accountState, watchedVideos) }
    
    switch action {
    case let .logIn(email, password):
        return .log("Logging in")
            <> .track(.accountEvent(.logInPressed))
            <> .api(.logIn(email: email, password: password))
    case let .loggedIn(user):
        accountState.loggedInUser = user
        return .log("Logged in as \(user.name)")
    case .loginFailed:
        return .log("Log in failed")
    case .tappedLogout:
        accountState.loggedInUser = nil
    case let.tappedNotification(on):
        accountState.settings.notificationsOn = on
    }
    return .identity
}

let videoReducer = Reducer<(VideosState, [Video]), VideosAction, AppSideEffect> { state, action in
    var (videoState, watchedVideos) = state
    defer { state = (videoState, watchedVideos) }
    
    switch action {
    case let .tappedVideo(video):
        watchedVideos += [video]
        return .log("Watched \(video.title)")
    }
}

extension AppAction {
    enum prism {
        static let accountAction = Prism<AppAction, AccountAction>(
            preview: {
                if case let .accountAction(action) = $0 { return action }
                return nil
        }, review: AppAction.accountAction)
        
        static let videosAction = Prism<AppAction, VideosAction>(
            preview: {
                if case let .videosAction(action) = $0 { return action }
                return nil
        }, review: AppAction.videosAction)
    }
}

let appReducer: Reducer<AppState, AppAction, AppSideEffect> =
    accountReducer
        .lift(state: both(lens(\AppState.accountState), lens(\AppState.watchedVideos)),
              action: AppAction.prism.accountAction)
        <>
        videoReducer
            .lift(state: both(lens(\.videosState), lens(\.watchedVideos)),
                  action: AppAction.prism.videosAction)

// MARK: - Side Effect Interpreter

func interpreter(_ deps: Dependencies) -> (AppState, AppSideEffect) -> Future<[AppAction]> {
    return { state, effect in
        switch effect {
        case .sequence(let effects):
            return effects.reduce(pure(.identity)) { result, sideEffect in
                zip(result, interpreter(deps)(state, sideEffect)).flatMap { a, b in
                    pure(a + b)
                }
            }
        case .api(let endpoint):
            return deps.api
                .execute(endpoint.request)
                .map { response -> [AppAction] in
                    switch response {
                    case .failure(let error):
                        switch error {
                        case .httpError:
                            return [.accountAction(.loginFailed)]
                        case .invalidData:
                            return [.accountAction(.loginFailed)]
                        }
                    case .success(let data):
                        let decoder = JSONDecoder()
                        guard let user = try? decoder.decode(User.self, from: data) else {
                            return [.accountAction(.loginFailed)]
                        }
                        return [.accountAction(.loggedIn(user))]
                    }
            }
        case .save:
            deps.storage.setValue(state, forKey: "state")
        case .log(let text):
            print("[Logger] \(text)")
        case .track(let event):
            deps.analytics.track(event)
        }
        return pure(.identity)
    }
}

// MARK: - Store/Tests

let video1 = Video(id: 1, title: "The Matrix", videoUrl: "matrix.mp4")
let video2 = Video(id: 2, title: "The Matrix Reloaded", videoUrl: "matrix2.mp4")
let video3 = Video(id: 3, title: "The Matrix Revolutions", videoUrl: "matrix3.mp4")

let store = Store<AppState, AppAction, AppSideEffect>(
    reducer: appReducer,
    initialState: .init(
        videosState: VideosState(
            videos: [video1, video2, video3]
        ),
        accountState: AccountState(
            loggedInUser: nil,
            settings: .init(notificationsOn: false)
        ),
        watchedVideos: []
    ),
    interpreter: interpreter(Dependencies())
)

store.subscriber {
    dump($0)
    print("----")
}

store.dispatch(.videosAction(.tappedVideo(video1)))
store.dispatch(.videosAction(.tappedVideo(video3)))
store.dispatch(.accountAction(.logIn(email: "test@email.com", password: "P4s5w0rD")))
store.dispatch(.accountAction(.tappedNotification(on: true)))

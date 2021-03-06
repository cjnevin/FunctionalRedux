//
//  Api.swift
//  Example
//
//  Created by Chris Nevin on 31/01/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Foundation

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

struct ApiConfiguration {
    let basePath: String
}

func createApi(with configuration: ApiConfiguration) -> (ApiRequest) -> Future<ApiResponse> {
    return { request in
        if request.parameters.keys.contains("fail") {
            return delayed(.success(Data()))
        }
        let user = User(id: 500, name: "TestUser")
        let encoded = try! JSONEncoder().encode(user)
        return delayed(.success(encoded))
    }
}

enum ApiEndpoint {
    case logIn(email: String, password: String)
    case logInFailureTest

    var request: ApiRequest {
        switch self {
        case let .logIn(email, password):
            return ApiRequest(method: .post, parameters: ["email": email, "password": password])
        case .logInFailureTest:
            return ApiRequest(method: .post, parameters: ["fail": "true"])
        }
    }
    
    func actions(for response: ApiResponse) -> [AppAction] {
        switch self {
        case .logIn: return response.handleLogin()
        case .logInFailureTest: return response.handleLogin()
        }
    }
}

//
//  Storage.swift
//  Example
//
//  Created by Chris Nevin on 31/01/2019.
//  Copyright © 2019 CJNevin. All rights reserved.
//

import Core
import Foundation

private let appMemory = Memory<AppState>()
private let appDisk = Disk<AppState>()

func getStorage() -> Storage<AppState> {
    return appMemory.storage <> appDisk.storage
}

private final class Memory<T> {
    private var value: T?
    private(set) var storage: Storage<T>!

    init() {
        storage = Storage<T>(get: { [weak self] in
            return self?.value
        }, set: { [weak self] newValue in
            self?.value = newValue
        })
    }
}

private final class Disk<T: Codable> {
    private(set) var storage: Storage<T>!

    init(userDefaults: UserDefaults = .standard) {
        storage = Storage<T>(get: {
            return userDefaults.read(key: "state")
        }, set: { newValue in
            userDefaults.write(newValue, forKey: "state")
        })
    }
}

private extension UserDefaults {
    func read<T: Decodable>(key: String) -> T? {
        let decoder = JSONDecoder()
        guard let data = value(forKey: key) as? Data else {
            return nil
        }
        return try? decoder.decode(T.self, from: data)
    }

    func write<T: Encodable>(_ value: T?, forKey key: String) {
        guard let value = value else {
            setValue(nil, forKey: key)
            return
        }
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(value) else {
            return
        }
        setValue(data, forKey: key)
        #if targetEnvironment(simulator)
        synchronize()
        #endif
    }
}

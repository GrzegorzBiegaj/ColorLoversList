//
//  InMemoryStorage.swift
//  ColorLoversList
//
//  Created by Grzesiek on 09/01/2018.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import Foundation

protocol InMemoryStorable {
    static var inMemoryKey: String { get }
}

extension InMemoryStorable {
    static var inMemoryKey: String { return String(describing: self) }
}

protocol InMemoryStorageProtocol {
    
    func store<T: InMemoryStorable>(_ model: T)
    func tryRestore<T: InMemoryStorable>() -> T?
    
    func clear(_ key: String)
    func clearCache()
}

class InMemoryStorage: InMemoryStorageProtocol {
    
    fileprivate var storage: [String: InMemoryStorable] = [:]
    
    func store<T: InMemoryStorable>(_ model: T) {
        
        storage[T.inMemoryKey] = model
    }
    
    func tryRestore<T: InMemoryStorable>() -> T? {
        
        return storage[T.inMemoryKey] as? T
    }
    
    func clear(_ key: String) {
        
        storage.removeValue(forKey: key)
    }
    
    func clearCache() {
        storage.removeAll()
    }
    
    // MARK: singleton
    
    static let sharedInstance = InMemoryStorage()
    
    fileprivate init() { }
}

//
//  UserRepository.swift
//  SwiftCleanArchitectureExample
//
//  Created by Takeshi Kayahashi on 2024/12/21.
//

import Foundation

// データ層とのインターフェースを提供するためのプロトコル
protocol UserRepository {
    func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void)
    func addUser(userId: String, name: String, comment: String, completion: @escaping (Result<User, Error>) -> Void)
}

class UserRepositoryImpl: UserRepository {
    private let dataStore: UserDataStore

    init(dataStore: UserDataStore) {
        self.dataStore = dataStore
    }

    func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        self.dataStore.fetch(completion: completion)
    }
    
    func addUser(userId: String, name: String, comment: String, completion: @escaping (Result<User, Error>) -> Void) {
        self.dataStore.add(userId: userId, name: name, comment: comment, completion: completion)
    }
    
}

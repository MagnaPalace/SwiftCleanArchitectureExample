//
//  UserRepository.swift
//  SwiftCleanArchitectureExample
//
//  Created by Takeshi Kayahashi on 2024/12/21.
//

import Foundation

// データ層とのインターフェースを提供するためのプロトコル
protocol UserRepository {
    func fetchUsers() async throws -> [User]
    func addUser(userId: String, name: String, comment: String) async throws -> User
}

class UserRepositoryImpl: UserRepository {
    private let dataStore: UserDataStore

    init(dataStore: UserDataStore) {
        self.dataStore = dataStore
    }

    func fetchUsers() async throws -> [User] {
        return try await dataStore.fetchUsers()
    }
    
    func addUser(userId: String, name: String, comment: String) async throws -> User {
        return try await dataStore.addUser(userId: userId, name: name, comment: comment)
    }
    
}

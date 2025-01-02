//
//  UserUseCase.swift
//  SwiftCleanArchitectureExample
//
//  Created by Takeshi Kayahashi on 2024/12/21.
//

import Foundation

// アプリケーションのビジネスルールを表現するためのクラスや構造体
protocol UserUseCase {
    func fetchUsers() async throws -> [User]
    func addUser(userId: String, name: String, comment: String) async throws -> User
}

class UserUseCaseImpl: UserUseCase {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func fetchUsers() async throws -> [User] {
        return try await self.repository.fetchUsers()
    }
    
    func addUser(userId: String, name: String, comment: String) async throws -> User {
        return try await self.repository.addUser(userId: userId, name: name, comment: comment)
    }
}

//
//  UserUseCase.swift
//  SwiftCleanArchitectureExample
//
//  Created by Takeshi Kayahashi on 2024/12/21.
//

import Foundation

// アプリケーションのビジネスルールを表現するためのクラスや構造体
protocol UserUseCase {
    func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void)
    func addUser(userId: String, name: String, comment: String, completion: @escaping (Result<User, Error>) -> Void)
}

class UserUseCaseImpl: UserUseCase {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        self.repository.getAllUsers(completion: completion)
    }
    
    func addUser(userId: String, name: String, comment: String, completion: @escaping (Result<User, Error>) -> Void) {
        self.repository.addUser(userId: userId, name: name, comment: comment, completion: completion)
    }
}

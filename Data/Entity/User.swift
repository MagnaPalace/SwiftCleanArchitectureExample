//
//  User.swift
//  SwiftAsyncExample
//
//  Created by Takeshi Kayahashi on 2022/05/21.
//

import Foundation

struct UsersResponse: Decodable {
    let users: [User]
}

struct UserResponse: Decodable {
    let user_id: String
    let name: String
    let comment: String
}

// ビジネスロジックにおける重要なオブジェクトを表現するためのクラスや構造体
struct User: Codable {
    
    let userId: Int
    let name: String
    let comment: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id" // JSONキーをマッピング
        case name
        case comment
    }

}

extension User {
    enum Key: String, CaseIterable {
        case userId = "user_id"
        case name = "name"
        case comment = "comment"
    }
}

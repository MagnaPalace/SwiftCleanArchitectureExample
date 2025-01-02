//
//  UserDataStore.swift
//  SwiftCleanArchitectureExample
//
//  Created by Takeshi Kayahashi on 2024/12/21.
//

import Foundation

protocol UserDataStore {
    func fetchUsers() async throws -> [User]
    func addUser(userId: String, name: String, comment: String) async throws -> User
}

class UserDataStoreImpl: UserDataStore {
    
    func fetchUsers() async throws -> [User] {
        let api = ApiManager()
        let url = URL(string: BASE_URL + API_URL + UserApi.all.rawValue)!

        let jsonObject = try await api.requestAsync(param: nil, url: url)
        
        // 辞書型にキャスト
        guard let jsonDict = jsonObject as? [String: Any], let usersArray = jsonDict["users"] as? [[String: Any]] else {
            throw NSError(domain: "DecodingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])
        }
        // usersArrayをJSONDecoderを使ってデコード
        let jsonData = try JSONSerialization.data(withJSONObject: usersArray, options: [])
        
        // JSONデータをデコードしてUser配列に変換
        let decoder = JSONDecoder()
        let users = try decoder.decode([User].self, from: jsonData)
        return users
    }

    func addUser(userId: String, name: String, comment: String) async throws -> User {
        let api = ApiManager()
        let url = URL(string: BASE_URL + API_URL + UserApi.store.rawValue)!

        let parameter = [
            User.Key.userId.rawValue: userId,
            User.Key.name.rawValue: name,
            User.Key.comment.rawValue: comment,
        ]
        
        let jsonObject = try await api.requestAsync(param: parameter, url: url)
        
        // 辞書型にキャスト
        guard let jsonDict = jsonObject as? [String: Any] else {
            throw NSError(domain: "DecodingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
        
        // JSONデータをデコードしてUserモデルに変換
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: jsonData)
        return user
    }
}

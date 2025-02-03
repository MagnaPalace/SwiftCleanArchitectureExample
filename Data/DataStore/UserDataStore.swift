//
//  UserDataStore.swift
//  SwiftCleanArchitectureExample
//
//  Created by Takeshi Kayahashi on 2024/12/21.
//

import Foundation
import Alamofire

protocol UserDataStore {
    func fetch(completion: @escaping (Result<[User], Error>) -> Void)
    func add(userId: String, name: String, comment: String, completion: @escaping (Result<User, Error>) -> Void)
}

class UserDataStoreImpl: UserDataStore {
    
    func fetch(completion: @escaping (Result<[User], Error>) -> Void) {
        let url = URL(string: BASE_URL + API_URL + UserApi.all.rawValue)!
        print("-----url-----\n\(url)")
        
//        AF.request(url, method: .get) // GET可能な時
        AF.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300) // 200番台のステータスコードを期待
            .responseDecodable(of: UsersResponse.self) { response in
//                print(response)
                switch response.result {
                case .success(let usersResponse):
                    print(usersResponse)
                    completion(.success(usersResponse.users))
                case .failure(let error):
                    print("Error: \(error)")
                    completion(.failure(error))
                }
            }
    }

    func add(userId: String, name: String, comment: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: BASE_URL + API_URL + UserApi.store.rawValue)!
        print("-----url-----\n\(url)")
        
        let parameter = [
            User.Key.userId.rawValue: userId,
            User.Key.name.rawValue: name,
            User.Key.comment.rawValue: comment,
        ]
        print("-----parameter-----\n\(String(describing: parameter))")
        
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300) // 200番台のステータスコードを期待
            .responseDecodable(of: UserResponse.self) { response in
//              print(response)
                switch response.result {
                case .success(let userResponse):
                    print(userResponse)
                    let user = User.init(userId: Int(userResponse.user_id) ?? 0, name: userResponse.name, comment: userResponse.comment)
                    completion(.success(user))
                case .failure(let error):
                    print("Error: \(error)")
                    completion(.failure(error))
                }
            }
    }
}

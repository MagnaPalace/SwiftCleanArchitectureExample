//
//  UserListPresenter.swift
//  SwiftMVPExample
//
//  Created by Takeshi Kayahashi on 2022/06/05.
//

import Foundation
import UIKit

protocol UserListPresenter {
    func fetchUsers()
}

class UserListPresenterImpl: UserListPresenter {
    private let useCase: UserUseCase
    var viewController: UserListViewControllerInput?

    init(useCase: UserUseCase) {
        self.useCase = useCase
    }
    
    func inject(viewController: UserListViewControllerInput) {
        self.viewController = viewController
    }
    
    func fetchUsers() {
        self.viewController?.startIndicator()
        Task {
            do {
                let users = try await useCase.fetchUsers()
                DispatchQueue.main.async {
                    self.viewController?.setTableView(users: users)
                }
            } catch {
                DispatchQueue.main.async {
                    self.viewController?.showFetchUsersApiFailedAlert()
                }
            }
            self.viewController?.stopIndicator()
        }
    }

}

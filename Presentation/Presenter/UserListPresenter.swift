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

        self.useCase.fetchUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.viewController?.setTableView(users: users)
            case .failure(let error):
                self?.viewController?.showFetchUsersApiFailedAlert()
            }
        }
        
        self.viewController?.stopIndicator()
    }

}

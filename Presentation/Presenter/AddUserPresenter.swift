//
//  AddUserPresenter.swift
//  SwiftMVPExample
//
//  Created by Takeshi Kayahashi on 2022/06/20.
//

import Foundation

protocol AddUserPresenter {
    func addUserButtonTapped(userId: String, name: String, comment: String)
}

class AddUserPresenterImpl: AddUserPresenter {
 
    private let useCase: UserUseCase
    var viewController: AddUserViewControllerInput?

    init(useCase: UserUseCase, viewController: AddUserViewControllerInput) {
        self.useCase = useCase
        self.viewController = viewController
    }
    
    func addUserButtonTapped(userId: String, name: String, comment: String) {
        guard userId.isEmpty, name.isEmpty, comment.isEmpty else {
            self.viewController?.showNotCompletedInputFieldAlert()
            return
        }
        self.viewController?.startIndicator()
        
        self.useCase.addUser(userId: userId, name: name, comment: comment) { [weak self] result in
            switch result {
            case .success:
                self?.viewController?.returnToUserListView()
            case .failure:
                self?.viewController?.showAddUserApiFailedAlert()
            }
        }
        
        self.viewController?.stopIndicator()
    }
}

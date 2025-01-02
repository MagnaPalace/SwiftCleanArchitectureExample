//
//  AddUserPresenter.swift
//  SwiftMVPExample
//
//  Created by Takeshi Kayahashi on 2022/06/20.
//

import Foundation

protocol AddUserPresenter {
    func addUserButtonTapped(userId: String?, name: String?, comment: String?)
}

class AddUserPresenterImpl: AddUserPresenter {
 
    private let useCase: UserUseCase
    var viewController: AddUserViewControllerInput?

    init(useCase: UserUseCase) {
        self.useCase = useCase
    }
    
    func addUserButtonTapped(userId: String?, name: String?, comment: String?) {
        guard userId?.count ?? 0 > 0, name?.count ?? 0 > 0, comment?.count ?? 0 > 0 else {
            self.viewController?.showNotCompletedInputFieldAlert()
            return
        }
        self.viewController?.startIndicator()
        Task {
            do {
                let user = try await useCase.addUser(userId: userId!, name: name!, comment: comment!)
                DispatchQueue.main.async {
                    self.viewController?.returnToUserListView()
                }
            } catch {
                DispatchQueue.main.async {
                    self.viewController?.showAddUserApiFailedAlert()
                }
            }
            self.viewController?.stopIndicator()
        }
    }
}

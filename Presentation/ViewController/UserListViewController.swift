//
//  UserListViewController.swift
//  SwiftCleanArchitectureExample
//
//  Created by Takeshi Kayahashi on 2024/12/23.
//

import UIKit

protocol UserListViewControllerInput: AnyObject {
    func setTableView(users: [User])
    func startIndicator()
    func stopIndicator()
    func showFetchUsersApiFailedAlert()
}

class UserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: UserListPresenter?
    
    private var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "SwiftCleanArchitectureExample"
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.setNavigationBar()
        
        // 開始時にユーザーの一覧取得
        self.presenter?.fetchUsers()
    }
    
    func inject(presenter: UserListPresenter) {
        self.presenter = presenter
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .blue
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "AddUserViewController", bundle: nil)
        let addUserViewController = storyboard.instantiateViewController(withIdentifier: "AddUserViewController") as! AddUserViewController
        let dataStore = UserDataStoreImpl()
        let repository = UserRepositoryImpl(dataStore: dataStore)
        let useCase = UserUseCaseImpl(repository: repository)
        let presenter = AddUserPresenterImpl(useCase: useCase, viewController: addUserViewController)
        
        addUserViewController.inject(presenter: presenter)
        navigationController?.pushViewController(addUserViewController, animated: true)
    }

}

extension UserListViewController: UITableViewDelegate {
    
}

extension UserListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = self.users[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell") as? UserListTableViewCell
        cell?.initialize(model: .init(userNo: user.userId, name: user.name, comment: user.comment))
        return cell!
    }
    
}

extension UserListViewController: UserListViewControllerInput {
    func setTableView(users: [User]) {
        self.users = users
        self.tableView.reloadData()
    }
    
    func startIndicator() {
        IndicatorView.shared.startIndicator()
    }
    
    func stopIndicator() {
        IndicatorView.shared.stopIndicator()
    }
    
    func showFetchUsersApiFailedAlert() {
        DispatchQueue.main.async{
            let alert = UIAlertController(title: String.Localize.errorAlertTitle.text, message: String.Localize.networkCommunicationFailedMessage.text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: String.Localize.closeAlertButtonTitle.text, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

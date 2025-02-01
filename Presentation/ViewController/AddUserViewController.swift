//
//  AddUserViewController.swift
//  SwiftAsyncExample
//
//  Created by Takeshi Kayahashi on 2022/05/23.
//

import UIKit

protocol AddUserViewControllerInput: AnyObject {
    func returnToUserListView()
    func showAddUserApiFailedAlert()
    func startIndicator()
    func stopIndicator()
    func showNotCompletedInputFieldAlert()
}

class AddUserViewController: UIViewController {

    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var commentTextField: UITextField!
 
    var presenter: AddUserPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = String.Localize.addUserViewTitle.text
        
        userIdTextField.delegate = self
        nameTextField.delegate = self
        commentTextField.delegate = self

        self.setNumberKeyboardDoneButton()
    }
    
    func inject(presenter: AddUserPresenter) {
        self.presenter = presenter
    }

    @IBAction func addUserButtonTapped(_ sender: Any) {
        self.presenter?.addUserButtonTapped(userId: userIdTextField.text ?? "", name: nameTextField.text ?? "", comment: commentTextField.text ?? "")
    }
    
    /// ナンバーキーボードに完了ボタン追加
    private func setNumberKeyboardDoneButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneButtonTapped(_:)))
        toolBar.items = [spacer, doneButton]
        userIdTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        userIdTextField.resignFirstResponder()
    }

}

extension AddUserViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
}

extension AddUserViewController: AddUserViewControllerInput {
    func returnToUserListView() {
        DispatchQueue.main.async{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAddUserApiFailedAlert() {
        DispatchQueue.main.async{
            let alert = UIAlertController(title: String.Localize.errorAlertTitle.text, message: String.Localize.addUserFailedMessage.text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: String.Localize.closeAlertButtonTitle.text, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func startIndicator() {
        IndicatorView.shared.startIndicator()
    }
    
    func stopIndicator() {
        IndicatorView.shared.stopIndicator()
    }
    
    func showNotCompletedInputFieldAlert() {
        DispatchQueue.main.async{
            let alert = UIAlertController(title: String.Localize.confirmAlertTitle.text, message: String.Localize.notCompletedInputFieldMessage.text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: String.Localize.closeAlertButtonTitle.text, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

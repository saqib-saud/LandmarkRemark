//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit

protocol LoginPresenter: LoadingDisplayable, AlertDisplayable {
    var isLoginButtonEnabled: Bool { get set }
    func showHomeScreen()
}

class LoginViewController: UIViewController, UITextFieldDelegate, LoginPresenter {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var userNameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: - Injected Properties
    
    lazy var viewModel: LoginProvider = LoginViewModel(viewController: self)
    var coordinator: AuthenticateCoordinator?
    
    var loadingView: LoadingView?

    // MARK:-
    
    var isLoginButtonEnabled: Bool = false {
        didSet {
            if isLoginButtonEnabled {
                loginButton.isEnabled = true
            } else {
                loginButton.isEnabled = false
            }
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameField.delegate = self
        passwordField.delegate = self
        userNameField.becomeFirstResponder()
        
        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true
        
//        userNameField.text = "demo@landmark.com"
//        passwordField.text = "test123"
    }
    
    // MARK: - Actions
    
    @IBAction func authenticateUser(_ sender: UIButton) {
        userNameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        showLoading()
        
        viewModel.authenticateUser(userName: userNameField.text, password: passwordField.text)
    }
    
    func showHomeScreen() {
        guard let coordinator = coordinator else {
            return
        }
        
        hideLoading()
        coordinator.presentHome()
    }
    
    // MARK: - UITextField Delegate

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        viewModel.validateInput(userName: userNameField.text, password: passwordField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameField {
            passwordField.becomeFirstResponder()
        }
        
        viewModel.validateInput(userName: userNameField.text, password: passwordField.text)
        return true
    }
}

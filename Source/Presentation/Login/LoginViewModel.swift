//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

protocol LoginProvider {
    
}

class LoginViewModel: LoginProvider {
    let authenticationService: AuthenticationUseCase
    let viewController: LoginViewController
    
    init(viewController: LoginViewController, authenticationService: AuthenticationUseCase = AuthenticationService.sharedInstance) {
        self.viewController = viewController
        self.authenticationService = authenticationService
    }
    
    func viewDidLoad() {
        
    }
    
    func validateInput(userName: String?, password: String?) {
        if userName != nil, password != nil {
            viewController.isLoginButtonEnabled = true
        } else {
            viewController.isLoginButtonEnabled = false
        }
    }
    func authenticateUser(userName: String?, password: String?) {
        guard let userName = userName, let password = password else {
            return
        }
        
        authenticationService.authenticateUser(userName: userName, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.viewController.loginSuccessful()
            case let .failure(error):
                break
            }
        }
    }
    
    
}

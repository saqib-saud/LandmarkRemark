//  Copyright © 2020 Saqib Saud. All rights reserved.

import Quick
import Nimble
import Firebase

@testable import Landmark_Remark

class LoginViewModelSpec: QuickSpec {
    override func spec() {
        var loginPresenterMock: LoginPresenterMock!
        var authenticationServiceMock: AuthenticationServiceMock!
        var viewModel: LoginViewModel!
        
        
        beforeEach {
            loginPresenterMock = LoginPresenterMock()
            authenticationServiceMock = AuthenticationServiceMock()
            
            viewModel = LoginViewModel(viewController: loginPresenterMock, authenticationService: authenticationServiceMock)
        }
        
        describe("The ViewModel can validate the Input username and password.") {
            context("When username and password is supplied") {
                it("should enable login button") {
                    expect(loginPresenterMock.isLoginButtonEnabled) == false
                    
                    viewModel.validateInput(userName: "user", password: "password")
                    
                    expect(loginPresenterMock.isLoginButtonEnabled) == true
                }
            }
            
            context("When username present and password is null.") {
                it("should not enable login button.") {
                    expect(loginPresenterMock.isLoginButtonEnabled) == false
                    
                    viewModel.validateInput(userName: "user", password: nil)
                    
                    expect(loginPresenterMock.isLoginButtonEnabled) == false
                }
            }
            
            context("When username present and password is null.") {
                it("should not enable login button.") {
                    expect(loginPresenterMock.isLoginButtonEnabled) == false
                    
                    viewModel.validateInput(userName: nil, password: "password")
                    
                    expect(loginPresenterMock.isLoginButtonEnabled) == false
                }
            }
            
            context("When username and password is null.") {
                it("should not enable login button.") {
                    expect(loginPresenterMock.isLoginButtonEnabled) == false
                    
                    viewModel.validateInput(userName: nil, password: "password")
                    
                    expect(loginPresenterMock.isLoginButtonEnabled) == false
                }
            }
        } // describe("The ViewModel can validate the Input username and password.")
        
        describe("The ViewModel can make authentication request.") {
            context("When login request is successful") {
                it("should show home screen") {
                    authenticationServiceMock.authenticateUserResult = .success(Void())
                    
                    expect(authenticationServiceMock.authenticateUserCalled) == false
                    expect(loginPresenterMock.showHomeScreenCalled) == false
                    expect(loginPresenterMock.showAlertCalled) == false
                    
                    viewModel.authenticateUser(userName: "username", password: "password")
                    
                    expect(authenticationServiceMock.authenticateUserCalled) == true
                    expect(loginPresenterMock.showHomeScreenCalled) == true
                    expect(loginPresenterMock.showAlertCalled) == false
                }
            }
            
            context("When login request is successful") {
                it("should show home screen") {
                    authenticationServiceMock.authenticateUserResult = .failure(.invalidCredentials)
                    
                    expect(authenticationServiceMock.authenticateUserCalled) == false
                    expect(loginPresenterMock.showHomeScreenCalled) == false
                    expect(loginPresenterMock.showAlertCalled) == false
                    
                    viewModel.authenticateUser(userName: "username", password: "password")
                    
                    expect(authenticationServiceMock.authenticateUserCalled) == true
                    expect(loginPresenterMock.showHomeScreenCalled) == false
                    expect(loginPresenterMock.showAlertCalled) == true
                }
            }
        }
    }
}


// MARK: - Mocks

private class AuthenticationServiceMock: AuthenticationUseCase {
    var authenticateUserCalled = false
    var authenticateUserResult: (Result<Void, ServiceError>)?
    
    func authenticateUser(userName: String,
                          password: String,
                          completion: @escaping ((Result<Void, ServiceError>) -> Void)) {
        authenticateUserCalled = true
        
        guard let result = authenticateUserResult else {
            return
        }
        
        completion(result)
    }
    
    
}

private class LoginPresenterMock: LoginPresenter {
    var showHomeScreenCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var showAlertCalled = false
    var isLoginButtonEnabled = false
    var loadingView: LoadingView?
    
    func showHomeScreen() {
        showHomeScreenCalled = true
    }
    
    func showLoading() {
        showLoadingCalled = true
    }
    
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    func showAlert(forError error: ServiceError) {
        showAlertCalled = true
    }
    
    
}

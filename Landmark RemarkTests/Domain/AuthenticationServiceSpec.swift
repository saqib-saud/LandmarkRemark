//  Copyright © 2020 Saqib Saud. All rights reserved.

import Quick
import Nimble

@testable import Landmark_Remark

class AuthenticationServiceSpec: QuickSpec {
    override func spec() {
        var authenticationService: AuthenticationService!
        var firebaseClientMock: FirebaseClientMock!
        
        beforeEach {
            firebaseClientMock = FirebaseClientMock()
            authenticationService = AuthenticationService(firebaseClient: firebaseClientMock)
        }
        
        describe("Service can authenticate using email and password.") {
            context("When authentication request is successful") {
                it("should complete successfully") {
                    expect(firebaseClientMock.authenticateCalled) == false
                    
                    waitUntil { done in
                        authenticationService.authenticateUser(userName: "Test",
                                                               password: "password") { result in
                            
                            expect({ () -> ToSucceedResult in
                                guard case .success = result else {
                                    return .failed(reason: "Invalid state returned")
                                }
                                
                                return .succeeded
                            }).to(succeed())
                            
                            done()
                        }
                    }
                    
                    expect(firebaseClientMock.authenticateCalled) == true
                }
            }
            
            context("When authentication request is unsuccessful") {
                it("should fail and return an error") {
                    firebaseClientMock.authenticationError = .invalidEmail
                    
                    expect(firebaseClientMock.authenticateCalled) == false
                    
                    waitUntil { done in
                        authenticationService.authenticateUser(userName: "Test",
                                                               password: "password") { result in
                            
                            expect({ () -> ToSucceedResult in
                                guard case .failure = result else {
                                    return .failed(reason: "Invalid state returned")
                                }
                                
                                return .succeeded
                            }).to(succeed())
                            
                            done()
                        }
                    }
                    
                    expect(firebaseClientMock.authenticateCalled) == true
                }
            }
        } // describe("Service can authenticate using email and password.")
    }
}


// MARK: - Mocks

private class FirebaseClientMock: FirebaseProvider {
    var authenticateCalled = false
    var authenticationError: FirebaseError?
    
    static func configureFirebase() {}
    
    func authenticate(withUserName userName: String, password: String, completion: @escaping ((Result<Void, FirebaseError>) -> Void)) {
        authenticateCalled = true
        
        if let error = authenticationError {
            completion(.failure(error))
        } else {
            completion(.success(Void()))
        }
    }
}

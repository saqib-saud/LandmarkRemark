//  Copyright © 2020 Saqib Saud. All rights reserved.

import Quick
import Nimble
import Firebase

@testable import Landmark_Remark

class FirebaseClientSpec: QuickSpec {
    override func spec() {
        var firebaseClient: FirebaseClient!
        var authClientMock: FIRAuthMock!
        
        beforeEach {
            authClientMock = FIRAuthMock()
            firebaseClient = FirebaseClient(authClient: authClientMock)
        }
        
        // AuthDataResult's initialiser is private and thus we can do limited testing
        describe("Client can authenticate using email and password.") {
          context("When authentication request is made") {
            it("should request to sign-In with Email") {
                expect(authClientMock.signInWithEmailCalled) == false
                
                firebaseClient.authenticate(withUserName: "test",
                                            password: "password") { _ in }
                
                expect(authClientMock.signInWithEmailCalled) == true
            }
          }
        } // describe("Client can authenticate using email and password.")
    }
}


// MARK: - Mock

private class FIRAuthMock: FIRAuthProvider {
    var signInWithEmailCalled = false

    func signIn(withEmail email: String,
                password: String,
                completion: ((AuthDataResult?, Error?) -> Void)?) {
        signInWithEmailCalled = true
        
        guard let completion = completion as ((AuthDataResult?, Error?) -> Void)? else {
            return
        }
        
        completion(nil, nil)
    }
}

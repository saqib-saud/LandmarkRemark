//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation
import Firebase

protocol FirebaseProvider {
    static func configureFirebase()
    func authenticate(withUserName userName: String, password: String, completion: @escaping ((Result<Void, FirebaseError>) -> Void))
}

protocol FIRAuthProvider {
    func signIn(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?)
}

extension Auth: FIRAuthProvider {}

enum FirebaseError: Error {
    init?(authError: AuthErrors) {
        switch authError {
        
        default:
            self = .somethingWentWrong(message: nil)
        }
    }
    
    case userDisabled
    case invalidEmail
    case wrongPassword
    case somethingWentWrong(message: String?)
}

class FirebaseClient: FirebaseProvider {
    static let sharedInstance: FirebaseProvider = FirebaseClient()
    let authClient: FIRAuthProvider
    
    init(authClient: FIRAuthProvider = Auth.auth()) {
        self.authClient = authClient
    }
    
    static func configureFirebase() {
        #if !XCTEST
        FirebaseApp.configure()
        #endif
    }
    
    func authenticate(withUserName userName: String,
                      password: String,
                      completion: @escaping ((Result<Void, FirebaseError>) -> Void)) {
        authClient.signIn(withEmail: userName, password: password) { authResult, error in
          guard error == nil else {
            completion(.failure(.somethingWentWrong(message: error?.localizedDescription)))
            
            return
          }
            
            completion(.success(Void()))
        }
    }
}

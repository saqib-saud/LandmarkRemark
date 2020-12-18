//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation
import Firebase

protocol FirebaseProvider {
    func configureFirebase()
    func authenticate(withUserName userName: String, password: String, completion: @escaping ((Result<Void, FirebaseError>) -> Void))
}

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
    
    func configureFirebase() {
        FirebaseApp.configure()
    }
    
    func authenticate(withUserName userName: String, password: String, completion: @escaping ((Result<Void, FirebaseError>) -> Void)) {
        Auth.auth().signIn(withEmail: userName, password: password) { authResult, error in
          guard let authResult = authResult else {
            completion(.failure(.somethingWentWrong(message: error?.localizedDescription)))
            
            return
          }
            
            completion(.success(Void()))
        }
    }
}

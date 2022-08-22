//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation
import Firebase

protocol FirebaseProvider {
    static func configureFirebase()
    func authenticate(withUserName userName: String,
                      password: String,
                      completion: @escaping ((Result<Void, FirebaseError>) -> Void))
}

protocol FIRAuthProvider {
    func signIn(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?)
}

extension Auth: FIRAuthProvider {}

enum FirebaseError: Error {
    init(code: Int) {
        switch code {
        case 17008, 17011:
            self = .userNotFound
        case 17009:
            self = .wrongPassword
        case 17020:
            self = .noInternet
        default:
            self = .somethingWentWrong(message: nil)
        }
    }

    case userNotFound
    case invalidEmail
    case noInternet
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
        authClient.signIn(withEmail: userName, password: password) { _, error in
            guard let error = error as? NSError else {
                completion(.success(Void()))
                return
            }

            // Handle different Firebase errors, for now only handling login errors.
            if error.domain == AuthErrorDomain {
                completion(.failure(FirebaseError(code: error.code)))
            } else {
                completion(.failure(.somethingWentWrong(message: error.localizedDescription)))
            }
        }
    }
}

//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

enum ServiceError: Error {
    case invalidCredentials
    case noInternet
    case somethingElseWentWrong(message: String?)

    init(firebaseError: FirebaseError) {
        switch firebaseError {
        case .userNotFound, .invalidEmail, .wrongPassword:
            self = .invalidCredentials
        case .noInternet:
            self = .noInternet
        case .somethingWentWrong(message: let message):
            self = .somethingElseWentWrong(message: message)
        }
    }
}

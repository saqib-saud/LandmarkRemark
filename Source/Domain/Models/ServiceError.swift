//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

enum ServiceError: Error {
    case invalidCredentials
    case noInternet
    case somethingElseWentWrong(message: String?)

    init?(firebaseError: FirebaseError) {
        switch firebaseError {
        case let .somethingWentWrong(message: message):
        self = .somethingElseWentWrong(message: message)
        default:
            self = .invalidCredentials
        }
    }
}

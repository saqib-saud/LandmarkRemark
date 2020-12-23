//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

protocol AuthenticationUseCase {
    func authenticateUser(userName: String,
                          password: String,
                          completion: @escaping ((Result<Void, ServiceError>) -> Void))
}

class AuthenticationService: AuthenticationUseCase {
    static let sharedInstance: AuthenticationUseCase = AuthenticationService()

    let firebaseClient: FirebaseProvider

    init(firebaseClient: FirebaseProvider = FirebaseClient.sharedInstance) {
        self.firebaseClient = firebaseClient
    }

    func authenticateUser(userName: String,
                          password: String,
                          completion: @escaping ((Result<Void, ServiceError>) -> Void)) {
        firebaseClient.authenticate(withUserName: userName, password: password) { result in
            switch result {
            case .success:
                completion(.success(Void()))
            case let .failure(error):
                completion(.failure(.somethingElseWentWrong(message: error.localizedDescription)))
            }
        }
    }
}

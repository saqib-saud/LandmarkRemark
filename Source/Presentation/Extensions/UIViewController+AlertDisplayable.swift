//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit

protocol AlertDisplayable: AnyObject {
    func showAlert(forError error: ServiceError)
}

extension AlertDisplayable where Self: UIViewController {
    func showAlert(forError error: ServiceError) {
        let message: String
        switch error {
        case .invalidCredentials:
            message = "Invalid user credentials."
        case .noInternet:
            message = "No Internet, pls try again."
        case .somethingElseWentWrong:
            message = "Oops! Something went wrong, please try again!"
        }

        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertAction)

        present(alert, animated: true)
    }
}

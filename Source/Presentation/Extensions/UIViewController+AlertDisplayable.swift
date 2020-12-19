//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit

protocol AlertDisplayable: class {
    func showAlert(forError error: Error)
}

extension AlertDisplayable where Self: UIViewController {
    func showAlert(forError error: Error) {
        let alert = UIAlertController(title: "An error occurred", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
}

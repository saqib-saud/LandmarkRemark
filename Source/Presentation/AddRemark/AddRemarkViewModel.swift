//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

protocol AddRemarkViewModelProvider {
    func addRemark(text: String?)
}

class AddRemarkViewModel: AddRemarkViewModelProvider {
    private let viewController: AddRemarkViewController
    private var datastore: DatastoreProvider
    
    init(viewController: AddRemarkViewController, datastore: DatastoreProvider = DatastoreService.sharedInstance) {
        self.viewController = viewController
        self.datastore = datastore
    }
    
    func addRemark(text: String?) {
        datastore.remark.note = text
        datastore.addRemark { [weak self] result in
            switch result {
            case .success:
                self?.viewController.dismiss()
            case let .failure(error):
                self?.viewController.showAlert(forError: error)
            }
        }
    }
}

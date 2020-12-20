//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

protocol AddRemarkViewModelProvider {
    func addRemark(text: String?)
}

class AddRemarkViewModel: AddRemarkViewModelProvider {
    private let viewController: AddRemarkViewController
    private var datastoreService: DatastoreUseCase
    
    init(viewController: AddRemarkViewController, datastoreService: DatastoreUseCase = DatastoreService.sharedInstance) {
        self.viewController = viewController
        self.datastoreService = datastoreService
    }
    
    func addRemark(text: String?) {
        datastoreService.remark.note = text
        datastoreService.addRemark { [weak self] result in
            switch result {
            case .success:
                self?.viewController.dismiss()
            case let .failure(error):
                self?.viewController.showAlert(forError: error)
            }
        }
    }
}

//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

protocol AddRemarkViewModelProvider {
    func addRemark(text: String?)
}

class AddRemarkViewModel: AddRemarkViewModelProvider {
    private let viewController: AddRemarkViewController
    private var dataStoreService: DataStoreUseCase
    
    init(viewController: AddRemarkViewController, dataStoreService: DataStoreUseCase = DataStoreService.sharedInstance) {
        self.viewController = viewController
        self.dataStoreService = dataStoreService
    }
    
    func addRemark(text: String?) {
        dataStoreService.remark.note = text
        dataStoreService.addRemark { [weak self] result in
            switch result {
            case .success:
                self?.viewController.dismiss()
            case let .failure(error):
                self?.viewController.showAlert(forError: error)
            }
        }
    }
}

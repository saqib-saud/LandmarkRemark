//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

protocol AddRemarkViewModelProvider {
    func addRemark(text: String?)
}

class AddRemarkViewModel: AddRemarkViewModelProvider {
    private unowned let viewController: AddRemarkPresenter
    private var dataStoreService: DataStoreUseCase
    
    init(viewController: AddRemarkPresenter, dataStoreService: DataStoreUseCase = DataStoreService.sharedInstance) {
        self.viewController = viewController
        self.dataStoreService = dataStoreService
    }
    
    func addRemark(text: String?) {
        dataStoreService.remark.note = text
        viewController.showLoading()

        dataStoreService.addRemark { [weak self] result in
            self?.viewController.hideLoading()
            switch result {
            case .success:
                self?.viewController.dismiss()
            case let .failure(error):
                self?.viewController.showAlert(forError: error)
            }
        }
    }
}

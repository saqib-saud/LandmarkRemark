//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit

class AddRemarkViewController: UIViewController {
    // MARK: - Properties
    
    lazy var viewModel = AddRemarkViewModel(viewController: self)
    var coordinator: AddRemarkCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                           target: self,
                                                           action: #selector(didTapAdd))
    }
    
    // MARK: - Action
    
    @objc func didTapCancel() {
        coordinator?.dismissViewController()
    }
    
    @objc func didTapAdd() {

    }
}

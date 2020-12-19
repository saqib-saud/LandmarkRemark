//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit

class AddRemarkViewController: UIViewController, AlertDisplayable {
    // MARK: - Properties
    
    @IBOutlet weak var remarkTextView: UITextView!
    
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
        
        remarkTextView.layer.cornerRadius = 5
        remarkTextView.clipsToBounds = true
    }
    
    func dismiss() {
        coordinator?.dismissViewController()
    }
    
    // MARK: - Actions
    
    @objc func didTapCancel() {
        coordinator?.dismissViewController()
    }
    
    @objc func didTapAdd() {
        viewModel.addRemark(text: remarkTextView.text)
    }
}

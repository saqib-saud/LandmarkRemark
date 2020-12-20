//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit

class AddRemarkViewController: UIViewController, AlertDisplayable {
    // MARK: - Properties
    
    @IBOutlet weak var remarkTextView: UITextView!
    
    lazy var viewModel = AddRemarkViewModel(viewController: self)
    var coordinator: AddRemarkCoordinator?

    var remark: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remarkTextView.layer.cornerRadius = 5
        remarkTextView.clipsToBounds = true
    
        if remark != nil {
            remarkTextView.text = remark
            remarkTextView.isEditable = false
        } else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                               target: self,
                                                               action: #selector(didTapAdd))
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancel))
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

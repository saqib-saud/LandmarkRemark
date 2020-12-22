//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit

protocol AddRemarkPresenter: AlertDisplayable, LoadingDisplayable {
    func dismiss()
}

class AddRemarkViewController: UIViewController, AddRemarkPresenter, UITextViewDelegate {
    // MARK: - Properties
    
    @IBOutlet weak var remarkTextView: UITextView!
    
    lazy var viewModel = AddRemarkViewModel(viewController: self)
    var coordinator: AddRemarkCoordinator?

    var loadingView: LoadingView?

    var remark: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remarkTextView.layer.cornerRadius = 5
        remarkTextView.clipsToBounds = true
        remarkTextView.delegate = self
        remarkTextView.becomeFirstResponder()
        
        if remark != nil {
            remarkTextView.text = remark
            remarkTextView.isEditable = false
        } else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                               target: self,
                                                               action: #selector(didTapAdd))
            navigationItem.rightBarButtonItem?.isEnabled = false
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
    
    // MARK: - TextView Delegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

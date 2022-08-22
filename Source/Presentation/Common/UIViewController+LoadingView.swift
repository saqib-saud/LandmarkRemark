//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit

protocol LoadingDisplayable: AnyObject {
    var loadingView: LoadingView? { get set }
    func showLoading()
    func hideLoading()
}

extension LoadingDisplayable where Self: UIViewController {
    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.setupLoadingView()
            self?.loadingView?.show()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView?.hide()
            self?.removeLoadingView()
        }
    }

    private func setupLoadingView() {
        let loadingView = LoadingView()
        self.loadingView = loadingView
        view.addSubview(loadingView)
        setupLoadingViewConstraints()
    }

    private func setupLoadingViewConstraints() {
        loadingView?.translatesAutoresizingMaskIntoConstraints = false
        loadingView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView?.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        loadingView?.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    private func removeLoadingView() {
        if loadingView != nil {
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
    }
}

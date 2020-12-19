//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit


extension UIViewController {
    private static var customLoadingView: LoadingView?
    private static var isShowingLoadingScreen = false

    var loadingView: LoadingView? {
        get { return UIViewController.customLoadingView }
        set { UIViewController.customLoadingView = newValue }
    }

    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard !UIViewController.isShowingLoadingScreen else {
                return
            }
            
            UIViewController.isShowingLoadingScreen = true
            self?.setupLoadingView()
            self?.loadingView?.show()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            UIViewController.isShowingLoadingScreen = false
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



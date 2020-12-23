//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit

protocol AuthenticateCoordinator {
    func presentHome()
}

protocol HomeCoordinator {
    func presentAddRemark()
    func presentShowRemark(_ remark: String?)
    func logout()
}

protocol AddRemarkCoordinator {
    func dismissViewController()
}

class AppCoordinator: AuthenticateCoordinator, HomeCoordinator, AddRemarkCoordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let loginViewController: LoginViewController = storyboard.instantiateViewController()
        loginViewController.coordinator = self
        navigationController.pushViewController(loginViewController, animated: false)
    }

    func presentHome() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeViewController: HomeViewController = storyboard.instantiateViewController()
        homeViewController.coordinator = self
        navigationController.pushViewController(homeViewController, animated: false)
    }

    func presentAddRemark() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController: AddRemarkViewController = storyboard.instantiateViewController()
        viewController.coordinator = self
        navigationController.present(UINavigationController(rootViewController: viewController), animated: true)
    }

    func presentShowRemark(_ remark: String?) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController: AddRemarkViewController = storyboard.instantiateViewController()
        viewController.coordinator = self
        viewController.remark = remark
        navigationController.present(UINavigationController(rootViewController: viewController), animated: true)
    }

    func logout() {
        navigationController.popViewController(animated: true)
    }

    func dismissViewController() {
        navigationController.dismiss(animated: true) { [weak self] in
            self?.navigationController.topViewController?.viewWillAppear(true)
        }
    }
}

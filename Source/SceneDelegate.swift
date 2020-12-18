//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else {
            return
        }
        
        let appWindow = UIWindow(frame: scene.coordinateSpace.bounds)
        appWindow.windowScene = scene
        
        let navController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navController)
        appCoordinator.start()

        appWindow.rootViewController = navController
        appWindow.makeKeyAndVisible()
        
        window = appWindow
    }
}


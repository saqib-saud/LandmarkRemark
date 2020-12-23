//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T {
        print(String(describing: T.self))
        guard let viewController = instantiateViewController(identifier: String(describing: T.self)) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(String(describing: T())) ")
        }

        return viewController
    }
}

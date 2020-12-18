//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

protocol AddRemarkViewModelProvider {
}

class AddRemarkViewModel: AddRemarkViewModelProvider {
    private let viewController: AddRemarkViewController
    private let datastore: DatastoreProvider
    
    init(viewController: AddRemarkViewController, datastore: DatastoreProvider = DatastoreService.sharedInstance) {
        self.viewController = viewController
        self.datastore = datastore
    }
}

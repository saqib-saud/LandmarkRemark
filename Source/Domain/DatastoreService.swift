//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

protocol DatastoreProvider {
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, FirebaseError>) -> Void))
}

class DatastoreService: DatastoreProvider {
    static let sharedInstance: DatastoreProvider = DatastoreService()

    let datastoreClient: FirestoreProvider

    init(datastoreClient: FirestoreProvider = FirestoreClient.sharedInstance) {
        self.datastoreClient = datastoreClient
    }
    
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, FirebaseError>) -> Void)) {
        datastoreClient.fetchRemarks(completion: completion)
    }
}

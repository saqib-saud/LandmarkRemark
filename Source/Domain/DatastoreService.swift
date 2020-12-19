//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

protocol DatastoreProvider {
    var remark: RemarkPO { get set }
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, FirebaseError>) -> Void))
    func addRemark(completion: @escaping ((Result<Void, FirebaseError>) -> Void))
}

class DatastoreService: DatastoreProvider {
    static let sharedInstance: DatastoreProvider = DatastoreService()
    
    var remark: RemarkPO
    
    private let datastoreClient: FirestoreProvider

    init(datastoreClient: FirestoreProvider = FirestoreClient.sharedInstance) {
        self.datastoreClient = datastoreClient
        self.remark = RemarkPO()
    }
    
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, FirebaseError>) -> Void)) {
        datastoreClient.fetchRemarks(completion: completion)
    }
    
    func addRemark(completion: @escaping ((Result<Void, FirebaseError>) -> Void)) {
        guard remark.coordinate != nil, remark.note != nil else {
            completion(.failure(.somethingWentWrong(message: "No remark found")))
            return
        }
        
        datastoreClient.addRemark(remark, completion: completion)
    }
}

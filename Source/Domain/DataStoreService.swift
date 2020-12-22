//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

protocol DataStoreUseCase {
    var remark: RemarkPO { get set }
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, FirebaseError>) -> Void))
    func addRemark(completion: @escaping ((Result<Void, FirebaseError>) -> Void))
}

class DataStoreService: DataStoreUseCase {
    static let sharedInstance: DataStoreUseCase = DataStoreService()
    
    var remark: RemarkPO
    
    private let dataStoreClient: FirestoreProvider

    init(dataStoreClient: FirestoreProvider = FirestoreClient.sharedInstance) {
        self.dataStoreClient = dataStoreClient
        self.remark = RemarkPO()
    }
    
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, FirebaseError>) -> Void)) {
        dataStoreClient.fetchRemarks(completion: completion)
    }
    
    func addRemark(completion: @escaping ((Result<Void, FirebaseError>) -> Void)) {
        guard remark.coordinate != nil, remark.note != nil else {
            completion(.failure(.somethingWentWrong(message: "No remark found")))
            return
        }
        
        dataStoreClient.addRemark(remark, completion: completion)
    }
}

//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

protocol DataStoreUseCase {
    var remark: RemarkPO { get set }
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, ServiceError>) -> Void))
    func addRemark(completion: @escaping ((Result<Void, ServiceError>) -> Void))
}

class DataStoreService: DataStoreUseCase {
    static let sharedInstance: DataStoreUseCase = DataStoreService()

    var remark: RemarkPO

    private let dataStoreClient: FirestoreProvider

    init(dataStoreClient: FirestoreProvider = FirestoreClient.sharedInstance) {
        self.dataStoreClient = dataStoreClient
        self.remark = RemarkPO()
    }

    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, ServiceError>) -> Void)) {
        dataStoreClient.fetchRemarks { result in
            switch result {
            case let .success(remarks):
                completion(.success(remarks))
            case let .failure(error):
                completion(.failure(ServiceError(firebaseError: error) ?? .somethingElseWentWrong(message: nil)))
            }
        }
    }

    func addRemark(completion: @escaping ((Result<Void, ServiceError>) -> Void)) {
        guard remark.coordinate != nil, remark.note != nil else {
            completion(.failure(.somethingElseWentWrong(message: "No remark found")))
            return
        }
        dataStoreClient.addRemark(remark) { result in
            switch result {
            case .success:
                completion(.success(Void()))
            case let .failure(error):
                completion(.failure(ServiceError(firebaseError: error) ?? .somethingElseWentWrong(message: nil)))
            }
        }
    }
}

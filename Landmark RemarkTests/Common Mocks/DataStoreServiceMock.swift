//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation
@testable import Landmark_Remark

class DataStoreServiceMock: DataStoreUseCase {
    var fetchRemarksCalled = false
    var fetchRemarksResult: (Result<[RemarkPO]?, ServiceError>)?
    
    var addRemarkCalled = false
    var addRemarkResult: (Result<Void, ServiceError>)?
    var remark = RemarkPO()
    
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, ServiceError>) -> Void)) {
        fetchRemarksCalled = true
        
        guard let result = fetchRemarksResult  else {
            return
        }
        
        completion(result)
    }
    
    func addRemark(completion: @escaping ((Result<Void, ServiceError>) -> Void)) {
        addRemarkCalled = true
        
        guard let result = addRemarkResult  else {
            return
        }
        
        completion(result)
    }
}

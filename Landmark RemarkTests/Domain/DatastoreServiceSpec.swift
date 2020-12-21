//  Copyright © 2020 Saqib Saud. All rights reserved.

import Quick
import Nimble

@testable import Landmark_Remark

class DataStoreServiceSpec: QuickSpec {
    override func spec() {
        var dataStoreService: DataStoreService!
        var dataStoreClientMock: FirestoreClientMock!
        
        beforeEach {
            dataStoreClientMock = FirestoreClientMock()
            dataStoreService = DataStoreService(dataStoreClient: dataStoreClientMock)
        }
        
        describe("Service can fetch remarks.") {
            context("When request is successful") {
                it("Should return remark annotations") {
                    dataStoreClientMock.fetchRemarksResult = .success([RemarkPO(withUserName: "user", note: "note", latitude: 0.0, longitude: 0.0)])
                    
                    expect(dataStoreClientMock.fetchRemarksCalled) == false
                    
                    waitUntil { done in
                        dataStoreService.fetchRemarks { result in
                            expect({ () -> ToSucceedResult in
                                guard case let .success(remarks) = result, remarks?.count ?? 0 > 0 else {
                                    return .failed(reason: "Invalid state returned")
                                }
                                
                                return .succeeded
                            }).to(succeed())
                        }
                        
                        done()
                    }
                }
            }
            
            context("When request is unsuccessful") {
                it("Should return an error") {
                    dataStoreClientMock.fetchRemarksResult = .failure(.somethingWentWrong(message: "An error"))
                    
                    expect(dataStoreClientMock.fetchRemarksCalled) == false
                    
                    waitUntil { done in
                        dataStoreService.fetchRemarks { result in
                            expect({ () -> ToSucceedResult in
                                guard case let .failure(error) = result, case .somethingWentWrong(message: "An error") = error else {
                                    return .failed(reason: "Invalid state returned")
                                }
                                
                                return .succeeded
                            }).to(succeed())
                        }
                        
                        done()
                    }
                }
            }
        } // describe("Service can fetch remarks.")
        
        describe("Service can add remark.") {
            context("When remark exits and request is successful") {
                it("should return success") {
                    dataStoreClientMock.addRemarksResult = .success(Void())
                    dataStoreService.remark = RemarkPO(withUserName: "Test",
                                                       note: "note",
                                                       latitude: 0.0,
                                                       longitude: 0.0)
                    expect(dataStoreClientMock.addRemarksCalled) == false
                    
                    dataStoreService.addRemark { _ in }
                    
                    expect(dataStoreClientMock.addRemarksCalled) == true
                }
            }
            
            context("When remark does not exits and request is successful") {
                it("should return success") {
                    dataStoreClientMock.addRemarksResult = .success(Void())
    
                    expect(dataStoreClientMock.addRemarksCalled) == false
                    
                    waitUntil { done in
                        dataStoreService.addRemark { result in
                            expect({ () -> ToSucceedResult in
                                guard case let .failure(error) = result, case .somethingWentWrong(message: "No remark found") = error else {
                                    return .failed(reason: "Invalid state returned")
                                }
                                
                                return .succeeded
                            }).to(succeed())
                            
                            done()
                        }
                    }
                    
                    expect(dataStoreClientMock.addRemarksCalled) == false
                }
            }
            
            context("When remark exits and request is unsuccessful") {
                it("should return failure") {
                    dataStoreClientMock.addRemarksResult = .failure(.invalidEmail)
                    dataStoreService.remark = RemarkPO(withUserName: "Test",
                                                       note: "note",
                                                       latitude: 0.0,
                                                       longitude: 0.0)
                    
                    expect(dataStoreClientMock.addRemarksCalled) == false
                    
                    waitUntil { done in
                        dataStoreService.addRemark { result in
                            expect({ () -> ToSucceedResult in
                                guard case let .failure(error) = result, case .invalidEmail = error else {
                                    return .failed(reason: "Invalid state returned")
                                }
                                
                                return .succeeded
                            }).to(succeed())
                            
                            done()
                        }
                    }
                    
                    expect(dataStoreClientMock.addRemarksCalled) == true
                }
            }
        } // describe("Service can add remark.")
    }
}

// MARK: - Mock

class FirestoreClientMock: FirestoreProvider {
    var fetchRemarksCalled = false
    var fetchRemarksResult: (Result<[RemarkPO]?, FirebaseError>)?
    
    var addRemarksCalled = false
    var addRemarksResult: (Result<Void, FirebaseError>)?
    
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, FirebaseError>) -> Void)) {
        fetchRemarksCalled = true
        
        guard let result = fetchRemarksResult else {
            return
        }
        
        completion(result)
    }
    
    func addRemark(_ remark: RemarkPO, completion: @escaping ((Result<Void, FirebaseError>) -> Void)) {
        addRemarksCalled = true
        
        guard let result = addRemarksResult else {
            return
        }
        
        completion(result)
    }
    
    
}

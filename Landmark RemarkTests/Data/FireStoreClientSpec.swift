//  Copyright © 2020 Saqib Saud. All rights reserved.

import Quick
import Nimble
import Firebase

@testable import Landmark_Remark

class FirestoreClientSpec: QuickSpec {
    override func spec() {
        var firebaseClient: FirestoreClient!
        var authClientMock: FIRAuthMock!
        var firestoreMock: FIRStoreMock!
        
        beforeEach {
            authClientMock = FIRAuthMock()
            firestoreMock = FIRStoreMock()
            firebaseClient = FirestoreClient(authClient: authClientMock, dbClient: firestoreMock)
        }
        
        // AuthDataResult's initialiser is private and thus we can do limited testing
        describe("Client can fetch remarks.") {
          context("When request is made") {
            it("should fetch remarks from collection.") {
                expect(firestoreMock.collectionCalled) == false
                
                firebaseClient.fetchRemarks { _ in }
                
                expect(firestoreMock.collectionCalled) == true
            }
          }
        } // describe("Client can fetch remarks.")
    }
}

// MARKS: - Mocks

private class FIRAuthMock: FIRAuthUserProvider {
    var currentUser: User?
}

private class FIRStoreMock: FIRStoreProvider {
    var collectionCalled = false
    
    func collection(_ collectionPath: String) -> CollectionReference {
        collectionCalled = true
        
        return Firestore.firestore().collection(collectionPath)
    }
}

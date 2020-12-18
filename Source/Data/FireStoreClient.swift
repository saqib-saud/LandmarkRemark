//  Copyright © 2020 Saqib Saud. All rights reserved.

import Firebase

struct RemarkPO {
    let userName: String?
    let remark: String?
    let coordinate: Coordinate?
    
    init(withDocument document: QueryDocumentSnapshot) {
        userName = document.get("username") as? String
        remark = document.get("note") as? String
        
        if let geoPoint =  document.get("location") as? GeoPoint {
            coordinate = Coordinate(withGeoPoint: geoPoint)
        } else {
            coordinate = nil
        }
    }
    
    struct Coordinate {
        let latitude: Double
        let longitude: Double
        
        init(withGeoPoint geoPoint: GeoPoint) {
            latitude = geoPoint.latitude
            longitude = geoPoint.longitude
        }
    }
}

protocol FirestoreProvider {
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, FirebaseError>) -> Void))
}

class FirestoreClient: FirestoreProvider {
    static let sharedInstance: FirestoreProvider = FirestoreClient()

    let db = Firestore.firestore()
    
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, FirebaseError>) -> Void)) {

        db.collection("remarks").getDocuments() { (querySnapshot, error) in
            if let error = error {
                completion(.failure(.somethingWentWrong(message: error.localizedDescription)))
            } else {
                let remarks = querySnapshot?.documents.map({ RemarkPO(withDocument: $0) })
                completion(.success(remarks))
            }
        }
    }
}

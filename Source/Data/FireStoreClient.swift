//  Copyright © 2020 Saqib Saud. All rights reserved.

import Firebase

struct RemarkPO {
    let userName: String?
    var note: String?
    var coordinate: Coordinate?
    
    init(withDocument document: QueryDocumentSnapshot) {
        userName = document.get("username") as? String
        note = document.get("note") as? String
        
        if let geoPoint =  document.get("location") as? GeoPoint {
            coordinate = Coordinate(withGeoPoint: geoPoint)
        } else {
            coordinate = nil
        }
    }
    
    init() {
        userName = nil
        note = nil
        coordinate = nil
    }
    
    struct Coordinate {
        let latitude: Double
        let longitude: Double
        
        init(withGeoPoint geoPoint: GeoPoint) {
            latitude = geoPoint.latitude
            longitude = geoPoint.longitude
        }
        
        init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
}

protocol FirestoreProvider {
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, FirebaseError>) -> Void))
    func addRemark(_ remark: RemarkPO, completion: @escaping ((Result<Void, FirebaseError>) -> Void))
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
    
    func addRemark(_ remark: RemarkPO, completion: @escaping ((Result<Void, FirebaseError>) -> Void)) {
        let db = Firestore.firestore()
        guard let username = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email,
              let note = remark.note,
              let latitude = remark.coordinate?.latitude,
              let longitude = remark.coordinate?.longitude else {
            completion(.failure(.somethingWentWrong(message: "Missing required data")))
            return
        }
        
        let geoPoint = GeoPoint.init(latitude: latitude, longitude: longitude)
        
        db.collection("remarks").addDocument(data: ["note": note,
                                                    "username": username,
                                                    "location": geoPoint]) { error in
            if let error = error {
                completion(.failure(.somethingWentWrong(message: error.localizedDescription)))
            } else {
                completion(.success(Void()))
            }
        }
    }
}

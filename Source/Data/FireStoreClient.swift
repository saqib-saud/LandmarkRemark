//  Copyright © 2020 Saqib Saud. All rights reserved.

import Firebase

protocol FirestoreProvider {
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, FirebaseError>) -> Void))
    func addRemark(_ remark: RemarkPO, completion: @escaping ((Result<Void, FirebaseError>) -> Void))
}

class FirestoreClient: FirestoreProvider {
    enum CodingKeys: String {
        case username = "username"
        case note = "note"
        case location = "location"
    }
    
    static let sharedInstance: FirestoreProvider = FirestoreClient()
    
    let db = Firestore.firestore()
    
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, FirebaseError>) -> Void)) {
        db.collection("remarks").getDocuments() { (querySnapshot, error) in
            if let error = error {
                completion(.failure(.somethingWentWrong(message: error.localizedDescription)))
            } else {
                let remarks = querySnapshot?.documents.map({ document -> RemarkPO in
                    let userName = document.get(CodingKeys.username.rawValue) as? String
                    let note = document.get(CodingKeys.note.rawValue) as? String
                    let location = document.get(CodingKeys.location.rawValue) as? GeoPoint
                    
                    return RemarkPO(withUserName: userName,
                                    note: note,
                                    latitude: location?.latitude,
                                    longitude: location?.longitude)
                })
                
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

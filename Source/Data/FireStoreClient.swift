//  Copyright © 2020 Saqib Saud. All rights reserved.

import Firebase

protocol FirestoreProvider {
    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, FirebaseError>) -> Void))
    func addRemark(_ remark: RemarkPO, completion: @escaping ((Result<Void, FirebaseError>) -> Void))
}

protocol FIRAuthUserProvider {
    var currentUser: User? { get }
}

extension Auth: FIRAuthUserProvider {}

protocol FIRStoreProvider {
     func collection(_ collectionPath: String) -> CollectionReference
}

extension Firestore: FIRStoreProvider {}

class FirestoreClient: FirestoreProvider {
    enum CodingKeys: String {
        case username
        case note
        case location
    }

    static let sharedInstance: FirestoreProvider = FirestoreClient()

    let authClient: FIRAuthUserProvider
    let dbClient: FIRStoreProvider

    init(authClient: FIRAuthUserProvider = Auth.auth(), dbClient: FIRStoreProvider = Firestore.firestore()) {
        self.authClient = authClient
        self.dbClient = dbClient
    }

    func fetchRemarks(completion: @escaping ((Result<[RemarkPO]?, FirebaseError>) -> Void)) {
        dbClient.collection("remarks").getDocuments { (querySnapshot, error) in
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
        guard let username = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email,
              let note = remark.note,
              let latitude = remark.coordinate?.latitude,
              let longitude = remark.coordinate?.longitude else {
            completion(.failure(.somethingWentWrong(message: "Missing required data")))
            return
        }

        let geoPoint = GeoPoint.init(latitude: latitude, longitude: longitude)

        dbClient.collection("remarks").addDocument(data: ["note": note,
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

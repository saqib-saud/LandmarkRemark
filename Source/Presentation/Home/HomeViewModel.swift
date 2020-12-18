//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

protocol HomeViewModelProvider {
    func searchBarDidSearch(text: String)
}

class HomeViewModel: HomeViewModelProvider {
    private let viewController: HomeViewController
    private let datastore: DatastoreProvider
    private var annotations: [Remark]?
    private var filteredAnnotations: [Remark]?
    
    init(viewController: HomeViewController, datastore: DatastoreProvider = DatastoreService.sharedInstance) {
        self.viewController = viewController
        self.datastore = datastore
    }
    
    func viewDidLoad() {
        fetchRemarks { result in
            
        }
    }
    
    func searchBarDidSearch(text: String) {
        if text.count > 0 {
            let lowerCasedInput = text.lowercased()
            filteredAnnotations = annotations?.filter({ $0.userName.lowercased().contains(lowerCasedInput) || $0.remark?.lowercased().contains(lowerCasedInput) ?? false
            })
        } else {
            filteredAnnotations = annotations
        }
        
        viewController.loadRemark(annotations: filteredAnnotations!)
    }
    
    private func fetchRemarks(completion: @escaping ((Result<[RemarkPO], FirebaseError>) -> Void)) {
        datastore.fetchRemarks { [weak self] result in
            switch result {
            case let .success(remarks):
                guard let remarkAnnotations = remarks?.compactMap({ Remark(remarkPO: $0) }) else {
                    return
                }
                
                self?.annotations = remarkAnnotations
                self?.viewController.loadRemark(annotations: remarkAnnotations)
            case let .failure(error):
                return
            }
        }
    }
}

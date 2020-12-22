//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

protocol HomeViewModelProvider {
    func searchBarDidSearch(text: String)
    func didUpdateLocation(latitude: Double, longitude: Double) 
}

class HomeViewModel: HomeViewModelProvider {
    private unowned let viewController: HomePresenter
    private var dataStoreService: DataStoreUseCase
    
    private var annotations: [Remark]?
    private var filteredAnnotations: [Remark]?
    
    init(viewController: HomePresenter, dataStoreService: DataStoreUseCase = DataStoreService.sharedInstance) {
        self.viewController = viewController
        self.dataStoreService = dataStoreService
    }
    
    func viewWillAppear() {
        fetchRemarks()
    }
    
    func searchBarDidSearch(text: String) {
        if text.count > 0 {
            let lowerCasedInput = text.lowercased()
            filteredAnnotations = annotations?.filter({ $0.userName.lowercased().contains(lowerCasedInput) || $0.note?.lowercased().contains(lowerCasedInput) ?? false
            })
        } else {
            filteredAnnotations = annotations
        }
        
        viewController.loadRemark(annotations: filteredAnnotations!)
    }
    
    func didUpdateLocation(latitude: Double, longitude: Double) {
        dataStoreService.remark.coordinate = RemarkPO.Coordinate(latitude: latitude, longitude: longitude)
    }
    
    private func fetchRemarks() {
        dataStoreService.fetchRemarks { [weak self] result in
            switch result {
            case let .success(remarks):
                guard let remarkAnnotations = remarks?.compactMap({ Remark(remarkPO: $0) }) else {
                    return
                }
                
                self?.annotations = remarkAnnotations
                self?.viewController.loadRemark(annotations: remarkAnnotations)
            case let .failure(error):
                self?.viewController.showAlert(forError: error)
            }
        }
    }
}

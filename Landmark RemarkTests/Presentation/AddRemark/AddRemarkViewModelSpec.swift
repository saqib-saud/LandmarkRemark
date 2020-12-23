//  Copyright © 2020 Saqib Saud. All rights reserved.

import Quick
import Nimble

@testable import Landmark_Remark

class AddRemarkViewModelSpec: QuickSpec {
    override func spec() {
        var addRemarkPresenterMock: AddRemarkPresenterMock!
        var dataStoreServiceMock: DataStoreServiceMock!
        var viewModel: AddRemarkViewModel!
        
        
        beforeEach {
            addRemarkPresenterMock = AddRemarkPresenterMock()
            dataStoreServiceMock = DataStoreServiceMock()
            
            viewModel = AddRemarkViewModel(viewController: addRemarkPresenterMock, dataStoreService: dataStoreServiceMock)
        }
        
        describe("The ViewModel can add remarks") {
            context("When request is successful") {
                it("should dismiss the presenter") {
                    dataStoreServiceMock.addRemarkResult = .success(Void())
                    dataStoreServiceMock.remark.coordinate = RemarkPO.Coordinate(latitude: 0.0, longitude: 0.0)
                    
                    expect(addRemarkPresenterMock.dismissCalled) == false
                    expect(addRemarkPresenterMock.showLoadingCalled) == false
                    expect(addRemarkPresenterMock.hideLoadingCalled) == false
                    expect(addRemarkPresenterMock.showAlertCalled) == false
                    
                    viewModel.addRemark(text: "note")
                    
                    expect(addRemarkPresenterMock.dismissCalled) == true
                    expect(addRemarkPresenterMock.showLoadingCalled) == true
                    expect(addRemarkPresenterMock.hideLoadingCalled) == true
                    expect(addRemarkPresenterMock.showAlertCalled) == false
                }
            }
            
            context("When request is unsuccessful") {
                it("should show error and not dismiss the presenter") {
                    dataStoreServiceMock.addRemarkResult = .failure(.noInternet)
                    dataStoreServiceMock.remark.coordinate = RemarkPO.Coordinate(latitude: 0.0, longitude: 0.0)
                    
                    expect(addRemarkPresenterMock.dismissCalled) == false
                    expect(addRemarkPresenterMock.showLoadingCalled) == false
                    expect(addRemarkPresenterMock.hideLoadingCalled) == false
                    expect(addRemarkPresenterMock.showAlertCalled) == false
                    
                    viewModel.addRemark(text: "note")
                    
                    expect(addRemarkPresenterMock.dismissCalled) == false
                    expect(addRemarkPresenterMock.showLoadingCalled) == true
                    expect(addRemarkPresenterMock.hideLoadingCalled) == true
                    expect(addRemarkPresenterMock.showAlertCalled) == true
                }
            }
        }
    }
}

// MARK: - Mocks

class AddRemarkPresenterMock: AddRemarkPresenter {
    var dismissCalled = false
    var showAlertCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    
    var loadingView: LoadingView?
    
    func dismiss() {
        dismissCalled = true
    }
    
    func showAlert(forError error: ServiceError) {
        showAlertCalled = true
    }
    
    func showLoading() {
        showLoadingCalled = true
    }
    
    func hideLoading() {
        hideLoadingCalled = true
    }
}

//  Copyright © 2020 Saqib Saud. All rights reserved.

import Quick
import Nimble

@testable import Landmark_Remark

class HomeViewModelSpec: QuickSpec {
    override func spec() {
        var homePresenterMock: HomePresenterMock!
        var dataStoreServiceMock: DataStoreServiceMock!
        var viewModel: HomeViewModel!
        
        
        beforeEach {
            homePresenterMock = HomePresenterMock()
            dataStoreServiceMock = DataStoreServiceMock()
            
            viewModel = HomeViewModel(viewController: homePresenterMock, dataStoreService: dataStoreServiceMock)
        }
        
        describe("The ViewModel can fetch remarks and update the view controller with the remarks.") {
            context("When View appears and the fetch remarks request is successful") {
                it("can fetch remarks and update the view controller.") {
                    let firstRemark = RemarkPO(withUserName: "user", note: "note", latitude: 0.0, longitude: 0.0)
                    let secondRemark = RemarkPO(withUserName: "test", note: "Testing", latitude: 0.0, longitude: 0.0)
                    dataStoreServiceMock.fetchRemarksResult = .success([firstRemark, secondRemark])
                    
                    expect(dataStoreServiceMock.fetchRemarksCalled) == false
                    expect(homePresenterMock.showAlertCalled) == false
                    expect(homePresenterMock.loadRemarkCalled) == false
                    expect(homePresenterMock.loadRemarkAnnotations).to(beNil())

                    viewModel.viewWillAppear()
                    
                    expect(dataStoreServiceMock.fetchRemarksCalled) == true
                    expect(homePresenterMock.showAlertCalled) == false
                    expect(homePresenterMock.loadRemarkCalled) == true
                    expect(homePresenterMock.loadRemarkAnnotations?.count) == 2
                    expect(homePresenterMock.loadRemarkAnnotations?.first?.title) == "user"
                    expect(homePresenterMock.loadRemarkAnnotations?.first?.note) == "note"
                }
            }
            
            context("When View appears and the fetch remarks request is unsuccessful") {
                it("can fetch remarks and update the view controller.") {
                    dataStoreServiceMock.fetchRemarksResult = .failure(.noInternet)
                    
                    expect(dataStoreServiceMock.fetchRemarksCalled) == false
                    expect(homePresenterMock.showAlertCalled) == false
                    expect(homePresenterMock.loadRemarkCalled) == false
                    expect(homePresenterMock.loadRemarkAnnotations).to(beNil())

                    viewModel.viewWillAppear()
                    
                    expect(dataStoreServiceMock.fetchRemarksCalled) == true
                    expect(homePresenterMock.showAlertCalled) == true
                    expect(homePresenterMock.loadRemarkCalled) == false
                    expect(homePresenterMock.loadRemarkAnnotations).to(beNil())
                }
            }
        } // describe("The ViewModel can fetch remarks and update the view controller with the remarks.")
        
        describe("The ViewModel can searching for remarks.") {
            context("When input string contains user name") {
                it("should show filter annotation") {
                    let firstRemark = RemarkPO(withUserName: "user", note: "note", latitude: 0.0, longitude: 0.0)
                    let secondRemark = RemarkPO(withUserName: "test", note: "Testing", latitude: 0.0, longitude: 0.0)
                    dataStoreServiceMock.fetchRemarksResult = .success([firstRemark, secondRemark])
                    
                    expect(homePresenterMock.loadRemarkCalled) == false
                    expect(homePresenterMock.loadRemarkAnnotations).to(beNil())
                    
                    viewModel.viewWillAppear()
                    viewModel.searchBarDidSearch(text: "use")
                    
                    expect(homePresenterMock.loadRemarkCalled) == true
                    expect(homePresenterMock.loadRemarkAnnotations?.count) == 1
                    expect(homePresenterMock.loadRemarkAnnotations?.first?.title) == "user"
                    expect(homePresenterMock.loadRemarkAnnotations?.first?.note) == "note"
                }
            }
            
            context("When input string contains note") {
                it("should show filter annotation") {
                    let firstRemark = RemarkPO(withUserName: "user", note: "note", latitude: 0.0, longitude: 0.0)
                    let secondRemark = RemarkPO(withUserName: "test", note: "Testing", latitude: 0.0, longitude: 0.0)
                    dataStoreServiceMock.fetchRemarksResult = .success([firstRemark, secondRemark])
                    
                    expect(homePresenterMock.loadRemarkCalled) == false
                    expect(homePresenterMock.loadRemarkAnnotations).to(beNil())
                    
                    viewModel.viewWillAppear()
                    viewModel.searchBarDidSearch(text: "Test")
                    
                    expect(homePresenterMock.loadRemarkCalled) == true
                    expect(homePresenterMock.loadRemarkAnnotations?.count) == 1
                    expect(homePresenterMock.loadRemarkAnnotations?.first?.title) == "test"
                    expect(homePresenterMock.loadRemarkAnnotations?.first?.note) == "Testing"
                }
            }
            
            context("When input string is all Caps") {
                it("should show filter annotation") {
                    let firstRemark = RemarkPO(withUserName: "user", note: "note", latitude: 0.0, longitude: 0.0)
                    let secondRemark = RemarkPO(withUserName: "test", note: "hello", latitude: 0.0, longitude: 0.0)
                    dataStoreServiceMock.fetchRemarksResult = .success([firstRemark, secondRemark])
                    
                    expect(homePresenterMock.loadRemarkCalled) == false
                    expect(homePresenterMock.loadRemarkAnnotations).to(beNil())
                    
                    viewModel.viewWillAppear()
                    viewModel.searchBarDidSearch(text: "HELLO")
                    
                    expect(homePresenterMock.loadRemarkCalled) == true
                    expect(homePresenterMock.loadRemarkAnnotations?.count) == 1
                    expect(homePresenterMock.loadRemarkAnnotations?.first?.title) == "test"
                    expect(homePresenterMock.loadRemarkAnnotations?.first?.note) == "hello"
                }
            }
        } // describe("The ViewModel can searching for remarks")
    }
}


// MARK: Mocks

private class HomePresenterMock: HomePresenter {
    var loadRemarkCalled = false
    var loadRemarkAnnotations: [Remark]?
    var showAlertCalled = false
    
    func loadRemark(annotations: [Remark]) {
        loadRemarkCalled = true
        loadRemarkAnnotations = annotations
    }
    
    func showAlert(forError error: ServiceError) {
        showAlertCalled = true
    }
}

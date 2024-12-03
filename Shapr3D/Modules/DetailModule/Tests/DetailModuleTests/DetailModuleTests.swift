//  FileDetailViewControllerTests.swift
//  DetailModule
//
//  Created by Rizvi Naqvi on 18/11/2024.
//


import XCTest
import UseCasesProtocols
import Entities

@testable import DetailModule

class FileDetailViewControllerTests: XCTestCase {
    var viewController: FileDetailViewController!
    var mockViewModel: MockViewModel!
    var mockRouter: MockRouter!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockViewModel()
        mockRouter = MockRouter()
        viewController = FileDetailViewController(viewModel: mockViewModel, router: mockRouter)
        viewController.loadViewIfNeeded() // Ensures viewDidLoad is called
    }
    
    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testViewControllerInitialization() {
        XCTAssertNotNil(viewController)
        XCTAssertNotNil(viewController.viewModel)
        XCTAssertNotNil(viewController.router)
    }
    
    func testDismissPopup() {
        let expectation = expectation(description: "Dismiss called")
        viewController.dismiss(animated: true) {
            expectation.fulfill()
        }
        viewController.dismissPopup()
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testUIComponentsLoaded() {
        
        XCTAssertNotNil(viewController.fileImage)
        XCTAssertNotNil(viewController.tableView)
        XCTAssertNotNil(viewController.sizeValueLabel)
        XCTAssertNotNil(viewController.titleLabel)
        XCTAssertNotNil(viewController.cancelButton)
    }
    
    func testBindingViewModelCallbacks() {
        let progressUpdateExpectation = expectation(description: "Progress updated")
        
        mockViewModel.onProgressUpdateType = { index in
            XCTAssertEqual(index, 1)
            progressUpdateExpectation.fulfill()
        }
        
        mockViewModel.onProgressUpdateType?(1)
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testButtonActions() {
 
        let values: [ImportedFilesModel] = [
            ImportedFilesModel(name: "abc", size: "10MB", pathUrl: ".../as.shapr", convetedFilesObj: [ConvertedFilesModel(exportOptions: (.OBJ,.zero), size: "20MB", pathUrl: ".../as.shapr")], pathIndexRow: 0),
            ImportedFilesModel(name: "aabc", size: "20MB", pathUrl: ".../as1.shapr", convetedFilesObj: [ConvertedFilesModel(exportOptions: (.OBJ,.zero), size: "20MB", pathUrl: ".../as.shapr")], pathIndexRow: 1),
        ]
        
        mockViewModel.myFiles.selectedIndex = 0
        mockViewModel.myFiles.model = values
        
        // Simulate button taps
        viewController.convertActionButton(sender: UIButton())
        XCTAssertTrue(mockViewModel.convertFileCalled)
        
        viewController.shareActionButton(sender: UIButton())
        XCTAssertTrue(mockViewModel.shareFileCalled)
        
        viewController.cancelButtonActionButton(sender: UIButton())
        XCTAssertTrue(mockViewModel.cancelFileCalled)
    }}


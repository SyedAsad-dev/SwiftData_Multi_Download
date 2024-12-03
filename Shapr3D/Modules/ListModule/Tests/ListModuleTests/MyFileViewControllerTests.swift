//
//  MyFileViewControllerTests.swift
//  ListModule
//
//  Created by Rizvi Naqvi on 18/11/2024.
//

import XCTest
import Common
import Entities
@testable import ListModule

final class MyFileViewControllerTests: XCTestCase {
    
    private var viewModelMock: MyFileViewModelMock!
    private var routerMock: FileListRouterMock!
    private var sut: MyFileViewController! // System Under Test
    
    override func setUp() {
        super.setUp()
        viewModelMock = MyFileViewModelMock()
        routerMock = FileListRouterMock(container: DIContainer())
        sut = MyFileViewController(viewModel: viewModelMock, router: routerMock)
        _ = sut.view // Load the view hierarchy
    }
    
    override func tearDown() {
        viewModelMock = nil
        routerMock = nil
        sut = nil
        super.tearDown()
    }
    
    func test_showDetails_CallsRouter() {
        sut.router?.showDetails(for: SelectedFileModel(model: [], selectedIndex: 1), delegate: sut, view: UIView())
        XCTAssertTrue(routerMock.isShowDetailsCalled)
        
    }
    
    func testDidTapImportButton_PresentsDocumentPicker() {
        sut.didTapImportFileButton()
        XCTAssertTrue(sut.presentedViewController is UIDocumentPickerViewController)
    }
    
    func testCollectionView_DataSourceAndDelegateSet() {
        XCTAssertNotNil(sut.collectionView.dataSource)
        XCTAssertNotNil(sut.collectionView.delegate)
    }
    
    func testCollectionViewNumberOfItems_ReturnsCorrectCount() {
        let values: [ImportedFilesModel] = [
            ImportedFilesModel(name: "abc", size: "10MB", pathUrl: ".../as.shapr", convetedFilesObj: [], pathIndexRow: 0),
            ImportedFilesModel(name: "aabc", size: "20MB", pathUrl: ".../as1.shapr", convetedFilesObj: [], pathIndexRow: 1),
        ]
        viewModelMock.myFileList.value = values
        
        let itemCount = sut.collectionView(sut.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(itemCount, 2)
    }
}

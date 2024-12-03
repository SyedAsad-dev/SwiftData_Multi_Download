//
//  MyFileViewModel.swift
//  ListModule
//
//  Created by Rizvi Naqvi on 18/11/2024.
//

import XCTest
import Common
import Entities
@testable import ListModule


final class MyFileViewModelTests: XCTestCase {
    
    private var saveUseCaseMock: SaveImportedFileUseCaseMock!
    private var retrieveUseCaseMock: RetrieveAllImportedFileUseCaseMock!
    private var sut: MyFileViewModel! // System Under Test
    
    override func setUp() {
        super.setUp()
        saveUseCaseMock = SaveImportedFileUseCaseMock()
        retrieveUseCaseMock = RetrieveAllImportedFileUseCaseMock()
        sut = MyFileViewModel(
            saveImportedFileUseCase: saveUseCaseMock,
            retrieveAllImportedFileUseCase: retrieveUseCaseMock
        )
    }
    
    override func tearDown() {
        saveUseCaseMock = nil
        retrieveUseCaseMock = nil
        sut = nil
        super.tearDown()
    }
    
    func testRetrieveAllFiles_OnInit_UpdatesFileList() async {
        retrieveUseCaseMock.mockResult = [
            ImportedFilesModel(name: "File1", size: "10MB", pathUrl: "", thumnail_image: UIImage(named:"thumbnailPhoto"), convetedFilesObj: [], pathIndexRow: 0)
        ]
                 sut.retrieveAllFiles()
                sleep(3)
                XCTAssertEqual(sut.myFileList.value.count, 1)
                XCTAssertEqual(sut.myFileList.value.first?.name, "File1")
            
        }
    
    func testImportedFiles_AddsFilesToList() {
        let fileURLs = [URL(fileURLWithPath: "/path/to/file1.shapr"), URL(fileURLWithPath: "/path/to/file2.shapr")]
        sut.importedFiles(urls: fileURLs)
        sleep(3)
        XCTAssertEqual(sut.myFileList.value.count, 2)
        XCTAssertTrue(saveUseCaseMock.isExecuteCalled)
    }
    
}

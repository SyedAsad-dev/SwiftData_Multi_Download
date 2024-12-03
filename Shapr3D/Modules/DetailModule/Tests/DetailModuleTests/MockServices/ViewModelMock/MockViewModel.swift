//
//  MockViewModel.swift
//  DetailModule
//
//  Created by Rizvi Naqvi on 18/11/2024.
//

import XCTest
import Utils
import Entities

@testable import DetailModule

class MockViewModel: FileDetailViewModelType {
    var myFiles = SelectedFileModel(model: [], selectedIndex: -1)
    var error = Observable<String?>(nil)
    var isLoading = Observable<Bool>(false)
    var onProgressUpdateType: ((Int) -> Void)?
    var onProgressUpdateFile: ((ProgressModel) -> Void)?
    
    var convertFileCalled = false
    var shareFileCalled = false
    var cancelFileCalled = false
    
    func convertFile(index: Int) {
        convertFileCalled = true
    }
    
    func shareConvertedFile(urlString: String, controller: UIViewController, barButtonItem: UIView) {
        shareFileCalled = true
    }
    
    func cancelConvertFile(model: ConversionFileIDs) {
        cancelFileCalled = true
    }
}

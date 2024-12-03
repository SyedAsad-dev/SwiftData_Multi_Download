//
//  MyFileViewModelMock.swift
//  ListModule
//
//  Created by Rizvi Naqvi on 18/11/2024.
//
import ListModule
import UIKit
import Entities
import Utils

final class MyFileViewModelMock: MyFileViewModelType {
    var myFileList: Observable<ImportedFilesModelList> = .init([]) // List of
    var isBindCalled = false
    
    func importedFiles(urls: [URL]) {}
    
    func bind(_ completion: @escaping () -> Void) {
        isBindCalled = true
    }
}

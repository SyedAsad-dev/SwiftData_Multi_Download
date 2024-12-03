//
//  FileListRouterMock.swift
//  ListModule
//
//  Created by Rizvi Naqvi on 18/11/2024.
//
import Entities
import Utils
import UIKit
import Protocols
import ListModule
import Common

final class FileListRouterMock: FileListRouterProtocol {
    
    var container: any DIContainerService
    
    var navigationController: UINavigationController?
    
    var isShowDetailsCalled = false
    
    public init(container: DIContainerService,
                navigationController: UINavigationController? = nil) {
        self.container = container
        self.navigationController = navigationController
    }
    
    
    func showDetails(for model: SelectedFileModel, delegate: any MyFileDetailViewControllerDelegate, view: UIView) {
        isShowDetailsCalled = true
    }
}

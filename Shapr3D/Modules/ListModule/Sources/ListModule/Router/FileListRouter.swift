//
//  UniversityListRouter.swift
//  Universities
//
//  Created by Rizvi Naqvi on 07/05/2024.
//

import UIKit
import Entities
import Utils
import Common

// MARK: - Router
public protocol FileListRouterProtocol: AnyObject, CommonNavigationService {
    func showDetails(for file: SelectedFileModel, delegate: MyFileDetailViewControllerDelegate, view: UIView)
}

public final class FileListRouter: FileListRouterProtocol {
    
    public var navigationController: UINavigationController?
    public var container: DIContainerService

    public init(container: DIContainerService,
                navigationController: UINavigationController? = nil) {
        self.container = container
        self.navigationController = navigationController
    }
    
}

extension FileListRouter {

    public func showDetails(for file: SelectedFileModel, delegate: MyFileDetailViewControllerDelegate, view: UIView) {
            let appNavigationService =  container.resolve(type: NavigationService.self)!
            appNavigationService.openDetailViewController(model: file, delegate: delegate, view: view)
    }
    
}


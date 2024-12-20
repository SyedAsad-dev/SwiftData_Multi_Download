//
//  UniversityDetailRouter.swift
//  Universities
//
//  Created by Rizvi Naqvi on 07/05/2024.
//

import UIKit
import Common
import Entities
import Utils

// MARK: - Router
public protocol FileDetailRouterProtocol: AnyObject, CommonNavigationService {
    func dissmissDetails()
}


public final class FileDetailRouter: FileDetailRouterProtocol {
    public var navigationController: UINavigationController?
    public var container: DIContainerService
    
    public init(container: DIContainerService, navigationController: UINavigationController? = nil) {
        self.container = container
        self.navigationController = navigationController
    }
    
}

extension FileDetailRouter {
    public func dissmissDetails() {
            let appNavigationService = container.resolve(type: NavigationService.self)!
            appNavigationService.dismissViewController(animated: true)
    }
}

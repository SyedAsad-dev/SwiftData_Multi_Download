//
//  NavigationService.swift
//  MainApp
//
//  Created by Batikan Sosun on 14.03.2023.
//

import Foundation
import UIKit
import Utils

public protocol NavigationService: ExternalNavigationService {
    var navigationController: UINavigationController { get set }
    var container: DIContainerService { get set }
    func dismissViewController(animated: Bool)
}



public protocol PresentableView {
    func toPresent() -> UIViewController
}

public extension PresentableView where Self: UIViewController {
    func toPresent() -> UIViewController {
        return self
    }
}


public protocol PresentableListView: PresentableView {
}
public protocol PresentableDetailView: PresentableView {
    func passData(model: Any, delegate: Any)
}

// MARK: - Delegate
public protocol MyFileDetailViewControllerDelegate: AnyObject {
    func didUpdateProgress(for model: Any)
}




public protocol ExternalNavigationService {
    func openListViewController()
    func openDetailViewController(model: Any, delegate: Any, view: Any)
}



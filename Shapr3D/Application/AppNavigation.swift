//
//  AppNavigation.swift
//  MainApp
//
//  Created by Batikan Sosun on 14.03.2023.
//
import UIKit
import Foundation
import Common
import ListModule
import DetailModule
import Entities


class AppNavigation: NavigationService, ExternalNavigationService {

    var navigationController: UINavigationController
    var container: DIContainerService
    
    init(navigationController: UINavigationController, container: DIContainerService) {
        self.navigationController = navigationController
        self.container = container
    }
    
     func openListViewController() {
            let listNavigationService = container.resolve(type: PresentableListView.self)!
            let viewController = listNavigationService.toPresent()
            navigationController.show(viewController, sender: nil)
    }
    
    func openDetailViewController(model: Any, delegate: Any, view: Any) {
            let detailNavigationService = container.resolve(type: PresentableDetailView.self)!
            detailNavigationService.passData(model: model, delegate: delegate)
            
            let popoverVC = detailNavigationService.toPresent()
        popoverVC.modalPresentationStyle = .popover
        if popoverVC.popoverPresentationController?.delegate == nil {
            if let popoverController = popoverVC.popoverPresentationController {
                if let rootViewController = delegate as? UIViewController {
                    
                    if let rootViewControllerDelegate  = delegate as? UIPopoverPresentationControllerDelegate {
                        if let validSourceView = view as? UIView {
                            
                            popoverController.delegate = rootViewControllerDelegate
                            
                            popoverController.sourceView = validSourceView // Anchor popover to a specific view
                            
                            popoverController.sourceRect = validSourceView.bounds// Anchor point// Anchor point
                            popoverController.permittedArrowDirections = .any
                        }
                    }
                    rootViewController.present(popoverVC, animated: true, completion: nil)
                }
            }
        }

    }
    

    func dismissViewController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
}

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
            
                // Configure the popover presentation controller
                if let popoverController = popoverVC.popoverPresentationController {
                    // Use a specific source view (e.g., button, cell, or self.view)
                    if let validSourceView = view as? UIView { // Ensure the view is valid
                        popoverController.sourceView = validSourceView
                        popoverController.sourceRect = validSourceView.bounds
                        popoverController.permittedArrowDirections = .up
                    } else {
                        return // Exit early to prevent crash
                    }
                    
                } else {
                    return // Exit early to prevent crash
                }
            
            // Ensure `navigationController` and `viewControllers.first` are valid
            if let rootViewController = delegate as? UIViewController {
                if navigationController.viewControllers.contains(popoverVC)  {
                    popoverVC.dismiss(animated: true) {
                        rootViewController.present(popoverVC, animated: true, completion: nil)
                    }
                } else {
                    rootViewController.present(popoverVC, animated: true, completion: nil)
                }
                
            } else {
            }

    }
    

    func dismissViewController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
}

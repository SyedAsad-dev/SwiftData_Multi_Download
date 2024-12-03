//
//  RouterMock.swift
//  DetailModule
//
//  Created by Rizvi Naqvi on 18/11/2024.
//
import Entities
import Common
import Protocols
import DetailModule
import UIKit

class MockRouter: FileDetailRouterProtocol {
    
    var container: any DIContainerService
    var navigationController: UINavigationController?
    
    init(container: any DIContainerService = DIContainer()) {
        self.container = container
    }
    
    func dissmissDetails() {
        
    }

}

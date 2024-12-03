//
//  AppLoad.swift
//  Universities
//
//  Created by Rizvi Naqvi on 13/05/2024.
//

import Foundation
import UIKit
import Common
import ListModule
import DetailModule
import Data
import Protocols
import UseCases
import UseCasesProtocols
import Utils
import SwiftData
import Entities

@MainActor
class AppLoad {
    private let navigationController: UINavigationController
    var appNavigationService: NavigationService?
    var coreDataManager: MyFilesCoreDataProtocols?
    var coreDataManagerFactoryProtocol : CoreDataManagerFactoryProtocol
    var window: UIWindow?
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.coreDataManagerFactoryProtocol = CoreDataManagerFactory()
    }
    
    func build(window: UIWindow) {
        self.window = window
        setRootViewController()
    }
    
    private func setRootViewController() {
        // Initialize ModelActor on a background thread
        Task {
            coreDataManager =  await coreDataManagerFactoryProtocol.create()
            registerModuleNavigation()
            await performTaskOnMainThread()
        }
    }

    
    private func performTaskOnMainThread() async {
        await MainActor.run {
            window?.rootViewController =  navigationController
            window?.makeKeyAndVisible()
            appNavigationService?.openListViewController()
        }
    }
    
    private func registerModuleNavigation() {
        let container = DIContainer()
        container.register(type: NavigationService.self) { _ in
            AppNavigation(navigationController: self.navigationController, container: container)
        }

        container.register(type: PresentableListView.self) { _ in
            let view: MyFileViewController = ConfigList.createViewController()
             let initaliationOfRepository = ImportedFileRepository(dataSource: self.coreDataManager!)
            view.viewModel = MyFileViewModel(saveImportedFileUseCase: SaveImportedFileUseCase(repository: initaliationOfRepository), retrieveAllImportedFileUseCase: RetriveAllImportedFileUseCase(repository: initaliationOfRepository))
            view.router = FileListRouter(container: container, navigationController: self.navigationController)
            
         return view

        }
        
        container.register(type: PresentableDetailView.self) { _ in
            let view: FileDetailViewController = ConfigDetail.createViewController()
          let initaliationOfRepository = ImportedFileRepository(dataSource: self.coreDataManager!)
            view.viewModel = FileDetailViewModel(conversionFileUseCase: FileConversionUseCase(repository: FileConvertRepository(dataSource: FileConvertManager()), systemInfoService: SystemInfoService()), updateConvertFileUseCase: UpdateConvertFileUseCase(repository: initaliationOfRepository), urlSharingService: URLSharingService())
          view.router = FileDetailRouter(container: container, navigationController: self.navigationController)
            
         return view

        }

        appNavigationService =   container.resolve(type: NavigationService.self)!
    }
}

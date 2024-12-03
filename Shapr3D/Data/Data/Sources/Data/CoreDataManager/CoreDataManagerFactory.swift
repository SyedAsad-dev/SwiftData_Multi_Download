//
//  CoreDataManagerFactory.swift
//  Data
//
//  Created by Rizvi Naqvi on 20/11/2024.
//

// CoreDataManager Factory for initialization

import SwiftData
import Entities
import Foundation

public protocol CoreDataManagerFactoryProtocol {
      func create() async -> MyFilesCoreDataManager
}

public class CoreDataManagerFactory: CoreDataManagerFactoryProtocol {
    public  init() {}

     public  func create() async -> MyFilesCoreDataManager {
         let modelContainer = try! ModelContainer(for:  CDImportFile.self, CDConvertFile.self)
         let coreDataOnBackgroundThread : BackgroundDatabase = BackgroundDatabase {
             return MyFilesCoreDataManager(modelContainer: modelContainer)
         }
         return await coreDataOnBackgroundThread.withCoreModel()
    }
}

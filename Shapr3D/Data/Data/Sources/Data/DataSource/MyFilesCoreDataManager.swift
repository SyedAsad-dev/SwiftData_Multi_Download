//
//  MyFilesCoreData.swift
//  Data
//
//  Created by Rizvi Naqvi on 13/11/2024.
//

import Foundation
import CoreData
import Entities
import Protocols
import SwiftData

public protocol Database: Sendable {
    func withCoreModel() async -> MyFilesCoreDataManager
}

typealias CoreDataProtocols = MyFilesCoreDataProtocols

@ModelActor
public actor MyFilesCoreDataManager: CoreDataProtocols {

    public func getAll<T: PersistentModel>() throws -> [T]? {
        
        let fetchDescriptor = FetchDescriptor<T>()
        do {
            let data = try modelContext.fetch(fetchDescriptor)

            return data
        } catch {
            return []
        }
    }

    public func create<T: PersistentModel>(todo: [T]) throws {
           _ = todo.map{modelContext.insert($0)}
            saveContext()
     
    }
    
    public func update<T: PersistentModel>(importFileId: String, convertFileId: String, convertFileObj: T) {
        // Step 1: Fetch the CDImportFile object by its ID
        let fetchDescriptor = FetchDescriptor<CDImportFile>(predicate: #Predicate { movie in
            movie.fileLocation == importFileId
        })
        
        do {
            // Step 2: Fetch the CDImportFile
            let results = try modelContext.fetch(fetchDescriptor)
            
            
            
            // Step 3: Check if the CDImportFile is found
            if let importFile = results.first {
                // Step 4: Find the specific CDConvertFile in the convertedFiles array by its ID
                if let convertFile = importFile.convertedFiles.first(where: { $0.fileLocation == convertFileId }) {
                    if let ccc = convertFileObj as? CDConvertFile{
                        // Step 5: Update the properties of the found CDConvertFile object
                        convertFile.progress = ccc.progress
                        convertFile.status = ccc.status
                        convertFile.fileLocation = ccc.fileLocation
                        convertFile.size = ccc.size
                        
                        // Step 6: Save the context to persist the changes
                        saveContext()
                    }
                } else {
                }
            } else {
            }
        } catch {
        }
    }

    
  
    private func saveContext(){
        do {
            try modelContext.save()
       } catch {
       }
    }
    
}

public final class BackgroundDatabase {
    
  private actor DatabaseContainer {
      internal let factory: @Sendable () -> MyFilesCoreDataManager
      internal var wrappedTask: Task< MyFilesCoreDataManager, Never>?
  
      internal init(factory: @escaping @Sendable () -> MyFilesCoreDataManager) {
      self.factory = factory
    }
  
      internal var database: MyFilesCoreDataManager {
      get async {
        if let wrappedTask {
          return await wrappedTask.value
        }
        let task = Task {
          factory()
        }
        self.wrappedTask = task
        return await task.value
      }
    }
      
  }

    private let container: DatabaseContainer

    private var database: MyFilesCoreDataManager {
    get async {
      await container.database
    }
  }

    public init(_ factory: @Sendable @escaping () -> MyFilesCoreDataManager) {
    self.container = .init(factory: factory)
  }
  
    public func withCoreModel() async -> MyFilesCoreDataManager
  { await self.database }
}


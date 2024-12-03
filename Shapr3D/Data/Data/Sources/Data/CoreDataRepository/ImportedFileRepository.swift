//
//  File.swift
//  Data
//
//  Created by Rizvi Naqvi on 13/11/2024.
//

import Foundation
import Entities
import Protocols
import Utils
import UIKit
import SwiftData

public protocol MyFilesCoreDataProtocols {
 func getAll() async throws -> [CDImportFile]?
 func create(todo: [CDImportFile]) async throws -> ()
 func update(importFileId: String, convertFileId: String, convertFileObj: CDConvertFile) async throws -> ()
//    func withModelContext<T>(_ closure: @Sendable @escaping (ModelContext) throws -> T)
//      async rethrows -> T
}

public struct ImportedFileRepository: ImportedFilesCoreDataRepositoryProtocols {

        
   public init(dataSource: MyFilesCoreDataProtocols) {
        self.dataSource = dataSource
    }

    var dataSource: MyFilesCoreDataProtocols

    public func createList(_ todo: [CDImportFile]) async  ->  Result<Bool, CoreDataError>   {
        do{
            try  await dataSource.create(todo: todo)
            return .success(true)
        }catch{
            return .failure(.CreateError)
        }

    }
    
    public func getList() async -> Result<[CDImportFile]?, CoreDataError> {
        do{
            let _todos =  try  await dataSource.getAll()
            return .success(_todos)
        }catch{
            return .failure(.FetchError)
        }
    }
    
    public func updateList(_ importFileId: String, convertFileId: String, convertFileObj: CDConvertFile) async -> Result<Bool, CoreDataError> {
        do{
            try await dataSource.update(importFileId: importFileId, convertFileId: convertFileId, convertFileObj: convertFileObj)
            return .success(true)
        }catch{
            return .failure(.CreateError)
        }
    }
}

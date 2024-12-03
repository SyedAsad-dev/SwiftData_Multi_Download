//
//  Untitled.swift
//  Domain
//
//  Created by Rizvi Naqvi on 13/11/2024.
//

import Foundation
import Entities
import Utils

public protocol ImportedFilesCoreDataRepositoryProtocols {
   func getList() async throws -> Result<[CDImportFile]?, CoreDataError>
    func updateList(_ importFileId: String, convertFileId: String, convertFileObj: CDConvertFile) async -> Result<Bool, CoreDataError>
    @discardableResult func createList(_ list: [CDImportFile]) async -> Result<Bool, CoreDataError>
}

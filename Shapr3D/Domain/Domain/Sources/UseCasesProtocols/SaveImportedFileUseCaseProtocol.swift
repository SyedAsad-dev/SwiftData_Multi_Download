//
//  File.swift
//  
//
//  Created by Rizvi Naqvi on 12/09/2024.
//

import Entities
import Utils

public protocol SaveImportedFileUseCaseProtocol {
    func execute(_ model: ImportedFilesModelList) async throws -> Result<Bool, CoreDataError>
}

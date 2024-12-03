//
//  SaveImportedFileUseCaseMock.swift
//  ListModule
//
//  Created by Rizvi Naqvi on 18/11/2024.
//

import UseCasesProtocols
import Entities
import Utils

final class SaveImportedFileUseCaseMock: SaveImportedFileUseCaseProtocol {
var isExecuteCalled = false
    
    func execute(_ model: ImportedFilesModelList) -> Result<Bool, CoreDataError> {
        isExecuteCalled = true
        return .success(true)
    }
}

//
//  RetrieveAllImportedFileUseCaseMock.swift
//  ListModule
//
//  Created by Rizvi Naqvi on 18/11/2024.
//

import UseCasesProtocols
import Entities

final class RetrieveAllImportedFileUseCaseMock: RetriveAllImportedFileUseCaseProtocol {
    var mockResult: ImportedFilesModelList = []
    
    func execute() async throws -> ImportedFilesModelList {
        return mockResult
    }
}

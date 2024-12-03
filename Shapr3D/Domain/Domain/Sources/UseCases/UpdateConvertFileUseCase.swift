//
//  Untitled.swift
//  Domain
//
//  Created by Rizvi Naqvi on 15/11/2024.
//

import Foundation
import Entities
import Utils
import UseCasesProtocols
import Protocols

public class UpdateConvertFileUseCase: UpdateConvertFileUseCaseProtocol {

    private let repository: ImportedFilesCoreDataRepositoryProtocols

    public init(repository: ImportedFilesCoreDataRepositoryProtocols) {
        self.repository = repository
    }

    public func execute(_ importFileId: String, convertFileId: String, model: ConvertedFilesModel) async throws -> Result<Bool, CoreDataError> {
        return await repository.updateList(importFileId, convertFileId: convertFileId, convertFileObj: transformModelToSwiftData(model))
    }
    
    func transformModelToSwiftData(_ model: ConvertedFilesModel) -> CDConvertFile {
        var tempProgress: Float = 0
        switch model.exportOptions.1 {
        case .progress(let progress):
            tempProgress = progress
        default: break
        }
        
      return CDConvertFile(id: model.id, name: model.exportOptions.0.rawValue, progress: tempProgress, size: model.size, fileLocation: model.pathUrl, status: model.exportOptions.1.toString())

    }
}

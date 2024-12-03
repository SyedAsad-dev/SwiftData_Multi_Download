//
//  File.swift
//  
//
//  Created by Rizvi Naqvi on 12/09/2024.
//

//import Common
import Foundation
import Entities
import Utils
import Protocols
import UseCasesProtocols

public class SaveImportedFileUseCase: SaveImportedFileUseCaseProtocol {

    private let repository: ImportedFilesCoreDataRepositoryProtocols

    public init(repository: ImportedFilesCoreDataRepositoryProtocols) {
        self.repository = repository
    }

    public func execute(_ model: ImportedFilesModelList) async -> Result<Bool, CoreDataError> {
        return await repository.createList(transformResponseToSwiftData(model))
    }
    
    func transformResponseToSwiftData(_ model: ImportedFilesModelList) -> [CDImportFile] {
        var tranformData: [CDImportFile] = []
        for item in model {
            var imageData = Data()
            
            if let tempImageData = convertImageToData(image: item.thumnail_image, format: .jpg, quality: 1) {
                imageData = tempImageData
            }
            
           let entity = CDImportFile(id: item.id , name: item.name, size: item.size, fileLocation: item.pathUrl, thumbnail: imageData, pathIndexRow: item.pathIndexRow)
            
            var convertFile = [CDConvertFile]()
            item.convetedFilesObj.forEach {
                var tempProgress: Float = 0
                switch $0.exportOptions.1 {
                case .progress(let progress):
                    tempProgress = progress
                default: break
                }
                convertFile.append(CDConvertFile(id: $0.id, name: $0.exportOptions.0.rawValue, progress: tempProgress, size: $0.size, fileLocation: $0.pathUrl, status: $0.exportOptions.1.toString()))
            }
            entity.convertedFiles = convertFile
            tranformData.append(entity)
        }
        return tranformData

    }
    
}


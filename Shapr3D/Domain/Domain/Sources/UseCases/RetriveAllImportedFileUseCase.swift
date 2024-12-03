//
//  Untitled.swift
//  Domain
//
//  Created by Rizvi Naqvi on 13/11/2024.
//

//import Common
import Foundation
import Entities
import Utils
import UseCasesProtocols
import Protocols
import UIKit

public class RetriveAllImportedFileUseCase: RetriveAllImportedFileUseCaseProtocol {

    private let repository: ImportedFilesCoreDataRepositoryProtocols

    public init(repository: ImportedFilesCoreDataRepositoryProtocols) {
        self.repository = repository
    }

    public func execute() async throws -> ImportedFilesModelList {
        let response = try? await repository.getList().get()
        return transformSwiftDataResponseToModel(response)
    }
    
    func transformSwiftDataResponseToModel(_ model: [CDImportFile]?) -> ImportedFilesModelList {
        
        var result: ImportedFilesModelList = []
        model?.forEach({ value in
            var resultConvertedFile: ConvertedFilesModelList = []
            
            value.convertedFiles.forEach({ value2 in
                var exportStatus: ExportStatus
                if value2.progress > 0 {
                    if let convertedStatus = ExportStatus(from: "progress:\(value2.progress)") {
                        exportStatus = convertedStatus
                    } else {
                        exportStatus = .zero
                    }
                } else {
                    if let statusFromString = ExportStatus(from: value2.status) {
                        exportStatus = statusFromString
                    } else {
                        exportStatus = .zero
                    }
                }
                var exportType: ExportType
                // String to Enum
                if let exportTypeFromString = ExportType(rawValue: value2.name) {
                    exportType = exportTypeFromString
                } else {
                    exportType = .STL
                }
                
                resultConvertedFile.append(ConvertedFilesModel(exportOptions: (exportType, exportStatus), size: value2.size, pathUrl: value2.fileLocation))
            })
            var temImage: UIImage = UIImage(named: "thumbnailPhoto")!
            // Convert Data back to UIImage
            if let convertedImage = convertDataToImage(data: value.thumbnail) {
                     temImage = convertedImage
                 }
            
            result.append(ImportedFilesModel(name: value.name, size: value.size, pathUrl: value.fileLocation, thumnail_image: temImage, convetedFilesObj: resultConvertedFile, pathIndexRow: value.pathIndexRow))
        })
        
        return result

    }
}

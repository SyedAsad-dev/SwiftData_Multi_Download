//
//  ConvertedFilesModel.swift
//  Domain
//
//  Created by Rizvi Naqvi on 13/11/2024.
//

import Foundation
import UIKit
import Utils

// MARK: - Temperature
public class ConvertedFilesModel {
    public let id: UUID
    public var exportOptions: (ExportType, ExportStatus)
    public var size: String
    public var pathUrl: String
    
    public init(exportOptions: (ExportType, ExportStatus), size: String, pathUrl: String) {
        self.id = UUID()
        self.exportOptions = exportOptions
        self.size = size
        self.pathUrl = pathUrl
    }
}

public typealias ConvertedFilesModelList = [ConvertedFilesModel]


public struct ConversionFileIDs: Hashable {
    public var parentId: Int
    public var childID: Int
    
    public init(parentId: Int, childID: Int) {
        self.parentId = parentId
        self.childID = childID
    }
}

public struct ConversionFileModel: Hashable {
    
    public var conversionFileIDs: ConversionFileIDs
    public var sourceFile: URL
    public var destinationFile: URL
    public var status: ExportStatus
    
    public init(conversionFileIDs: ConversionFileIDs, sourceFile: URL, destinationFile: URL,status: ExportStatus) {
        self.conversionFileIDs = conversionFileIDs
        self.sourceFile = sourceFile
        self.destinationFile = destinationFile
        self.status = status
    }
}


public struct SelectedFileModel {
    public var model: ImportedFilesModelList
    public var selectedIndex: Int
    
    public init(model: ImportedFilesModelList, selectedIndex: Int) {
        self.model = model
        self.selectedIndex = selectedIndex
    }
}

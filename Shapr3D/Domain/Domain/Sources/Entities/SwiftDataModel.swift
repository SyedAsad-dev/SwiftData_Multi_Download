//
//  SwiftDataModel.swift
//  Data
//
//  Created by Rizvi Naqvi on 13/11/2024.
//
import SwiftData
import Foundation
import Utils

@Model
public final class CDImportFile {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var size: String
    public var fileLocation: String
    public var thumbnail: Data
    public var pathIndexRow: Int
    public var convertedFiles: [CDConvertFile] = []
    
    public init(id: UUID, name: String, size: String, fileLocation: String,thumbnail: Data,pathIndexRow: Int) {
        self.id = id
        self.name = name
        self.size = size
        self.fileLocation = fileLocation
        self.pathIndexRow = pathIndexRow
        self.thumbnail = thumbnail
    }
}

@Model
public final class CDConvertFile {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var size: String
    public var fileLocation: String
    public var progress: Float
    public var status: String
    @Relationship(inverse: \CDImportFile.convertedFiles) public var importedFile: CDImportFile?
        
    public init(id: UUID, name: String,progress: Float, size: String, fileLocation: String, status: String) {
        self.id = id
        self.name = name
        self.progress = progress
        self.size = size
        self.fileLocation = fileLocation
        self.status = status
    }
}

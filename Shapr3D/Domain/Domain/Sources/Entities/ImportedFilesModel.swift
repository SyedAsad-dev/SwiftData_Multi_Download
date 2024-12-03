//
//  ImportedFilesModel.swift
//  Domain
//
//  Created by Rizvi Naqvi on 13/11/2024.
//

import Foundation
import UIKit

// MARK: - Temperature
public class ImportedFilesModel: Hashable, Equatable {
    
    public static func == (lhs: ImportedFilesModel, rhs: ImportedFilesModel) -> Bool {
        return lhs.pathUrl == rhs.pathUrl
    }
    
   public func hash(into hasher: inout Hasher) {
           hasher.combine(pathUrl)
       }
    
    public let id: UUID
    public let name: String
    public let size: String
    
    public let pathUrl: String
    public let thumnail_image: UIImage?
    public var pathIndexRow: Int
    public var progress: Float
    public var convetedFilesObj: [ConvertedFilesModel]

    public init(name: String, size: String, pathUrl: String, thumnail_image: UIImage? = nil, convetedFilesObj: [ConvertedFilesModel], pathIndexRow: Int, progress: Float = 0.0) {
        self.id = UUID()
        self.name = name
        self.size = size
        self.pathUrl = pathUrl
        self.thumnail_image = thumnail_image
        self.convetedFilesObj = convetedFilesObj
        self.pathIndexRow = pathIndexRow
        self.progress = progress
    }
}

public typealias ImportedFilesModelList = [ImportedFilesModel]

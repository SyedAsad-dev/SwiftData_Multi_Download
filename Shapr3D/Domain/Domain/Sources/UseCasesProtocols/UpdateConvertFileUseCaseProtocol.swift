//
//  UpdateConvertFileUseCaseProtocol.swift
//  Domain
//
//  Created by Rizvi Naqvi on 15/11/2024.
//

import Entities
import Utils
import Foundation

public protocol UpdateConvertFileUseCaseProtocol {
    func execute(_ importFileId: String, convertFileId: String, model: ConvertedFilesModel) async throws -> Result<Bool, CoreDataError>
}

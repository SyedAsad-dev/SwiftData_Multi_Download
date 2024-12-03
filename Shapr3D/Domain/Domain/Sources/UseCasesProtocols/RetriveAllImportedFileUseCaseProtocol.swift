//
//  Untitled.swift
//  Domain
//
//  Created by Rizvi Naqvi on 13/11/2024.
//
import Entities

public protocol RetriveAllImportedFileUseCaseProtocol {
    func execute() async throws -> ImportedFilesModelList
}

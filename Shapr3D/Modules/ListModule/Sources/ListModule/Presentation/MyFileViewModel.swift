//
//  File.swift
//  MyFiles
//
//  Created by Rizvi Naqvi on 12/11/2024.
//

import Foundation
import Utils
import Protocols
import Entities
import UIKit
import UseCasesProtocols

// MARK: - Protocol
/// Defines the contract for the MyFileViewModel.
public protocol MyFileViewModelType {
    var myFileList: Observable<ImportedFilesModelList> { get } // Observable list of imported files
    func importedFiles(urls: [URL])                            // Handles the import of files
}

// MARK: - MyFileViewModel
/// ViewModel responsible for managing the file import and retrieval process.
public final class MyFileViewModel: MyFileViewModelType {
    
    // MARK: - Public Properties
    public let myFileList: Observable<ImportedFilesModelList> = .init([]) // List of files observable
    
    // MARK: - Private Properties
    private var fileList: Set<ImportedFilesModel> = [] // Internal list of imported files
    
    private let convertType: [ExportType] = [.STL, .STEP, .OBJ] // Supported export types
    
    public let saveImportedFileUseCase: SaveImportedFileUseCaseProtocol
    public let retrieveAllImportedFileUseCase: RetriveAllImportedFileUseCaseProtocol
    
    let thumbnailPhoto = UIImage(named: "thumbnailPhoto")
    let destinationDirectory = FileManager.default.temporaryDirectory.appendingPathComponent("ConvertedFiles")
    // MARK: - Initializer
    /// Initializes the ViewModel with required use cases.
    public init(
        saveImportedFileUseCase: SaveImportedFileUseCaseProtocol,
        retrieveAllImportedFileUseCase: RetriveAllImportedFileUseCaseProtocol
    ) {
        self.saveImportedFileUseCase = saveImportedFileUseCase
        self.retrieveAllImportedFileUseCase = retrieveAllImportedFileUseCase
        retrieveAllFiles()
    }
    
}

extension MyFileViewModel {
    
    // MARK: - Public Methods
    /// Imports files and updates the observable file list.
    /// - Parameter urls: Array of file URLs to be imported.
    public func importedFiles(urls: [URL]) {
        let data = convertDataToModel(urls)
        fileList.formUnion(data)
        myFileList.value = Array(fileList)
        saveFilesToCoreData(data)
    }
    
    // MARK: - Private Methods
    /// Saves imported files to Core Data using the provided use case.
    /// - Parameter modelData: The list of files to save.
    public func saveFilesToCoreData(_ modelData: ImportedFilesModelList) {
        Task {
            _ = try? await saveImportedFileUseCase.execute(modelData)
        }
    }
    
    /// Retrieves all previously imported files and updates the observable file list.
    public func retrieveAllFiles() {
        Task {
            do {
                let data = try await retrieveAllImportedFileUseCase.execute()
                await MainActor.run {
                    fileList.formUnion(data)
                    myFileList.value = Array(fileList)
                }
            } catch {
            }
        }
    }

    /// Converts an array of file URLs into a model list for use in the app.
    /// - Parameter urls: Array of file URLs.
    /// - Returns: A list of `ImportedFilesModel` objects.
    private func convertDataToModel(_ urls: [URL]) -> ImportedFilesModelList {
        urls.map { url in
            let lastPathComponent = url.lastPathComponent
            let fileSize = url.getFileSize() ?? "0 bytes"
            let fileName = lastPathComponent.deletingPathExtension
            let path = url.path()

            // Generate converted file objects for all supported types
            let convertedFiles = convertType.map {
                ConvertedFilesModel(
                    exportOptions: ($0, .zero),
                    size: fileSize,
                    pathUrl: generateTargetURL(originalURL: url, newFileName: "\(fileName).\($0)")
                )
            }

            return ImportedFilesModel(
                name: lastPathComponent,
                size: fileSize,
                pathUrl: path, thumnail_image: thumbnailPhoto,
                convetedFilesObj: convertedFiles,
                pathIndexRow: -1
            )
        }
    }
    
    /// Generates a target URL for a file with a new name in the same directory.
    /// - Parameters:
    ///   - originalURL: The original file URL.
    ///   - newFileName: The desired name for the file.
    /// - Returns: The full path for the new file.
    private func generateTargetURL(originalURL: URL, newFileName: String) -> String {
        do {
       
        // Ensure the destination directory exists
            try FileManager.default.createDirectory(at: destinationDirectory, withIntermediateDirectories: true, attributes: nil)

        // Define the destination file path
        let destinationFilePath = destinationDirectory.appendingPathComponent(newFileName)

        return destinationFilePath.path
            
        } catch {
            let directoryPath = originalURL.deletingLastPathComponent()
            
            let newURL = directoryPath.appendingPathComponent(newFileName)
            print("An error occurred: \(error.localizedDescription)")
            return newURL.path()
        }
    }
}

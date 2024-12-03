//
//  FileDetailViewModel.swift
//  DetailModule
//
//  Created by Rizvi Naqvi on 13/11/2024.
//

import Foundation
import Utils
import Protocols
import Entities
import UIKit
import Combine
import Common
import UseCasesProtocols


// MARK: - Protocol

/// Defines the contract for the FileDetailViewModel.
public protocol FileDetailViewModelType {
    var myFiles: SelectedFileModel { get set }
    var error: Observable<String?> { get }
    var isLoading: Observable<Bool> { get }
    var onProgressUpdateType: ((Int) -> Void)? { get set }
    var onProgressUpdateFile: ((ProgressModel) -> Void)? { get set }
    func cancelConvertFile(model: ConversionFileIDs)
    func convertFile(index: Int)
    func shareConvertedFile(urlString: String, controller: UIViewController, barButtonItem: UIView)
}

// MARK: - FileDetailViewModel

/// ViewModel for managing file conversion and sharing.
public final class FileDetailViewModel: FileDetailViewModelType {
    
    // MARK: - Properties
    
    /// Selected file data model.
    public var myFiles: SelectedFileModel = SelectedFileModel(model: [], selectedIndex: -1)
    
    /// Observable indicating loading state.
    public let isLoading: Observable<Bool> = .init(false)
    
    /// Observable for handling error messages.
    public let error: Observable<String?> = .init(nil)
    
    private var fileList: ImportedFilesModelList = []
    private let conversionFileUseCase: FileConversionUseCaseProtocol
    private let updateConvertFileUseCase: UpdateConvertFileUseCaseProtocol
    private let urlSharingService: URLSharingServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    /// Callback for type-specific progress updates.
    public var onProgressUpdateType: ((Int) -> Void)?
    
    /// Callback for detailed progress updates.
    public var onProgressUpdateFile: ((ProgressModel) -> Void)?
    
    // MARK: - Initializer
    
    /// Initializes the ViewModel with required dependencies.
    public init(conversionFileUseCase: FileConversionUseCaseProtocol,
                updateConvertFileUseCase: UpdateConvertFileUseCaseProtocol,
                urlSharingService: URLSharingServiceProtocol) {
        self.conversionFileUseCase = conversionFileUseCase
        self.updateConvertFileUseCase = updateConvertFileUseCase
        self.urlSharingService = urlSharingService
        bindProgressUpdates()
    }
    
}


extension FileDetailViewModel {
    // MARK: - Public Methods

    /// Shares a converted file using the provided URL.
    /// - Parameters:
    ///   - urlString: The file URL as a string.
    ///   - controller: The UIViewController to present the sharing UI.
    public func shareConvertedFile(urlString: String, controller: UIViewController, barButtonItem: UIView) {
        guard let url = URL(string: urlString) else { return }
        urlSharingService.shareURL(url,from: controller,barButtonItem) {}
    }

    /// Enqueues a file for conversion.
    /// - Parameter index: The index of the file to convert.
    public func convertFile(index: Int) {
        let myFile = myFiles.model[myFiles.selectedIndex]
        guard let sourceUrl = URL(string: myFile.pathUrl),
              let destinationUrl = URL(string: myFile.convetedFilesObj[index].pathUrl) else { return }

        let conversionFile = ConversionFileModel(
            conversionFileIDs: ConversionFileIDs(parentId: myFile.pathIndexRow, childID: index),
            sourceFile: sourceUrl,
            destinationFile: destinationUrl,
            status: .zero
        )
        conversionFileUseCase.enqueueFile(conversionFile)
    }

    /// Cancels a file conversion task.
    /// - Parameter model: The identifiers for the conversion task to cancel.
    public func cancelConvertFile(model: ConversionFileIDs) {
        conversionFileUseCase.cancelTask(for: model)
    }

    // MARK: - Private Methods

    /// Binds progress updates from the conversion use case to ViewModel callbacks.
    private func bindProgressUpdates() {
        conversionFileUseCase.progressPublisher
            .sink { [weak self] file in
                guard let self else { return }
                self.handleProgressUpdate(for: file)
            }
            .store(in: &cancellables)
    }

    /// Handles progress updates for a specific file.
    /// - Parameter file: The progress information for the file.
    private func handleProgressUpdate(for file: ConversionFileModel) {
        let myFile = myFiles.model[myFiles.selectedIndex]
        let convertedFile = myFile.convetedFilesObj[file.conversionFileIDs.childID]
        
        switch file.status {
        case .ready:
            convertedFile.exportOptions.1 = .ready
            saveConvertedFile(myFile.pathUrl, convertFileId: convertedFile.pathUrl, model: convertedFile)
        default:
            break
        }
        
        updateProgress(parentId: file.conversionFileIDs.parentId,
                       for: file.conversionFileIDs.childID,
                       progress: file.status)
    }

    /// Saves the converted file using the provided data.
    private func saveConvertedFile(_ importFileId: String, convertFileId: String, model: ConvertedFilesModel) {
        Task {
            do {
                _ = try await updateConvertFileUseCase.execute(importFileId, convertFileId: convertFileId, model: model)
            } catch {
            }
        }
    }

    /// Updates the progress for a specific file.
    private func updateProgress(parentId: Int, for index: Int, progress: ExportStatus) {
        let myFile = myFiles.model[parentId]
        let item = myFile.convetedFilesObj[index]
        
        item.exportOptions = (item.exportOptions.0, progress)
        if parentId == myFile.pathIndexRow {
            onProgressUpdateType?(index)
        }
        onProgressUpdateFile?(ProgressModel(
            status: (item.exportOptions.0, calculateProgress(progress: progress, parentId)),
            parentId: parentId,
            childId: index
        ))
    }

    /// Calculates the overall progress for a parent file.
    private func calculateProgress(progress: ExportStatus, _ parentId: Int) -> ExportStatus {
        switch progress {
        case .progress:
            let files = myFiles.model[parentId].convetedFilesObj
            let totalProgress = files
                .compactMap { $0.exportOptions.1.progressValue }
                .reduce(0, +)
            let inProcessCount = files.filter { $0.exportOptions.1.isProgress }.count
            return .progress(totalProgress / Float(inProcessCount))
        default:
            return progress
        }
    }
}

// MARK: - ExportStatus Extension

private extension ExportStatus {
    var isProgress: Bool {
        if case .progress = self { return true }
        return false
    }

    var progressValue: Float? {
        if case let .progress(value) = self { return value }
        return nil
    }
}

//
//  TaskManager.swift
//  Domain
//
//  Created by Rizvi Naqvi on 17/11/2024.
//

import Foundation
import Entities
import Utils
import Combine
import UIKit
import UseCasesProtocols
import Protocols

public protocol TaskManagerProtocol {
    func enqueueFile(_ file: ConversionFileModel)
    func cancelTask(for fileID: ConversionFileIDs)
}

public class TaskManager: TaskManagerProtocol {
    private let maxConcurrentTasks: Int
    private var runningTasks: [ConversionFileIDs: Task<Void, Error>] = [:]
    private var pendingFiles = Set<ConversionFileModel>()
    private let progressPublisher: PassthroughSubject<ConversionFileModel, Never>
    private let repository: FileConversionRepositoryProtocols

    public init(maxConcurrentTasks: Int, repository: FileConversionRepositoryProtocols, progressPublisher: PassthroughSubject<ConversionFileModel, Never>) {
         self.maxConcurrentTasks = maxConcurrentTasks
         self.repository = repository
         self.progressPublisher = progressPublisher
     }

    public func enqueueFile(_ file: ConversionFileModel) {
        pendingFiles.insert(file)
        startNextTaskIfNeeded()
      }
    
    func startNextTaskIfNeeded() {
         guard runningTasks.count < maxConcurrentTasks, !pendingFiles.isEmpty else { return }

         let nextFile = pendingFiles.removeFirst()
         let task = Task {
             do {
                 try await repository.convert(from: nextFile.sourceFile, to: nextFile.destinationFile, progress: { [weak self] progress in
                     self?.progressPublisher.send(ConversionFileModel(conversionFileIDs: ConversionFileIDs(parentId: nextFile.conversionFileIDs.parentId, childID: nextFile.conversionFileIDs.childID), sourceFile: nextFile.sourceFile, destinationFile: nextFile.destinationFile, status: progress >= 1.0 ? .ready : .progress(Float(progress))))
                     return .continue
                 })
             } catch let error as ConversionError {
                 // Handle error
                 switch error {
                 case .aborted:
                     progressPublisher.send(ConversionFileModel(conversionFileIDs: ConversionFileIDs(parentId: nextFile.conversionFileIDs.parentId, childID: nextFile.conversionFileIDs.childID), sourceFile: nextFile.sourceFile, destinationFile: nextFile.destinationFile, status: .cancel))

                 default:
                     progressPublisher.send(ConversionFileModel(conversionFileIDs: ConversionFileIDs(parentId: nextFile.conversionFileIDs.parentId, childID: nextFile.conversionFileIDs.childID), sourceFile: nextFile.sourceFile, destinationFile: nextFile.destinationFile, status: .failed))
                     
                 }
             }
             self.taskCompleted(for: nextFile.conversionFileIDs)
         }
         runningTasks[nextFile.conversionFileIDs] = task
     }

    
    private func taskCompleted(for file: ConversionFileIDs) {
          runningTasks[file] = nil
          startNextTaskIfNeeded()
      }

      // Method to cancel a specific task
     public func cancelTask(for file: ConversionFileIDs) {
          if let task = runningTasks[file] {
              task.cancel()  // Cancels the task
              runningTasks[file] = nil
          }
      }
}

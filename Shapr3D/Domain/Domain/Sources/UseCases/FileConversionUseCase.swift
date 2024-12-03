//
//  FileConversionUseCase.swift
//  Domain
//
//  Created by Rizvi Naqvi on 14/11/2024.
//

import Foundation
import Entities
import Utils
import Combine
import UIKit
import UseCasesProtocols
import Protocols

public class FileConversionUseCase: FileConversionUseCaseProtocol {

    private let taskManager: TaskManagerProtocol

     public var progressPublisher: PassthroughSubject<ConversionFileModel, Never>

     public init(repository: FileConversionRepositoryProtocols, systemInfoService: SystemInfoServiceProtocol) {
         self.progressPublisher = PassthroughSubject<ConversionFileModel, Never>()
         let maxConcurrentTasks = systemInfoService.getMaxConcurrentTasks()
         self.taskManager = TaskManager(maxConcurrentTasks: maxConcurrentTasks, repository: repository, progressPublisher: progressPublisher)
     }

     public func enqueueFile(_ file: ConversionFileModel) {
         taskManager.enqueueFile(file)
     }

     public func cancelTask(for file: ConversionFileIDs) {
         taskManager.cancelTask(for: file)
     }

}

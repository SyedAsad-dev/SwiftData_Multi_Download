//
//  FileConversionUseCaseProtocol.swift
//  Domain
//
//  Created by Rizvi Naqvi on 14/11/2024.
//

import Entities
import Utils
import Foundation
import Combine

public protocol FileConversionUseCaseProtocol {
    var progressPublisher: PassthroughSubject<ConversionFileModel, Never> { get }
    func cancelTask(for file: ConversionFileIDs)
    func enqueueFile(_ file: ConversionFileModel)
}

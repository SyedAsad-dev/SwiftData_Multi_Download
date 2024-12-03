//
//  FileConvertRepository.swift
//  Data
//
//  Created by Rizvi Naqvi on 14/11/2024.
//
import Foundation
import Entities
import Protocols
import Utils
import UIKit

public protocol FileConvertProtocols {
    func convert(from sourceURL: URL, to targetURL: URL,
    progress: ((_ progress: Double) -> ProgressAction)?) throws
}

public struct FileConvertRepository: FileConversionRepositoryProtocols {
    
   public init(dataSource: FileConvertProtocols) {
        self.dataSource = dataSource
    }

    var dataSource: FileConvertProtocols

    
    public func convert(from sourceURL: URL, to targetURL: URL, progress: ((Double) -> Utils.ProgressAction)?) throws {
        try dataSource.convert(from: sourceURL, to: targetURL, progress: progress)
    }
    

}

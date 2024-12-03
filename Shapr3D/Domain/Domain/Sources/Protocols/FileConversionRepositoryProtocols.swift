//
//  ConvertFileRepositoryProtocols.swift
//  Domain
//
//  Created by Rizvi Naqvi on 14/11/2024.
//

import Foundation
import Entities
import Utils

public protocol FileConversionRepositoryProtocols {
    func convert(from sourceURL: URL, to targetURL: URL,
    progress: ((_ progress: Double) -> ProgressAction)?) async throws
}

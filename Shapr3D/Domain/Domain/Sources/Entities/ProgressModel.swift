//
//  ProgressModel.swift
//  Domain
//
//  Created by Rizvi Naqvi on 14/11/2024.
//

import Foundation
import UIKit
import Utils

// MARK: - Temperature
public struct ProgressModel {
    public let id: UUID
    public let status: (ExportType,ExportStatus)
    public let parentId: Int?
    public let childId: Int

    public init(status: (ExportType,ExportStatus), parentId: Int?, childId: Int) {
        self.id = UUID()
        self.status = status
        self.parentId = parentId
        self.childId = childId
    }
}

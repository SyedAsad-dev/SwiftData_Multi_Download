//
//  Url+Extension.swift
//  Utils
//
//  Created by Rizvi Naqvi on 14/11/2024.
//

import Foundation

public extension URL {
    // Function to get file size as a formatted string
    func getFileSize() -> String? {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: self.path)
            if let fileSize = fileAttributes[.size] as? UInt64 {
                return formatFileSize(bytes: fileSize)
            }
        } catch {
        }
        return nil
    }
    
    // Function to format file size in a readable string
    func formatFileSize(bytes: UInt64) -> String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.allowedUnits = [.useKB, .useMB, .useGB] // Use desired units
        byteCountFormatter.countStyle = .file
        return byteCountFormatter.string(fromByteCount: Int64(bytes))
    }
}

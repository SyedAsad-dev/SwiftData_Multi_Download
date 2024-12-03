//
//  enums.swift
//  Utils
//
//  Created by Rizvi Naqvi on 18/11/2024.
//


// Define statuses for different cells
public enum ExportStatus: Hashable {
    case progress(Float)  // Progress in percentage
    case success
    case failed
    case ready
    case zero
    case cancel
    
    
    // Convert enum to string
    public   func toString() -> String {
           switch self {
           case .progress(let value):
               return "progress:\(value)"
           case .success:
               return "success"
           case .failed:
               return "failed"
           case .ready:
               return "ready"
           case .zero:
               return "zero"
           case .cancel:
               return "cancel"
           }
       }
}

public extension ExportStatus {
// Convert string to enum
init?(from string: String) {
    if string.starts(with: "progress:") {
        let valueString = string.replacingOccurrences(of: "progress:", with: "")
        if let value = Float(valueString) {
            self = .progress(value)
            return
        }
    } else if string == "success" {
        self = .success
        return
    } else if string == "failed" {
        self = .failed
        return
    } else if string == "ready" {
        self = .ready
        return
    } else if string == "zero" {
        self = .zero
        return
    } else if string == "cancel" {
        self = .cancel
        return
    } else {
        return nil // Invalid string
    }
    return nil
}
}

// Define statuses for different cells
public enum ExportType: String {
    case STL  // Progress in percentage
    case OBJ
    case STEP

}

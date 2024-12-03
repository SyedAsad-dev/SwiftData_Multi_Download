//
//  SystemInfoService.swift
//  Utils
//
//  Created by Rizvi Naqvi on 17/11/2024.
//

import UIKit

public protocol SystemInfoServiceProtocol {
    func getMaxConcurrentTasks() -> Int
}

public class SystemInfoService: SystemInfoServiceProtocol {
    public init() {}

    public func getMaxConcurrentTasks() -> Int {
        // Step 1: Determine max concurrent tasks based on device capabilities (e.g., CPU cores)
        let cpuCount = ProcessInfo.processInfo.processorCount
        var maxConcurrent = 2  // Default to 2 conversions
        
        if cpuCount > 2 {
            maxConcurrent = 3
        }
        
        // Step 2: Check system memory
        let usedMemory = getSystemMemoryUsage()  // Custom function to get memory usage
        if usedMemory > 800 * 1024 * 1024 { // If more than 800 MB used
            maxConcurrent = min(maxConcurrent, 2) // Limit to 2 conversions
        }
        
        // Step 3: Check battery level
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        if batteryLevel < 0.2 {
            maxConcurrent = min(maxConcurrent, 2) // Limit if battery is low
        }
        
        return maxConcurrent
    }

   public func getSystemMemoryUsage() -> Int64 {
        var size: Int = MemoryLayout<vm_statistics_data_t>.size
        var vmStats = vm_statistics_data_t()
        let result = withUnsafeMutablePointer(to: &vmStats) { pointer in
            pointer.withMemoryRebound(to: Int32.self, capacity: 1) { pointer in
                sysctlbyname("vm.stat_free", pointer, &size, nil, 0)
            }
        }
        if result == 0 {
            let usedMemory = vmStats.wire_count + vmStats.active_count
            return Int64(usedMemory)
        }
        return -1  // Indicating failure
    }
}

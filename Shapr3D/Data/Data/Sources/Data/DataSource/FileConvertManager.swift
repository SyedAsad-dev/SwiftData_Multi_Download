//
//  FileConvertManager.swift
//  Data
//
//  Created by Rizvi Naqvi on 14/11/2024.
//

import Foundation
import Utils
import Entities


public class FileConvertManager: FileConvertProtocols {

    public  init() {}

    public  func convert(from sourceURL: URL, // must be a file:// URL readable by this process
    to targetURL: URL, // must be a file:// URL writable by this process
                         progress: ((_ progress: Double) -> ProgressAction)?) throws { // progress is [0.0, 1.0] When the

    //callback is nil it behaves as if it always returned .continue
    let totalBytes: UInt64
    do {
    let attributes = try FileManager.default.attributesOfItem(atPath: sourceURL.path)
        guard let size = attributes[FileAttributeKey.size] as? UInt64 else { throw ConversionError.inputError()
    }
    totalBytes = size
    } catch { throw ConversionError.inputError(error: error) }
    let input: FileHandle
    do { input = try FileHandle(forReadingFrom: sourceURL) }
    catch { throw ConversionError.inputError(error: error) }
    guard FileManager.default.createFile(atPath: targetURL.path, contents: nil, attributes: nil) else { throw
    ConversionError.outputError() }
    let output: FileHandle
    do { output = try FileHandle(forWritingTo: targetURL) }
    catch { throw ConversionError.outputError(error: error) }
    var bytesWritten = 0
    while true {
    guard UInt.random(in: 0..<10000) != 0 else { throw ConversionError.dataError } // 0.01% chance of failure
    usleep(UInt32.random(in: 1000...10000)) // some artificial delay
    var readData: Data
    do {
    guard let data = try input.read(upToCount: 1024), !data.isEmpty else { return }
    readData = data
    } catch { throw ConversionError.inputError() }
    for i in 0..<readData.count {
    readData[i] = ~readData[i] // top secret conversion algorithm :^)
        guard !Task.isCancelled else {
            throw  ConversionError.aborted
            }
    }
    do {
        try output.write(contentsOf: readData) }
    catch { throw ConversionError.outputError(error: error) }
    bytesWritten += readData.count
        guard !Task.isCancelled else {
            throw  ConversionError.aborted
            }
        if let progress = progress, progress(Double(bytesWritten) / Double(totalBytes)) == .abort {
    throw ConversionError.aborted
    }
    }
    }
}

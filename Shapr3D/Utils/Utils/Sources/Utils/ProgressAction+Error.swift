//
//  Network+Error.swift
//  Universities
//
//  Created by Rizvi Naqvi on 07/05/2024.
//

import Foundation

public enum ProgressAction {
case `continue`
case abort // this can be returned from the progress callback to cancel an ongoing conversion
}
// Cleaning up after any error is the responsibility of the caller
public enum ConversionError: Error {
    case aborted // the conversion was cancelled by returning .abort from the progress callback
case inputError(error: Error? = nil) // something went wrong while opening/reading the input file
case outputError(error: Error? = nil) // something went wrong while opening/writing the output file
case dataError  // something went wrong with the conversion logic
}


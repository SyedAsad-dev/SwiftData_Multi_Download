//
//  Image+DataConversion.swift
//  Utils
//
//  Created by Rizvi Naqvi on 18/11/2024.
//

import UIKit

/// Converts a UIImage to Data with a specified format and quality.
/// - Parameters:
///   - image: The UIImage to be converted.
///   - format: The format of the image (e.g., .jpeg or .png).
///   - quality: Compression quality (0.0 to 1.0). Ignored for PNG format.
/// - Returns: Optional Data representation of the image.
public func convertImageToData(image: UIImage?, format: ImageFormat = .jpeg, quality: CGFloat = 1) -> Data? {
    switch format {
    case .jpeg, .jpg:
        return image?.jpegData(compressionQuality: quality)
    case .png:
        return image?.pngData()
    }
}

public func convertDataToImage(data: Data) -> UIImage? {
    return UIImage(data: data)
}

/// Supported image formats for conversion.
public enum ImageFormat {
    case jpeg
    case jpg
    case png
}

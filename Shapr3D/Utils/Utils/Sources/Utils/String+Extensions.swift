//
//  String+Extensions.swift
//  Utils
//
//  Created by Rizvi Naqvi on 16/11/2024.
//

import Foundation

public extension String {
   var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
   var pathExtension: String {
        return (self as NSString).pathExtension
    }
}

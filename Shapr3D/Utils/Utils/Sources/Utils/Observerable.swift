//
//  File.swift
//  Utils
//
//  Created by Rizvi Naqvi on 13/11/2024.
//

import Foundation

public final class Observable<T> {
    
    public typealias Listener = (T) -> Void
    
    public var listener: Listener?
    public var value: T {
        didSet {
            listener?(value)
        }
    }

    public init(_ value: T) {
        self.value = value
    }

    public func bind(listener: Listener?) {
        self.listener = listener
    }
    
    public func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}

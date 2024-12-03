//
//  URLSharingService.swift
//  Utils
//
//  Created by Rizvi Naqvi on 17/11/2024.
//

import UIKit

public protocol URLSharingServiceProtocol {
    func shareURL(_ url: URL, from viewController: UIViewController,_ barButtonItem: UIView, completion: (() -> Void)?)
}

public class URLSharingService: URLSharingServiceProtocol {
   public init(){}
    public func shareURL(_ url: URL, from viewController: UIViewController,_   barButtonItem: UIView, completion: (() -> Void)?) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        // Customize excluded activity types if needed
        activityViewController.excludedActivityTypes = [.assignToContact, .saveToCameraRoll]
        
        // Completion handler
        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            completion?()
        }
        
        // Required for iPads
           if let popoverController = activityViewController.popoverPresentationController {
               popoverController.sourceView = barButtonItem // Anchor to the bar button item
               popoverController.sourceRect = barButtonItem.bounds
           }
        
        // Present the activity view controller
        viewController.present(activityViewController, animated: true)
    }
}

//
//  PopoverSourceHandler.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/19/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit

/// Example of code needed to implement this protocol:
///
///    var popoverSourceHandler: PopoverSourceHandler?
///
///    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
///        if let popoverPresentationController = segue.destinationViewController.popoverPresentationController {
///            popoverSourceHandler = PopoverSourceHandler(owner: self, popoverPresentationController: popoverPresentationController)
///        }
///    }
///
// This is not a protocol because protocols have difficulty with also being delegates. The delegate calls never get made :/
public class PopoverSourceHandler: NSObject, UIPopoverPresentationControllerDelegate {
    unowned var owner: UIViewController
    
    public init(owner: UIViewController, source: AnyObject?, popoverPresentationController: UIPopoverPresentationController) {
        self.owner = owner
        super.init()
        popoverPresentationController.presentedViewController.preferredContentSize = PopoverValues.PreferredDefaultSize // set later to match loaded content
        popoverPresentationController.delegate = self
        popoverPresentationController.popoverBackgroundViewClass = PopoverBackgroundView.self
        popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection.Unknown
        popoverPresentationController.sourceView = source as? UIView
        popoverPresentationController.sourceRect = pickCenterRect(sourceView: source as? UIView, targetSize: PopoverValues.PreferredDefaultSize)
    }

    func pickCenterRect(sourceView sourceView: UIView?, targetSize: CGSize) -> CGRect {
        if sourceView != nil {
            var sourcePoint = CGPointMake(sourceView!.frame.origin.x + sourceView!.bounds.width, sourceView!.frame.origin.y + (sourceView!.bounds.height / 2))
            var chainView = sourceView!.superview
            while chainView != nil && chainView != owner.view {
                sourcePoint.x += chainView!.frame.origin.x
                sourcePoint.y += chainView!.frame.origin.y
                chainView = chainView?.superview
            }
            sourcePoint.x -= targetSize.width / 2
            sourcePoint.x += PopoverValues.MagicNumberCorrectPopoverRight
            sourcePoint.y -= targetSize.height / 2
            return CGRect(origin: sourcePoint, size: CGSizeMake(1, 1))
        }
        let sourcePoint = CGPointMake(owner.view.bounds.width / 2, (owner.view.bounds.height / 2))
        return CGRect(origin: sourcePoint, size: CGSizeMake(1,1))
    }
    
    public func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        //? nothing to do
    }
    
    public func popoverPresentationController(popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverToRect rect: UnsafeMutablePointer<CGRect>, inView view: AutoreleasingUnsafeMutablePointer<UIView?>) {
        let size = popoverPresentationController.presentedViewController.view.bounds.size
        rect.memory = pickCenterRect(sourceView: popoverPresentationController.sourceView, targetSize: size)
    }
}
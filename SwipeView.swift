//
//  SwipeView.swift
//  CyPhyBitDate
//
//  Created by Matt Linaberry on 5/5/15.
//  Copyright (c) 2015 Matt Linaberry. All rights reserved.
//

import Foundation
import UIKit

class SwipeView: UIView {
    
    enum Direction {
        case None
        case Left
        case Right
    }
    
    
    var innerView: UIView? {
        didSet {
            // when we set the innerView, run this code
            if let v = innerView {
                insertSubview(v, belowSubview: overlay)
                v.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            }
        }
    }
    private var originalPoint: CGPoint?  // store the original coordinates of the card
    weak var delegate: SwipeViewDelegate?
    let overlay: UIImageView = UIImageView()
    var direction: Direction?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    override init() {
        super.init()
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = UIColor.clearColor()
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dragged:"))  // adds recognition for finger swipes
        
        overlay.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(overlay)
        
    }
    
    func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        let distance = gestureRecognizer.translationInView(self)
        println("\(distance.x), \(distance.y)")
        
        // when should the view's location be reset?
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.Began:
            originalPoint = center  // center is automatically created from the UIView class!
        case UIGestureRecognizerState.Changed:
            // create a "fixed path" for the card
            let rotationPercentage = min(distance.x / (self.superview!.frame.width / 2), 1)
            let rotationAngle = (CGFloat(2 * M_PI / 16) * rotationPercentage)
            transform = CGAffineTransformMakeRotation( rotationAngle)  // transform is a UIView property
            
            
            center = CGPointMake(originalPoint!.x + distance.x, originalPoint!.y + distance.y)
            updateOverlay(distance.x)
            
        case UIGestureRecognizerState.Ended:
            
            if abs(distance.x) < frame.width / 4 {
                resetViewPositionAndTransformations()  // no real decision made!
            }
            else {
                swipe(distance.x > 0 ? .Right : .Left)
            }
        default:
            println("Some whacky state for the gesture recognizer")
            break
        }
    }
    
    func swipe(s: Direction) {
        if s == .None {
            return
        }
        var parentWidth = superview!.frame.size.width
        if s == .Left {
            parentWidth *= -1
        }
        
        // call the delegate when the animation is complete
        UIView.animateWithDuration(0.2, animations: {
            self.center.x = self.frame.origin.x + parentWidth
            }, completion: {
                success in
                // another way to test an optional!
                if let d = self.delegate {
                    // if self.delegate really does exist, then assign it do D and run this following code
                    s == .Right ? d.swipedRight() : d.swipedLeft()
                }
        })
    }
    
    private func updateOverlay(distance: CGFloat) {
        var newDirection: Direction
        newDirection = distance < 0 ? .Left : .Right
        if (newDirection != direction) {
            direction = newDirection
            overlay.image = direction == .Right ? UIImage(named: "yeah-stamp") : UIImage(named: "nah-stamp")
        }
        overlay.alpha = abs(distance) / (superview!.frame.width / 2)
    }
    
    private func resetViewPositionAndTransformations() {
        // animate this
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.center = self.originalPoint!
            self.transform = CGAffineTransformMakeRotation(0)
            self.overlay.alpha = 0
        })
    }
}

protocol SwipeViewDelegate: class {
    func swipedLeft()
    func swipedRight()
}


//
//  ViewController.swift
//  CollisionDemo
//
//  Created by Wayne Hsiao on 2018/6/30.
//  Copyright © 2018 Wayne Hsiao. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    @IBOutlet weak var cubeA: UIView! {
        didSet {
            cubeA.layer.masksToBounds = false
            cubeA.layer.cornerRadius = cubeA.frame.size.width / 2
        }
    }
    @IBOutlet weak var cubeB: UIView! {
        didSet {
            cubeB.layer.masksToBounds = false
            cubeB.layer.cornerRadius = cubeB.frame.size.width / 2
        }
    }
    
    var animator: UIDynamicAnimator!
    var pushA: UIPushBehavior!
    var pushB: UIPushBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cubeA.addGestureRecognizer(panGuesture())
        cubeB.addGestureRecognizer(panGuesture())

        animator = UIDynamicAnimator(referenceView: view)
        
        let items = [cubeA, cubeB]
        
//        let gravity = UIGravityBehavior(items: items as! [UIDynamicItem])
//        animator.addBehavior(gravity)
        
//        pushA = UIPushBehavior(items: [cubeA] as! [UIDynamicItem], mode: .instantaneous)
//        pushB = UIPushBehavior(items: [cubeB] as! [UIDynamicItem], mode: .instantaneous)
//        animator.addBehavior(pushA)
//        animator.addBehavior(pushB)
    }
    
    func panGuesture() -> UIPanGestureRecognizer {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(recognizer:)))
        return panGesture
    }
    
    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        recognizer.setTranslation(CGPoint.zero, in: view)
        
        var push: UIPushBehavior?
        if let view = recognizer.view {

            animator.removeAllBehaviors()
            
            let collision = UICollisionBehavior(items: [cubeA, cubeB])
            collision.translatesReferenceBoundsIntoBoundary = true
            animator.addBehavior(collision)
            
            switch recognizer.state {
            case .ended:
                
                let velocity = recognizer.velocity(in: view.superview)
                let x = velocity.y
                let y = velocity.x
                
                if x == 0 && y == 0 {
                    return
                }

                let pushA = UIPushBehavior(items: [cubeA] as! [UIDynamicItem], mode: .instantaneous)
                let pushB = UIPushBehavior(items: [cubeB] as! [UIDynamicItem], mode: .instantaneous)
                animator.addBehavior(pushA)
                animator.addBehavior(pushB)
                
                if view == cubeA {
                    push = pushA
                } else if view == cubeB {
                    push = pushB
                }

                let angle = atan2(x, y)
                push?.active = false
                push?.setAngle(angle, magnitude: 10)
                push?.active = true
                
            default:
                
                let center = CGPoint(x: view.center.x + translation.x,
                                      y: view.center.y + translation.y)
                
                guard self.view.frame.minX != center.x,
                    self.view.frame.maxX != center.x,
                    self.view.frame.minY != center.y,
                    self.view.frame.maxY != center.y else {
                    return
                }

                view.center = center
            }
        }
    }

    func angleOfView(_ view: UIView) -> CGFloat {
        // http://stackoverflow.com/a/2051861/1271826
       return atan2(view.transform.b, view.transform.a)
    }
}


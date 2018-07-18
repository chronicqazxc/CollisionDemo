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
    @IBOutlet weak var cubeA: UIView!
    @IBOutlet weak var cubeB: UIView!
    
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
            
            switch recognizer.state {
            case .ended:
                
                pushA = UIPushBehavior(items: [cubeA] as! [UIDynamicItem], mode: .instantaneous)
                pushB = UIPushBehavior(items: [cubeB] as! [UIDynamicItem], mode: .instantaneous)
                animator.addBehavior(pushA)
                animator.addBehavior(pushB)
                
                let collision = UICollisionBehavior(items: [cubeA, cubeB])
                collision.translatesReferenceBoundsIntoBoundary = true
                animator.addBehavior(collision)
                
                if view == cubeA {
                    push = pushA
                } else if view == cubeB {
                    push = pushB
                }
                
                /*
                 CGPoint velocity = [gesture velocityInView:gesture.view.superview];
                 
                 // if we aren't dragging it down, just snap it back and quit
                 
                 if (fabs(atan2(velocity.y, velocity.x) - M_PI_2) > M_PI_4) {
                 UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:gesture.view snapToPoint:startCenter];
                 [self.animator addBehavior:snap];
                 
                 return;
                 }
                 */
                
                let velocity = recognizer.velocity(in: view.superview)
                
                let x = velocity.y
                let y = velocity.x

                let angle = atan2(x, y)

                push?.active = false
                push?.setAngle(angle, magnitude: 10)
                push?.active = true
                break
            default:
                view.center = CGPoint(x: view.center.x + translation.x,
                                      y: view.center.y + translation.y)
                break
            }
        }
    }

    func angleOfView(_ view: UIView) -> CGFloat {
        // http://stackoverflow.com/a/2051861/1271826
       return atan2(view.transform.b, view.transform.a)
    }
}


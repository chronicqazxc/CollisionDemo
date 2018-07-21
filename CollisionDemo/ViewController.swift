//
//  ViewController.swift
//  CollisionDemo
//
//  Created by Wayne Hsiao on 2018/6/30.
//  Copyright © 2018 Wayne Hsiao. All rights reserved.
//

import UIKit
import SpriteKit

class RioundView: UIView {
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
}

class ViewController: UIViewController {
    @IBOutlet var cubeA: RioundView! {
        didSet {
            cubeA.layer.masksToBounds = false
            cubeA.layer.cornerRadius = cubeA.frame.size.width / 2
            cubeA.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            view.addSubview(cubeA)
        }
    }
    @IBOutlet var cubeB: RioundView! {
        didSet {
            cubeB.layer.masksToBounds = false
            cubeB.layer.cornerRadius = cubeB.frame.size.width / 2
            cubeB.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            view.addSubview(cubeB)
        }
    }
    
    var animator: UIDynamicAnimator!
    
    var pushA: UIPushBehavior!
    var attachment: UIAttachmentBehavior!

    var pushB: UIPushBehavior!
    var attachment2: UIAttachmentBehavior!
    
    var collision: UICollisionBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        cubeA = RioundView(frame: rect)
        cubeA.addGestureRecognizer(panGuesture())
        
        cubeB = RioundView(frame: rect)
        cubeB.addGestureRecognizer(panGuesture())

        animator = UIDynamicAnimator(referenceView: view)

        pushA = UIPushBehavior(items: [cubeA] as! [UIDynamicItem], mode: .instantaneous)
        pushB = UIPushBehavior(items: [cubeB] as! [UIDynamicItem], mode: .instantaneous)
        
        collision = UICollisionBehavior(items: [cubeA, cubeB])
        collision.collisionMode = .everything
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
    }
    
    func panGuesture() -> UIPanGestureRecognizer {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(recognizer:)))
        return panGesture
    }
    
    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        recognizer.setTranslation(CGPoint.zero, in: view)

        if let view = recognizer.view {
            
            switch recognizer.state {
            case .began:
                
                if view == cubeA, let push = pushA {
                    animator.removeBehavior(push)
                } else if view == cubeB, let push = pushB {
                    animator.removeBehavior(push)
                }
                
                let anchor = recognizer.location(in: view.superview)
                
                var cube: UIView!
                var attach: UIAttachmentBehavior!
                
                if view == cubeA {
                    cube = cubeA
                    attachment = UIAttachmentBehavior(item: cube, attachedToAnchor: anchor)
                    attach = attachment
                } else if view == cubeB {
                    cube = cubeB
                    attachment2 = UIAttachmentBehavior(item: cube, attachedToAnchor: anchor)
                    attach = attachment2
                }

                animator.addBehavior(attach)
                
            case .changed:
                let anchor = recognizer.location(in: view.superview)
                
                var attach: UIAttachmentBehavior!
                if view == cubeA {
                    attach = attachment
                } else if view == cubeB {
                    attach = attachment2
                }
                attach.anchorPoint = anchor
                
            case .ended:
                
                if view == cubeA, let attachment = attachment {
                    animator.removeBehavior(attachment)
                } else if view == cubeB, let attachment = attachment2 {
                    animator.removeBehavior(attachment)
                }
                
                let velocity = recognizer.velocity(in: view.superview)
                let x = velocity.y
                let y = velocity.x
                
                if x == 0 && y == 0 {
                    return
                }
                
                var push: UIPushBehavior!
                if view == cubeA {
                    push = pushA
                } else if view == cubeB {
                    push = pushB
                }
                
                animator.addBehavior(push)
                let angle = atan2(x, y)
                push.active = false
                push.setAngle(angle, magnitude: 10)
                push.active = true
                
            default:
//                attachment.action
//                let center = CGPoint(x: view.center.x + translation.x,
//                                      y: view.center.y + translation.y)
//
//                guard self.view.frame.minX != center.x,
//                    self.view.frame.maxX != center.x,
//                    self.view.frame.minY != center.y,
//                    self.view.frame.maxY != center.y else {
//                    return
//                }
                break
            }
        }
    }
}

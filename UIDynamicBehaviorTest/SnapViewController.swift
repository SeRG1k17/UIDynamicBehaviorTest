//
//  SnapViewController.swift
//  UIDynamicBehaviorTest
//
//  Created by Сергей Пугач on 31.08.16.
//  Copyright © 2016 Сергей Пугач. All rights reserved.
//

import UIKit

class SnapViewController: UIViewController {
    
    var box:UIView!
    var animator:UIDynamicAnimator!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor=UIColor.darkGrayColor()
        
        animator=UIDynamicAnimator(referenceView: view)
        
        box=UIView(frame: CGRectMake(100, 200, 80, 80))
        box.backgroundColor=UIColor.lightGrayColor()
        self.view.addSubview(box)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(AttachmentViewController.addPan(_:)))
        self.view.addGestureRecognizer(pan)
    }

    func addPan(pan:UIGestureRecognizer) {
        
        let point = pan.locationInView(view)
        
        if pan.state==UIGestureRecognizerState.Began || pan.state==UIGestureRecognizerState.Cancelled {
            animator.removeAllBehaviors()
            
            
        } else if pan.state==UIGestureRecognizerState.Changed {
            box.center=point
            
        } else if pan.state==UIGestureRecognizerState.Ended {
            let size = self.view.frame.size
            let lead = point.x
            let tail = size.width-point.x
            let bottom = size.height-point.y
            
            let edge = box.frame.size.width/2
            
            var newPoint = CGPoint()
            
            if lead < tail {
                if lead < bottom {
                    newPoint=CGPointMake(edge, point.y)
                } else {
                    newPoint=CGPointMake(point.x, size.height-edge)
                }
            } else {
                if tail<bottom {
                    newPoint=CGPointMake(size.width-edge, point.y)
                } else {
                    newPoint=CGPointMake(point.x, size.height-edge)
                }
            }
            let snap = UISnapBehavior(item: box, snapToPoint: newPoint)
            snap.damping=0.55
            animator.addBehavior(snap)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

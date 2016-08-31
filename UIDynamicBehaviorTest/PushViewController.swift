//
//  PushViewController.swift
//  UIDynamicBehaviorTest
//
//  Created by Сергей Пугач on 31.08.16.
//  Copyright © 2016 Сергей Пугач. All rights reserved.
//

import UIKit

class PushViewController: UIViewController {

    
    var box:UIView!
    var rope:CAShapeLayer!
    var animator:UIDynamicAnimator!
    var push:UIPushBehavior!
    
    final let BOXSIZE:CGFloat=50
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor=UIColor.darkGrayColor()
        
        animator=UIDynamicAnimator(referenceView: view)
        
        box=UIView(frame: CGRectMake(view.bounds.size.width/2-BOXSIZE/2,view.bounds.size.height/2-BOXSIZE/2, BOXSIZE, BOXSIZE))
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
            
            if rope == nil {
                rope=CAShapeLayer()
                rope.fillColor=UIColor.clearColor().CGColor
                rope.lineJoin=kCALineJoinRound
                rope.lineWidth=2.0
                rope.strokeColor=UIColor.whiteColor().CGColor
                rope.strokeEnd=1.0
                self.view.layer.addSublayer(rope)
            }
            let bezierPath = UIBezierPath()
            bezierPath.moveToPoint(point)
            bezierPath.addLineToPoint(self.view.center)
            rope.path=bezierPath.CGPath
            
        } else if pan.state==UIGestureRecognizerState.Ended {
            
            rope.removeFromSuperlayer()
            rope=nil
            
            let origin = self.view.center
            
            var distanceForMagnitude = sqrt(pow(origin.x-point.x, 2)+pow(origin.y-point.y, 2))
            let angle = atan2(origin.y-point.y, origin.x-point.x)
            
            distanceForMagnitude=max(distanceForMagnitude, 10.0)
            
            push=UIPushBehavior(items: [box], mode: .Instantaneous)
            push.magnitude=distanceForMagnitude/20
            push.angle=angle
            push.active=true
            animator.addBehavior(push)
            
            let dynamic = UIDynamicItemBehavior(items: [box])
            dynamic.elasticity=1.0
            dynamic.friction=0
            animator.addBehavior(dynamic)
            
            let gravity = UIGravityBehavior(items: [box])
            animator.addBehavior(gravity)
            
            let collision = UICollisionBehavior(items: [box])
            collision.collisionMode = .Everything
            collision.translatesReferenceBoundsIntoBoundary=true
            collision.collisionDelegate=nil
            
            animator.addBehavior(collision)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

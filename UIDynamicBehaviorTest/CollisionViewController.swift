//
//  CollisionViewController.swift
//  UIDynamicBehaviorTest
//
//  Created by Сергей Пугач on 31.08.16.
//  Copyright © 2016 Сергей Пугач. All rights reserved.
//

import UIKit

class CollisionViewController: UIViewController {

    var box1:UIView!
    var box2:UIView!
    
    var animator:UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor=UIColor.darkGrayColor()
        
        animator=UIDynamicAnimator(referenceView: view)
        
        box1=UIView(frame: CGRectMake(100, 50, 80, 80))
        box1.backgroundColor=UIColor.redColor()
        box1.transform=CGAffineTransformRotate(box1.transform, CGFloat(-M_PI_4/2))
        self.view.addSubview(box1)
        
        box2=UIView(frame: CGRectMake(150, 20, 80, 80))
        box2.backgroundColor=UIColor.whiteColor()
        box2.transform=CGAffineTransformRotate(box1.transform, CGFloat(M_PI_4/2))
        self.view.addSubview(box2)
        
        addBehavior()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(AttachmentViewController.addPan(_:)))
        self.view.addGestureRecognizer(pan)
    }
    func addPan(pan:UIGestureRecognizer) {
        
        animator.removeAllBehaviors()
        box1.center=pan.locationInView(view)
        if pan.state==UIGestureRecognizerState.Ended {
            
            addBehavior()
        }
    }
    
    func addBehavior() {
        let gravity = UIGravityBehavior(items: [box1, box2])
        animator.addBehavior(gravity)
        
        let collision = UICollisionBehavior(items: [box1, box2])
        collision.collisionMode = .Everything
        collision.translatesReferenceBoundsIntoBoundary=true
        collision.collisionDelegate=nil
        
        animator.addBehavior(collision)
        
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

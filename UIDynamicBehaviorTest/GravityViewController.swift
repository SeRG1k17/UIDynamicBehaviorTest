//
//  GravityViewController.swift
//  UIDynamicBehaviorTest
//
//  Created by Сергей Пугач on 31.08.16.
//  Copyright © 2016 Сергей Пугач. All rights reserved.
//

import UIKit

class GravityViewController: UIViewController {

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
        
        animator.removeAllBehaviors()
        box.center=pan.locationInView(view)
        
        if pan.state==UIGestureRecognizerState.Ended {
            let gravity = UIGravityBehavior(items: [box])
            animator.addBehavior(gravity)
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

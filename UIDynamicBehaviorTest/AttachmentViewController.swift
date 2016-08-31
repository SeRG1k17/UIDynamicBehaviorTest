//
//  AttachmentViewController.swift
//  UIDynamicBehaviorTest
//
//  Created by Сергей Пугач on 30.08.16.
//  Copyright © 2016 Сергей Пугач. All rights reserved.
//

import UIKit

class AttachmentViewController: UIViewController {

    var box:UIView!
    var kongCenter:UIImageView!
    var rope:CAShapeLayer!
    
    var animator:UIDynamicAnimator!
    var attachment:UIAttachmentBehavior!
    
    var isBox:Bool = true
    
    private var myContext = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor=UIColor.darkGrayColor()
        animator=UIDynamicAnimator(referenceView: view)
        
        box=UIView(frame: CGRectMake(100, 100, 80, 80))
        box.backgroundColor=UIColor.lightGrayColor()
        self.view.addSubview(box)
        
        kongCenter=UIImageView(image: UIImage(named: "Attachment"))
        kongCenter.frame=CGRectMake(0, 0, 10, 10)
        kongCenter.center=CGPoint(x:box.bounds.size.width/2-30, y:box.bounds.size.height/2-30)
        kongCenter.backgroundColor=UIColor.lightGrayColor()
        kongCenter.layer.borderWidth=2
        kongCenter.layer.borderColor=UIColor.whiteColor().CGColor
        kongCenter.layer.cornerRadius=5
        kongCenter.layer.masksToBounds=true
        box.addSubview(kongCenter)
        
        //box.addObserver(self, forKeyPath: "center'", options: NSKeyValueObservingOptions.New, context: nil)
        box.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.New, context: nil)

        let gravity = UIGravityBehavior(items: [box])
        animator.addBehavior(gravity)
        
        attachment=UIAttachmentBehavior(item: box, offsetFromCenter: UIOffsetMake(-30, -30), attachedToAnchor: CGPointMake(CGRectGetMidX(self.view.bounds), 120))
        
        attachment.length=isBox ? 60:120
        attachment.damping=0.1
        attachment.frequency=isBox ? 0.8:0
        animator.addBehavior(attachment)
        
        let collision = UICollisionBehavior(items: [box])
        collision.collisionMode = .Everything
        collision.translatesReferenceBoundsIntoBoundary=true
        collision.collisionDelegate=nil
        animator.addBehavior(collision)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(AttachmentViewController.addPan(_:)))
        self.view.addGestureRecognizer(pan)
        
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if rope == nil {
            rope=CAShapeLayer()
            rope.fillColor=UIColor.clearColor().CGColor
            rope.lineJoin=kCALineJoinRound
            rope.lineWidth=2.0
            rope.strokeColor=UIColor.whiteColor().CGColor
            rope.strokeEnd=1.0
            self.view.layer.addSublayer(rope)
        }
        let point = self.view.convertPoint(kongCenter.center, fromView: box)
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(attachment.anchorPoint)
        bezierPath.addLineToPoint(point)
        rope.path=bezierPath.CGPath
        
    }
    
    deinit {
        box.removeObserver(self, forKeyPath: "center")
    }
    func addPan(pan:UIGestureRecognizer) {
        let point = pan.locationInView(self.view)
        attachment.anchorPoint=point
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

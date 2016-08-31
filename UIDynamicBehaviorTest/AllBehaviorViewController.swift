//
//  AllBehaviorViewController.swift
//  UIDynamicBehaviorTest
//
//  Created by Сергей Пугач on 31.08.16.
//  Copyright © 2016 Сергей Пугач. All rights reserved.
//

import UIKit

var COUNT=5

class AllBehaviorViewController: UIViewController {
    private var myContext = 0
    
    
    let BOXSIZE:CGFloat=30
    var currentLine:CGFloat = 100
    let betwenLines:CGFloat = 40
    
    var animator:UIDynamicAnimator!
    var attachment:UIAttachmentBehavior!
    
    var arrayBox=[UIView]()
    var ropeBox=[CAShapeLayer!]()
    var rope:CAShapeLayer!
    
    private let keyPath:String="center"
    
    @IBOutlet weak var barButtonItemAdd: UIBarButtonItem!
    @IBAction func barButtonActionAdd(sender: AnyObject) {
        removeObservers()
        
        let itemView = barButtonItemAdd.valueForKey("view") as! UIView
        let box = UIView(frame: CGRectMake(itemView.frame.origin.x, itemView.frame.origin.y, BOXSIZE, BOXSIZE))
        box.backgroundColor=UIColor.greenColor()
        box.layer.cornerRadius=15
        box.layer.masksToBounds=true
        
        self.view.addSubview(box)
        arrayBox.append(box)
        
        COUNT+=1
        
        addBehaviors(arrayBox)
        barButtonItemDel.enabled=true
    }
    
    @IBOutlet weak var barButtonItemDel: UIBarButtonItem!
    @IBAction func barButtonActionDel(sender: AnyObject) {
        if COUNT>1 {

            let tempBox = arrayBox.removeLast()
            let tempRope=ropeBox.removeLast()
            
            tempRope.path=nil
            tempBox.removeFromSuperview()
            tempBox.removeObserver(self, forKeyPath: keyPath, context: nil)
            
            COUNT-=1
            
        } else {
            barButtonItemDel.enabled=false
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor=UIColor.darkGrayColor()
        animator=UIDynamicAnimator(referenceView: view)
        
        var multiply=0
        for i in 0..<COUNT {
            var box = UIView()
            if (CGFloat(multiply*40)+BOXSIZE)<self.view.bounds.width {
                box = UIView(frame: CGRectMake(CGFloat(multiply)*40, currentLine, 30, 30))
            } else {
                multiply=0
                currentLine+=betwenLines
                box = UIView(frame: CGRectMake(CGFloat(multiply)*30, currentLine, 30, 30))
            }
            
            if i==0 {
                box.backgroundColor=UIColor.redColor()
            } else {
                box.backgroundColor=UIColor.greenColor()
            }
            box.layer.cornerRadius=15
            box.layer.masksToBounds=true
            self.view.addSubview(box)
            arrayBox.append(box)
            
            multiply+=1
        }
        
        addBehaviors(arrayBox)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(AttachmentViewController.addPan(_:)))
        self.view.addGestureRecognizer(pan)
    }
    
    func addBehaviors(arrayBox:[UIView]) {
        animator.removeAllBehaviors()
        
        //ADD Dynamic
        let itemsBehavior = UIDynamicItemBehavior(items: arrayBox)
        itemsBehavior.angularResistance=0.5
        itemsBehavior.density=10
        itemsBehavior.elasticity=0.6
        itemsBehavior.friction=0.3
        itemsBehavior.resistance=0.3
        animator.addBehavior(itemsBehavior)
        
        //ADD GRAVITY
//        let gravity = UIGravityBehavior(items: arrayBox)
//        animator.addBehavior(gravity)
        
        //ADD COLLISION
        let collision = UICollisionBehavior(items: arrayBox)
        collision.collisionMode = .Everything
        collision.translatesReferenceBoundsIntoBoundary=true
        animator.addBehavior(collision)
        
        //ADD ATTACHMENT to first view
        attachment=UIAttachmentBehavior(item: arrayBox.first!, attachedToAnchor: arrayBox.first!.center)
        attachment.anchorPoint=CGPointMake(view.bounds.size.width/2, view.bounds.size.height/4)
        attachment.length=0
        attachment.damping=1
        attachment.frequency=3
        animator.addBehavior(attachment)
        
        //ADD ATTACH
        for i in 1..<arrayBox.count {
            let view:UIView=arrayBox[i]
            let attach = UIAttachmentBehavior(item: view, attachedToItem: arrayBox[i-1])
            attach.length=25
            attach.damping=1
            attach.frequency=3
            animator.addBehavior(attach)
            //let options = NSKeyValueObservingOptions([.New, .Old, .Initial, .Prior])
            arrayBox[i].addObserver(self, forKeyPath:keyPath, options: .New, context:nil)
        }
        
    }
    
    func addPan(pan:UIGestureRecognizer) {
        
        if !animator.behaviors.contains(attachment) {
            animator.addBehavior(attachment)
        }
        
        let point = pan.locationInView(view)
        attachment.anchorPoint=point
        
        if pan.state==UIGestureRecognizerState.Ended {
            animator.removeBehavior(attachment)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath==self.keyPath {
            while ropeBox.count+1 != arrayBox.count  {
                let ropeBetwenViews = CAShapeLayer()
                ropeBetwenViews.fillColor=UIColor.clearColor().CGColor
                ropeBetwenViews.lineJoin=kCALineJoinRound
                ropeBetwenViews.lineWidth=2.0
                ropeBetwenViews.strokeColor=UIColor.whiteColor().CGColor
                ropeBetwenViews.strokeEnd=1.0
                self.view.layer.addSublayer(ropeBetwenViews)
                ropeBox.append(ropeBetwenViews)
            }
            for (i,rp) in ropeBox.enumerate() {
                let bezierPath = UIBezierPath()
                bezierPath.moveToPoint(arrayBox[i].center)
                bezierPath.addLineToPoint(arrayBox[i+1].center)
                rp.path=bezierPath.CGPath
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    func removeObservers() {
        for i in 1..<arrayBox.count {
            arrayBox[i].removeObserver(self, forKeyPath:keyPath, context:nil)
        }
    }
    deinit {
        removeObservers()
    }


}

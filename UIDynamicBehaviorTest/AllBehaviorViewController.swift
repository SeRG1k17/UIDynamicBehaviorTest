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
    
    //private let keyPath:String="center"
    
    @IBOutlet weak var barButtonItemAdd: UIBarButtonItem!
    @IBAction func barButtonActionAdd(sender: AnyObject) {
    
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
            let tempView = arrayBox.removeLast()
            tempView.removeFromSuperview()
            //tempView.removeObserver(self, forKeyPath: keyPath, context: nil)
            addBehaviors(arrayBox)
            COUNT-=1
        } else {
            barButtonItemDel.enabled=false
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(COUNT)
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
            
        }
        let options = NSKeyValueObservingOptions([.New,.Old])
        
        arrayBox[4].addObserver(self, forKeyPath:"4", options: options, context:nil)
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
        print("WAS in observer")
        
        //for i in 1..<arrayBox.count {
        if rope == nil {
            rope=CAShapeLayer()
            rope.fillColor=UIColor.clearColor().CGColor
            rope.lineJoin=kCALineJoinRound
            rope.lineWidth=2.0
            rope.strokeColor=UIColor.whiteColor().CGColor
            rope.strokeEnd=1.0
            self.view.layer.addSublayer(rope)
            //ropeBox.append(rope)
        }
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(arrayBox[3].center)
        bezierPath.addLineToPoint(arrayBox[4].center)
        rope.path=bezierPath.CGPath
        ropeBox.append(rope)
        //}
    }
    
    deinit {
        arrayBox[4].removeObserver(self, forKeyPath:"4", context:nil)
        
        for i in 0..<arrayBox.count {
            
        }
    }


}

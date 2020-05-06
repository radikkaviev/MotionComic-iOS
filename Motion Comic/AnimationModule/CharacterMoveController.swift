//
//  CharacterMoveController.swift
//  Motion Comic
//
//  Created by Apple on 28/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class CharacterMoveController: NSObject {
    private static var sharedInstance: CharacterMoveController?
    class var shared : CharacterMoveController {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = CharacterMoveController()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    private var _vc:PathVC!
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC,key:String){
        self._vc = vc;
        
        var imgData:Data!;
        var ancherX:Double = 0
        var ancherY:Double = 0
        var center:Bool?
        var posX:Int = 0
        var posY:Int = 0
        var scale:Int = 0
        var opacity:Int = 0
        var rotate:Int = 0
        var blur:Int = 0
        var time:Int = 0
        var again:Int = 0
        var wait:Bool = false
        var imageURL:String = ""
        var label:String = ""
        if let ancherXval = (dic["anchorX"]){
            ancherX = Double(ancherXval as! String)!
        }
        if let ancherYval = (dic["anchorY"]){
            ancherY = Double(ancherYval as! String)!
        }
        if let centerVal = (dic["center"]){
            center = Bool(centerVal as! String)
        }
        if let labelval = (dic["label"]){
            label = (labelval as! String)
        }
        if let posXVal = (dic["posX"]){
            posX = Int(posXVal as! String)!
        }
        if let posYVal = (dic["posY"]){
            posY = Int(posYVal as! String)!
        }
        if let scaleVal = (dic["scale"]){
            scale = Int(scaleVal as! String)!
        }
        if let opacityVal = (dic["opacity"]){
            opacity = Int(opacityVal as! String)!
        }
        if let rotateVal = (dic["rotate"]){
            rotate=Int(rotateVal as! String)!
        }
        if let blurValue = (dic["blur"]){
            blur = Int(blurValue as! String)!
        }
        if let timeVal = (dic["time"]){
            time = Int(timeVal as! String)!
        }
        if let waitVal = (dic["wait"]){
            wait = Bool(waitVal as! String)!
        }
        if let imageURLVal = (dic["image"]){
            imageURL = (imageURLVal as! String)
        }
        if let againVal = (dic["again"]){
            again = Int(againVal as! String)!
        }
        
        let dispatchQues = DispatchQueue(label: "move");
        dispatchQues.async {
            var duration:Double = 0;
            var waittime:Int = 0
            if(!wait){
                if(time==0){
                    duration = 0;
                }
                else{
                    duration = time.msToSeconds;
                }
            }
            else{
                
                waittime = time;
//                if(wait){
//                    vc.index = vc.index + 1
//                    vc.LoadAnimation()
//                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+waittime.msToSeconds, execute: { () -> Void in
                var imgView:UIImageView!
                
                    if(vc.displayedImages[label] != nil){
                        imgView = vc.displayedImages[label]!
                    }
                    else{
                        vc.index = vc.index + 1
                        vc.LoadAnimation();
                        return
                    }
                
//                if(imgView == nil){
//                    vc.index = vc.index + 1
//                    vc.LoadAnimation();
//                    return
//                }
                if(imgView != nil){
                    
                    UIView.animate(withDuration: duration, animations: { () -> Void in
                        
                        //imgView.layer.position = CGPoint.init(x: posX, y: posY)
                        imgView.alpha = CGFloat(opacity)/100
                        //imgView.layer.contentsGravity = .center
                        //imgView.layer.frame = vc.bgView.bounds
                        imgView.layer.frame = CGRect.init(x: posX, y:posY , width: Int(vc.bgView.frame.size.width), height: Int(vc.bgView.frame.size.height))
                        if(ancherX != 0 && ancherY != 0){
                            imgView.layer.anchorPoint = CGPoint.init(x: ancherX, y: ancherY)
                        }
                        if(rotate != 0){
                            let radians = CGFloat(Double(rotate) * Double.pi/180)
                            imgView.transform = CGAffineTransform(rotationAngle: radians)
                        }
                        if(scale > 0){
                            print("Chara_show-scale")
                            if(scale>110){
                                scale = 115
                                //imgView.contentMode = UIView.ContentMode.scaleToFill
                            }
                            
                            imgView.transform = CGAffineTransform(scaleX: CGFloat(scale)/100, y: CGFloat(scale)/100)
                            
                        }
                        //if(!wait){
                            vc.index = vc.index + 1
                            vc.LoadAnimation()
                        //}
                    })
                }})
        }
    }
    class func dispose()
    {
        CharacterMoveController.sharedInstance = nil
        print("Disposed Singleton instance")
    }
}

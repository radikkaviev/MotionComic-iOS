//
//  CharacterHideController.swift
//  Motion Comic
//
//  Created by Apple on 28/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class CharacterHideController: NSObject {
   private static var sharedInstance: CharacterHideController?
    class var shared : CharacterHideController {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = CharacterHideController()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    private var _vc:PathVC!
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC,key:String){
        self._vc = vc;
        var blur:Int = 0
        var time:Int = 0
        var wait:Bool?
        var name:String = ""
        var label:String = ""
        
        if let blurValue = (dic["blur"]){
            blur = Int(blurValue as! String)!
        }
        if let timeVal = (dic["time"]){
            time = Int(timeVal as! String)!
        }
        if let waitVal = (dic["wait"]){
            wait = Bool(waitVal as! String)
        }
        if let imageURLVal = (dic["image"]){
            name = (imageURLVal  as! String)
        }
        if let labelVal = (dic["label"]){
            label = (labelVal as! String)
        }
        
        
        var waittime:Int = 0
        var duration:Double = 0;
        if(!wait!){
            duration = time.msToSeconds;
        }
        else{
           waittime = time;
//            if(wait!){
//                vc.index = vc.index + 1
//                vc.LoadAnimation()
//            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+waittime.msToSeconds, execute: { () -> Void in
            
            let imgView =  vc.displayedImages[label]
            UIView.animate(withDuration: duration, animations: { () -> Void in
                if(imgView != nil){
                    imgView?.alpha = 0;
                    vc.displayedImages.removeValue(forKey: label)
                }
                //if(!wait!){
                    vc.index = vc.index + 1
                    vc.LoadAnimation()
                //}
            })
        })
    }
    
    class func dispose()
    {
        CharacterHideController.sharedInstance = nil
        print("Disposed Singleton instance")
    }
}


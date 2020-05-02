//
//  CharacterHideController.swift
//  Motion Comic
//
//  Created by Apple on 28/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class CharacterHideController: NSObject {
    static let shared = CharacterHideController()
    private var _vc:PathVC!
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC,key:String){
        self._vc = vc;
        var blur:Int = 0
        var time:Int = 0
        var wait:Bool?
        var name:String = ""
        
        
        if let blurValue = (dic["blur"]){
            blur = Int((blurValue as! [String:AnyObject])["value"] as! String)!
        }
        if let timeVal = (dic["time"]){
            time = Int((timeVal as! [String:AnyObject])["value"] as! String)!
        }
        if let waitVal = (dic["wait"]){
            wait = ((waitVal as! [String:AnyObject])["value"] as! Bool)
        }
        if let imageURLVal = (dic["image"]){
            name = ((imageURLVal as! [String:AnyObject])["value"] as! String)
        }
        
        if let parent = (dic["parent"]){
           var waittime:Int = 0
           var duration:Double = 0;
           if(!wait!){
               duration = time.msToSeconds;
           }
           else{
            if(time==0){
                waittime = 500
            }else{
               waittime = time;
            }
           }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + waittime.msToSeconds, execute: { () -> Void in
                print("previous parent")
                print(parent as! String)
                let imgView =  vc.displayedImages[parent as! String]
                UIView.animate(withDuration: duration, animations: { () -> Void in
                    if(imgView != nil){
                        imgView?.alpha = 0;
                        //vc.displayedImages.removeValue(forKey: parent as! String)
                    }
                    vc.index = vc.index + 1
                    vc.LoadAnimation()
                })
            })
           
        }
    }
}


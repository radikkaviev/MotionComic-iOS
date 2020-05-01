//
//  FadeController.swift
//  Motion Comic
//
//  Created by Apple on 27/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class FadeController: NSObject {
    static let shared = FadeController()
    private var _vc:PathVC!
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC,key:String){
        self._vc = vc;
        var start_alpha:Int = 0
        var end_alpha:Int = 0
        var start_rgb:String = "#ffffff"
        var end_rgb:String = "#ffffff"
        var time:Int = 0
        var wait:Bool = false
        
        
        if let start_alphaVal = (dic["start_alpha"]){
            start_alpha = Int((start_alphaVal as! [String:AnyObject])["value"] as! String)!
        }
        if let end_alphaVal = (dic["end_alpha"]){
            end_alpha = Int((end_alphaVal as! [String:AnyObject])["value"] as! String)!
        }
        if let start_rgbval = (dic["start_rgb"]){
            start_rgb = ((start_rgbval as! [String:AnyObject])["value"] as! String).replacingOccurrences(of: "0x", with: "#")
        }
        if let end_rgbval = (dic["end_rgb"]){
            end_rgb = ((end_rgbval as! [String:AnyObject])["value"] as! String).replacingOccurrences(of: "0x", with: "#")
        }
          
        if let timeVal = (dic["time"]){
            time = Int((timeVal as! [String:AnyObject])["value"] as! String)!
        }
        if let waitVal = (dic["wait"]){
            wait = ((waitVal as! [String:AnyObject])["value"] as! Bool)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time.msToSeconds, execute: { () -> Void in
                   UIView.animate(withDuration: 0, animations: { () -> Void in
                       vc.bgView.fadeIn(value: Double(CGFloat(end_alpha/100)))
                       vc.bgView.fadeOut(value: Double(CGFloat(start_alpha/100)))
                       vc.index = vc.index + 1
                       vc.LoadAnimation()
                   })
        })
       
    }
}

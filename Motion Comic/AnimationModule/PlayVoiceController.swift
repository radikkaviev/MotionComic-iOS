//
//  PlayVoiceController.swift
//  Motion Comic
//
//  Created by Apple on 27/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class PlayVoiceController: NSObject {
    static let shared = PlayVoiceController()
    private var _vc:PathVC!
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC){
        self._vc = vc;
        var audio:String = ""
        var name:String = ""
        var loop:Bool?
        var volume:Int = 0
        var later:Int = 0
        var children:[String:AnyObject]
        
        if let audioval = (dic["audio"]){
            audio = ((audioval as! [String:AnyObject])["value"] as! String)
        }
        if let nameval = (dic["name"]){
            name = ((nameval as! [String:AnyObject])["value"] as! String)
        }
       
        if let volumeVal = (dic["volume"]){
            volume = Int((volumeVal as! [String:AnyObject])["value"] as! String)!
        }
        if let laterVal = (dic["laterTime"]){
            later = Int((laterVal as! [String:AnyObject])["value"] as! String)!
        }
        if let childrenVal = (dic["children"]){
            children = ((childrenVal as! [String:AnyObject]))
        }
        
        if let loopVal = (dic["loop"]){
            loop = ((loopVal as! [String:AnyObject])["value"] as! Bool)
        }
        DispatchQueue.global(qos: .default).async {
            if let parent = (dic["parent"]){
            }
            DispatchQueue.main.async {
            }
            vc.index = vc.index + 1
            vc.LoadAnimation();
        }
    }
}

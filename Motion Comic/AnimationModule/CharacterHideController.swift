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
        
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                if let parent = (dic["parent"]){
                    let imgView =  vc.displayedImages[parent as! String]
                    imgView?.alpha = 1
                    UIView.animate(withDuration: TimeInterval(time/1000), animations: {
                        imgView?.alpha = 0 
                        
                    }) { (res) in
                        vc.index = vc.index + 1
                        vc.LoadAnimation();
                        if(imgView != nil){
                            imgView?.alpha = 0;
                            //vc.displayedImages.removeValue(forKey: parent as! String)
                        }
                    }
                }
            }
        }
    }
}


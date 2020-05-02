//
//  PlaySeController.swift
//  Motion Comic
//
//  Created by Apple on 27/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class PlaySeController: NSObject {
    static let shared = PlaySeController()
    private var _vc:PathVC!
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC,key:String){
        self._vc = vc;
        var audio:String = ""
        var name:String = ""
        var loop:Bool?
        var volume:Int = 0
        var later:Int = 0
        var parent:Int = 0
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
        if let parentVal = (dic["parent"] as? String){
            parent = Int(parentVal)!
        }
        if let loopVal = (dic["loop"]){
            loop = ((loopVal as! [String:AnyObject])["value"] as! Bool)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + later.msToSeconds, execute: { () -> Void in
            UIView.animate(withDuration: 0, animations: { () -> Void in
                if(parent==0){
                    let filename = URL.init(fileURLWithPath: ((dic["name"] as! [String:AnyObject])["value"] as! String)).lastPathComponent
                    if(filename.fileExtension() == AudioFileType.MP3.rawValue){
                        FileHelper.shared.PlayOtherFile(playFile: "sound/voice/\(filename)")
                    }
                    else{
                        FileHelper.shared.PlayOggFile(playFile: "sound/voice/\(filename)")
                    }
                }
           vc.index = vc.index + 1
           vc.LoadAnimation();
            })
        })
        
    }
}

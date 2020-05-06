//
//  PlaySeController.swift
//  Motion Comic
//
//  Created by Apple on 27/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class PlaySeController: NSObject {
    private static var sharedInstance: PlaySeController?
    class var shared : PlaySeController {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = PlaySeController()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
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
            audio = (audioval as! String)
            if(audio.components(separatedBy: "__pp").count>1){
                audio = audio.components(separatedBy: "__pp")[1]
            }
        }
        if let nameval = (dic["name"]){
            name = (nameval as! String)
        }
        
        if let volumeVal = (dic["volume"]){
            volume = Int(volumeVal as! String)!
        }
        if let laterVal = (dic["laterTime"]){
            later = Int(laterVal as! String)!
        }
        if let childrenVal = (dic["children"]){
            children = (childrenVal as! [String:AnyObject])
        }
        if let parentVal = (dic["parent"] as? String){
            parent = Int(parentVal)!
        }
        if let loopVal = (dic["loop"]){
            loop = Bool(loopVal as! String)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { () -> Void in
            UIView.animate(withDuration: later.msToSeconds, animations: { () -> Void in
                
                let filename = URL.init(fileURLWithPath: audio).lastPathComponent
                if(filename.fileExtension() == AudioFileType.MP3.rawValue){
                    FileHelper.shared.PlayOtherFile(playFile: audio.removingPercentEncoding!)
                }
                else{
                    FileHelper.shared.PlayOggFile(playFile: audio.removingPercentEncoding!)
                }
                
                vc.index = vc.index + 1
                vc.LoadAnimation();
            })
        })
        
    }
    class func dispose()
    {
        PlaySeController.sharedInstance = nil
        print("Disposed Singleton instance")
    }
}

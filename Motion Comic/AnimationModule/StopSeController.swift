//
//  StopSeController.swift
//  Motion Comic
//
//  Created by Apple on 27/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class StopSeController: NSObject {
    static let shared = StopSeController()
    private var _vc:PathVC!
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC,key:String){
        self._vc = vc;
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { () -> Void in
            UIView.animate(withDuration: 0, animations: { () -> Void in
                var soundURL:String = ""
                if let soundURLVal = (dic["name"]){
                    soundURL = ((soundURLVal as! [String:AnyObject])["value"] as! String)
                    let filename = URL.init(fileURLWithPath:soundURL).lastPathComponent
                    
                    if(filename.fileExtension() == AudioFileType.MP3.rawValue){
                        FileHelper.shared.StopOtherPlayer(key: filename)
                    }
                    else{
                        FileHelper.shared.StopOggPlayer(key: filename)
                    }
                }
                vc.index = vc.index + 1
                vc.LoadAnimation()
            })
        })

      
       
    }
}

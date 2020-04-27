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
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC){
        self._vc = vc;
        vc.index = vc.index + 1
        vc.LoadAnimation()
        var soundURL:String = ""
        if let soundURLVal = (dic["name"]){
            soundURL = ((soundURLVal as! [String:AnyObject])["value"] as! String)
            let filename = URL.init(fileURLWithPath:soundURL).lastPathComponent
            FileHelper.shared.StopOtherPlayer(key: filename)
        }
        
    }
}

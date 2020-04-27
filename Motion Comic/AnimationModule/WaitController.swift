//
//  WaitController.swift
//  Motion Comic
//
//  Created by Apple on 27/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class WaitController: NSObject {
    static let shared = WaitController()
    private var _vc:PathVC!
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC){
        self._vc = vc;
        vc.index = vc.index + 1
        let time = Int(((dic["time"] as! [String:AnyObject])["value"] as! String))!/1000000
        vc.CallWaitMethod(time: time)
    }
}

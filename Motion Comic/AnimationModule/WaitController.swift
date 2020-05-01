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
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC,key:String){
        self._vc = vc;
        let time = Int(((dic["time"] as! [String:AnyObject])["value"] as! String))!
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time.msToSeconds, execute: { () -> Void in
            UIView.animate(withDuration: 0, animations: { () -> Void in
              vc.index = vc.index + 1
              vc.LoadAnimation()
            })
        })
    }
}

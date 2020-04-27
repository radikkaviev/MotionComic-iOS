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
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC){
        self._vc = vc;
        let alfaStart = Int(((dic["start_alpha"] as! [String:AnyObject])["value"] as! String))
        let alfaEnd = Int(((dic["end_alpha"] as! [String:AnyObject])["value"] as! String))//((dic!["end_alpha"] as! [String:AnyObject])["value"]) as! Int)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 2.0) {
                vc.view.fadeIn(value: Double(CGFloat(alfaStart!/100)))
                vc.view.fadeOut(value: Double(CGFloat(alfaEnd!/100)))
                vc.index = vc.index + 1
                vc.LoadAnimation()
            }
        }
    }
}

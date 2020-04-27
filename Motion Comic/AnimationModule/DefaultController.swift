//
//  DefaultController.swift
//  Motion Comic
//
//  Created by Apple on 27/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class DefaultController: NSObject {
    static let shared = DefaultController()
    private var _vc:PathVC!
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC){
        self._vc = vc;
        let color = "#\((dic["color"] as! [String:AnyObject])["value"] as! String)"
        DispatchQueue.main.async {
            vc.view.backgroundColor = UIColor.init(hexString: color)
            vc.view.alpha=0;
            vc.index = vc.index + 1
            vc.LoadAnimation()
        }
    }
}

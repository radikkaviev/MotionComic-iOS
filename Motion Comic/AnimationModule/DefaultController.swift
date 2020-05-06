//
//  DefaultController.swift
//  Motion Comic
//
//  Created by Apple on 27/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class DefaultController: NSObject {
    private static var sharedInstance: DefaultController?
    class var shared : DefaultController {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = DefaultController()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    private var _vc:PathVC!
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC,key:String){
        self._vc = vc;
        let color = (dic["color"] as! String).replacingOccurrences(of: "0x", with: "#")
        DispatchQueue.main.async {
            vc.bgView.backgroundColor = UIColor.init(hexString: color)
            vc.index = vc.index + 1
            vc.LoadAnimation()
        }
    }
    
    class func dispose()
    {
        DefaultController.sharedInstance = nil
        print("Disposed Singleton instance")
    }
}

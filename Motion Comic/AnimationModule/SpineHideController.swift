//
//  SpineHideController.swift
//  Motion Comic
//
//  Created by Apple on 30/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class SpineHideController: NSObject {
    private static var sharedInstance: SpineHideController?
    class var shared : SpineHideController {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = SpineHideController()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    private var _vc:PathVC!
    class func dispose()
    {
        SpineHideController.sharedInstance = nil
        print("Disposed Singleton instance")
    }
}

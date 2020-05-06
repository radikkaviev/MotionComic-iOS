//
//  SpineController.swift
//  Motion Comic
//
//  Created by Apple on 30/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class SpineController: NSObject {
    private static var sharedInstance: SpineController?
    class var shared : SpineController {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = SpineController()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    private var _vc:PathVC!
    class func dispose()
    {
        SpineController.sharedInstance = nil
        print("Disposed Singleton instance")
    }
}

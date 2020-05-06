//
//  QuakeController.swift
//  Motion Comic
//
//  Created by Apple on 30/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class QuakeController: NSObject {
    private static var sharedInstance: QuakeController?
    class var shared : QuakeController {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = QuakeController()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    private var _vc:PathVC!
    class func dispose()
    {
        QuakeController.sharedInstance = nil
        print("Disposed Singleton instance")
    }
}

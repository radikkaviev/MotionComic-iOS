//
//  SpineMoveController.swift
//  Motion Comic
//
//  Created by Apple on 30/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class SpineMoveController: NSObject {
    private static var sharedInstance: SpineMoveController?
    class var shared : SpineMoveController {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = SpineMoveController()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    private var _vc:PathVC!
    class func dispose()
    {
        SpineMoveController.sharedInstance = nil
        print("Disposed Singleton instance")
    }
}

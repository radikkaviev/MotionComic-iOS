//
//  EndController.swift
//  Motion Comic
//
//  Created by Apple on 30/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class EndController: NSObject {
    private static var sharedInstance: EndController?
    class var shared : EndController {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = EndController()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    private var _vc:PathVC!
    class func dispose()
    {
        EndController.sharedInstance = nil
        print("Disposed Singleton instance")
    }
}

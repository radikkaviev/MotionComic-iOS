//
//  PlaySeController.swift
//  Motion Comic
//
//  Created by Apple on 27/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class PlaySeController: NSObject {
    static let shared = PlaySeController()
    private var _vc:PathVC!
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC){
        self._vc = vc;
        DispatchQueue.global(qos: .default).async {
            let parent = dic["parent"] as! String
            DispatchQueue.main.async {
                if(parent != nil){
                    
                }
                
            }
            vc.index = vc.index + 1
            vc.LoadAnimation();
        }
    }
}

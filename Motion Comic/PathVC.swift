//
//  PathVC.swift
//  Motion Comic
//
//  Created by Jigar on 13/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class PathVC: UIViewController {
    
    @IBOutlet var txtPath: UITextView!
    @IBOutlet var imgView:UIImageView!
    @IBOutlet var bgView:UIView!
    var selectedPath: String = ""
    public var displayedImages:[String:UIImageView] = [String:UIImageView]()
    var index = 0
    var timer:Timer!
    var time:Int = 0
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Motion Comic"
        Helper.hideParentKeys.removeAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LoadAnimation();
    }
    
    @objc func LoadAnimation(){
        
        if index < 49 {
            if(Helper.senarioAllKeys.count==0){
                Helper.ShowAlert(title: "", message: "No Source Found.", btntitle: "OK", vc: self)
                return
            }
            var parent:Int = 0
            
            let key = Helper.senarioAllKeys[index] as String;
            let dic = ((Helper.senarioDic!["data"] as! [String:AnyObject])[key]) as! [String:AnyObject]?
            if let parentVal = (dic!["parent"] as? String){
                parent = Int(parentVal)!
            }
            
            let tagname =  (dic!["tagName"] as! String)
            switch tagname {
            case TagName.DefaultColor.rawValue:
                DefaultController.shared.SetAnimation(dic: dic!, vc: self,key: key)
                break;
            case TagName.Sfade.rawValue:
                FadeController.shared.SetAnimation(dic: dic!, vc: self,key: key)
                break;
            case TagName.Charashow.rawValue:
                CharacterController.shared.SetAnimation(dic: dic!, vc: self, key: key)
                break;
            case TagName.Wait.rawValue:
                WaitController.shared.SetAnimation(dic: dic!, vc: self, key: key)
                break;
//            case TagName.Playse.rawValue:
//                PlaySeController.shared.SetAnimation(dic: dic!, vc: self,key: key)
//                break;
            case TagName.Stopse.rawValue:
                StopSeController.shared.SetAnimation(dic: dic!, vc: self,key: key)
                break;
//            case TagName.Playvoice.rawValue:
//                PlayVoiceController.shared.SetAnimation(dic: dic!, vc: self,key: key)
//                break;
//            case TagName.CharaMove.rawValue:
//                CharacterMoveController.shared.SetAnimation(dic: dic!, vc: self, key: key)
//                break;
//            case TagName.CharaHide.rawValue:
//                CharacterHideController.shared.SetAnimation(dic: dic!, vc: self, key: key)
//                break;
                
            default:
                //index = index + 1
                //LoadAnimation()
                break;
            }
            print((dic!["tagName"] as! String))
            print(key)
        }
    }
}

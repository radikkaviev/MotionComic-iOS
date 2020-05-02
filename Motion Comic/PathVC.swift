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
        Helper.moveChilds.removeAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //SelectViewController.shared.SetEndView(vc: self, key: "key")
        //self.view.addSubview(SelectViewController.shared)
        LoadAnimation();
    }
    
    @objc func LoadAnimation(){
        print("Index-\(index)")
        if index < Helper.senarioAllKeys.count {
            if(Helper.senarioAllKeys.count==0){
                Helper.ShowAlert(title: "", message: "No Source Found.", btntitle: "OK", vc: self)
                return
            }
            var parent:Int = 0
            var time:Int = 0
            let key = Helper.senarioAllKeys[index] as String;
            let dic = ((Helper.senarioDic!["data"] as! [String:AnyObject])[key]) as! [String:AnyObject]?
            if let parentVal = (dic!["parent"] as? String){
                parent = Int(parentVal)!
            }
            if let timeVal = (dic!["time"]){
                time = Int((timeVal as! [String:AnyObject])["value"] as! String)!
            }
            
            let tagname =  (dic!["tagName"] as! String)
            if(tagname == "end"){
                print(tagname)
            }
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
            case TagName.Playse.rawValue:
                PlaySeController.shared.SetAnimation(dic: dic!, vc: self,key: key)
                break;
            case TagName.Stopse.rawValue:
                StopSeController.shared.SetAnimation(dic: dic!, vc: self,key: key)
                break;
            case TagName.Playvoice.rawValue:
                PlayVoiceController.shared.SetAnimation(dic: dic!, vc: self,key: key)
                break;
                //            case TagName.CharaMove.rawValue:
                //                CharacterMoveController.shared.SetAnimation(dic: dic!, vc: self, key: key)
            //                break;
            case TagName.CharaHide.rawValue:
                CharacterHideController.shared.SetAnimation(dic: dic!, vc: self, key: key)
                break;
            case TagName.Playbgm.rawValue:
                PlayBgmController.shared.SetAnimation(dic: dic!, vc: self, key: key)
                break;
            case TagName.Stopbgm.rawValue:
                StopBGMController.shared.SetAnimation(dic: dic!, vc: self, key: key)
                break;
            case TagName.Spine.rawValue:
                Timer.scheduledTimer(timeInterval: time.msToSeconds, target: self, selector: #selector(PathVC.Recall), userInfo: nil, repeats: false)
                break;
            case TagName.SpineHide.rawValue:
                Timer.scheduledTimer(timeInterval: time.msToSeconds, target: self, selector: #selector(PathVC.Recall), userInfo: nil, repeats: false)
                break;
            case TagName.SpineMove.rawValue:
                Timer.scheduledTimer(timeInterval: time.msToSeconds, target: self, selector: #selector(PathVC.Recall), userInfo: nil, repeats: false)
                break;
            case TagName.Quake.rawValue:
                Timer.scheduledTimer(timeInterval: time.msToSeconds, target: self, selector: #selector(PathVC.Recall), userInfo: nil, repeats: false)
                break;
            case TagName.Select.rawValue:
                Timer.scheduledTimer(timeInterval: time.msToSeconds, target: self, selector: #selector(PathVC.Recall), userInfo: nil, repeats: false)
                break;
            case TagName.End.rawValue:
                SelectViewController.shared.SetEndView(vc: self, key: key)
                self.view.addSubview(SelectViewController.shared)
                FileHelper.shared.StopAllOggPlayer()
                
                break;
            default:
                
                break;
            }
            //Timer.scheduledTimer(timeInterval: time.msToSeconds, target: self, selector: #selector(PathVC.Recall), userInfo: nil, repeats: false)
            print((dic!["tagName"] as! String))
            print(key)
        }
    }
    
    func RestartAnimation(){
        Helper.hideParentKeys.removeAll()
        Helper.moveChilds.removeAll()
        FileHelper.playersOtherInPlayModes.removeAll()
        FileHelper.playersOggInPlayModes.removeAll()
        for (key,value) in displayedImages {
            value.removeFromSuperview()
            displayedImages.removeValue(forKey: key);
        }
        index = 0;
        LoadAnimation()
        
    }
    
    @objc func Recall(){
        print("Recall")
        index = index + 1
        LoadAnimation()
    }
}

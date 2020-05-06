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
    var isback:Bool = false;
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Motion Comic"
        Helper.hideParentKeys.removeAll()
        Helper.moveChilds.removeAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LoadAnimation();
    }
    
    @objc func LoadAnimation(){
        print("Index-\(index)")
        if(isback){
            DisponseObjects()
            return;
        }
        
        if index < Helper.animationList.count {
            if(Helper.animationList.count==0){
                Helper.ShowAlert(title: "", message: "No Source Found.", btntitle: "OK", vc: self)
                return
            }
            let dic = Helper.animationList[index]
            let tagname =  (dic["tagName"] as! String)
            print(tagname)
            switch tagname {
            case TagName.DefaultColor.rawValue:
                DefaultController.shared.SetAnimation(dic: dic, vc: self,key: "")
                break;
            case TagName.Sfade.rawValue:
                FadeController.shared.SetAnimation(dic: dic, vc: self,key: "")
                break;
            case TagName.Charashow.rawValue:
                CharacterController.shared.SetAnimation(dic: dic, vc: self, key: "")
                break;
            case TagName.Wait.rawValue:
                WaitController.shared.SetAnimation(dic: dic, vc: self, key: "")
                break;
            case TagName.Playse.rawValue:
                PlaySeController.shared.SetAnimation(dic: dic, vc: self,key: "")
                break;
            case TagName.Stopse.rawValue:
                StopSeController.shared.SetAnimation(dic: dic, vc: self,key: "")
                break;
            case TagName.Playvoice.rawValue:
                PlayVoiceController.shared.SetAnimation(dic: dic, vc: self,key: "")
                break;
            case TagName.CharaMove.rawValue:
                CharacterMoveController.shared.SetAnimation(dic: dic, vc: self, key: "")
                break;
            case TagName.CharaHide.rawValue:
                CharacterHideController.shared.SetAnimation(dic: dic, vc: self, key: "")
                break;
            case TagName.Playbgm.rawValue:
                PlayBgmController.shared.SetAnimation(dic: dic, vc: self, key: "")
                break;
            case TagName.Stopbgm.rawValue:
                StopBGMController.shared.SetAnimation(dic: dic, vc: self, key: "")
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
                SelectViewController.shared.SetEndView(vc: self, key: "")
                self.view.addSubview(SelectViewController.shared)
                FileHelper.shared.StopAllOggPlayer()
                break;
            default:
                
                break;
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isback = true;
        DisponseObjects()
    }
    
    func RestartAnimation(){
        DisponseObjects()
        LoadAnimation()
    }
    
    func DisponseObjects(){
        Helper.hideParentKeys.removeAll()
        Helper.moveChilds.removeAll()
        FileHelper.playersOtherInPlayModes.removeAll()
        FileHelper.playersOggInPlayModes.removeAll()
        for (key,value) in displayedImages {
            value.removeFromSuperview()
            displayedImages.removeValue(forKey: key);
        }
        DefaultController.dispose()
        FadeController.dispose()
        CharacterController.dispose()
        CharacterHideController.dispose()
        CharacterMoveController.dispose()
        WaitController.dispose()
        PlaySeController.dispose()
        StopSeController.dispose()
        PlayBgmController.dispose()
        PlayVoiceController.dispose()
        StopBGMController.dispose()
        SpineController.dispose()
        SpineHideController.dispose()
        SpineMoveController.dispose()
        QuakeController.dispose()
        SelectViewController.dispose()
        EndController.dispose()
        index = 0;
    }
    
    @objc func Recall(){
        print("Recall")
        index = index + 1
        LoadAnimation()
    }
}

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
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Motion Comic"
        //FileHelper.PlayOggFile(playFile: "STK/resource/sound/voice/MC01_BOY_01.ogg")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LoadAnimation();
        //FileHelper.shared.PlayOggFile(playFile: "STK/resource/sound/voice/MC01_BOY_02.ogg")
        //FileHelper.shared.PlayOtherFile(playFile: "STK/resource/sound/bgm/bgm_004.mp3")
    }
    
    @objc func LoadAnimation(){
        
        if index < 5 {
            if(Helper.senarioAllKeys.count==0){
                Helper.ShowAlert(title: "", message: "No Source Found.", btntitle: "OK", vc: self)
                return
            }
            
            let key = Helper.senarioAllKeys[index] as String;
            let dic = ((Helper.senarioDic!["data"] as! [String:AnyObject])[key]) as! [String:AnyObject]?
            if((dic!["tagName"] as! String) == "defaultColor"){
                DefaultController.shared.SetAnimation(dic: dic!, vc: self)
            }
            else if((dic!["tagName"] as! String) == "sfade"){
                FadeController.shared.SetAnimation(dic: dic!, vc: self)
            }
            else if ((dic!["tagName"] as! String) == "chara_show"){
                CharacterController.shared.SetAnimation(dic: dic!, vc: self, key: key)
            }
            else if ((dic!["tagName"] as! String) == "wait"){
                WaitController.shared.SetAnimation(dic: dic!, vc: self)
            }
            else if ((dic!["tagName"] as! String) == "playse"){
                PlaySeController.shared.SetAnimation(dic: dic!, vc: self)
            }
            print((dic!["tagName"] as! String))
            
        }
    }
    
    public func CallWaitMethod(time:Int){
         Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self, selector: #selector(PathVC.LoadAnimation), userInfo: nil, repeats: false)
    }
}

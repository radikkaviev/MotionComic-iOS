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
    var selectedPath: String = ""
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
    
    override func viewDidDisappear(_ animated: Bool) {
        FileHelper.shared.StopPlayer();
        FileHelper.shared.StopOggPlayer();
    }
    
    func LoadAnimation(){
        
        if index < 3 {
            let key = Helper.senarioAllKeys[index] as String;
            let dic = ((Helper.senarioDic!["data"] as! [String:AnyObject])[key]) as! [String:AnyObject]?
            if((dic!["tagName"] as! String) == "defaultColor"){
                let color = "#\((dic!["color"] as! [String:AnyObject])["defaultColor"])"
                DispatchQueue.main.async {
                    self.view.backgroundColor = UIColor.init(hexString: color)
                    self.view.alpha=0;
                }
                index = index + 1
                LoadAnimation()
            }
            else if((dic!["tagName"] as! String) == "sfade"){
                let alfaStart = Int(((dic!["start_alpha"] as! [String:AnyObject])["value"] as! String))
                let alfaEnd = Int(((dic!["end_alpha"] as! [String:AnyObject])["value"] as! String))//((dic!["end_alpha"] as! [String:AnyObject])["value"]) as! Int)
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 3.0) {
                    self.view.fadeIn(value: Double(CGFloat(alfaStart!/100)))
                    self.view.fadeOut(value: Double(CGFloat(alfaEnd!/100)))
                    }
                }
                
                do {
                    sleep(2)
                }
                index = index + 1
                LoadAnimation()
            }
            else if ((dic!["tagName"] as! String) == "chara_show"){
                var imgData:Data!;
                DispatchQueue.global(qos: .default).async {
                    let imageURL = ((dic!["image"] as! [String:AnyObject])["value"] as! String)
                    let image = URL.init(fileURLWithPath: imageURL).lastPathComponent.removingPercentEncoding
                    imgData = FileHelper.shared.GetCharacterImageFormZipFolder(fileName:image!) as Data
                    DispatchQueue.main.async {
                        if(imgData != nil){
                            for (key , _) in (dic!["children"] as! [String:AnyObject]) {
                                let tempDic = ((Helper.senarioDic!["data"] as! [String:AnyObject])[key]) as! [String:AnyObject]?
                                if(tempDic != nil){
                                    if((tempDic!["tagName"] as! String) == "playse"){
                                        
                                        let filename = URL.init(fileURLWithPath: ((tempDic!["name"] as! [String:AnyObject])["value"] as! String)).lastPathComponent
                                        FileHelper.shared.PlayOtherFile(playFile: "sound/se/\(filename)")
                                        
                                    }
                                    else if((tempDic!["tagName"] as! String) == "playvoice"){
                                        let filename = URL.init(fileURLWithPath: ((tempDic!["name"] as! [String:AnyObject])["value"] as! String)).lastPathComponent
                                        FileHelper.shared.PlayOggFile(playFile: "sound/voice/\(filename)")
                                    }
                                }
                            }
                            
                            self.imgView.alpha = 0;
                            self.imgView.layer.anchorPoint = CGPoint.init(x: 0.2, y: 0.5)
                            self.imgView.image = UIImage.init(data: imgData as Data)
                            UIView.animate(withDuration: 3.0) {
                                self.imgView.alpha = 1.0
                                self.imgView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
                                
                            }
                        }
                    }
                }
                index = index + 1
                LoadAnimation();
            }
            print((dic!["tagName"] as! String))
            
        }
    }
    
    
}

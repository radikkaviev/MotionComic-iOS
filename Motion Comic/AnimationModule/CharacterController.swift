//
//  CharacterController.swift
//  Motion Comic
//
//  Created by Apple on 27/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class CharacterController: NSObject {
    static let shared = CharacterController()
    private var _vc:PathVC!
    public func SetAnimation(dic:[String:AnyObject],vc:PathVC,key:String){
        self._vc = vc;
        var imgData:Data!;
        var ancherX:Double = 0
        var ancherY:Double = 0
        var center:Bool?
        var posX:Int = 0
        var posY:Int = 0
        var scale:Int = 0
        var opacity:Int = 0
        var rotate:Int = 0
        var blur:Int = 0
        var time:Int = 0
        var wait:Bool?
        var imageURL:String = ""
        
        if let ancherXval = Double(((dic["anchorX"] as! [String:AnyObject])["value"] as! String)){
            ancherX = ancherXval
        }
        if let ancherYval = Double(((dic["anchorY"] as! [String:AnyObject])["value"] as! String)){
             ancherY = ancherYval
        }
        center = ((dic["center"] as! [String:AnyObject])["value"] as! Bool)
            
        if let posXVal = Int(((dic["posX"] as! [String:AnyObject])["value"] as! String)){
            posX = posXVal
        }
        if let posYVal = Int(((dic["posY"] as! [String:AnyObject])["value"] as! String)){
            posY = posYVal
        }
        if let scaleVal = Int(((dic["scale"] as! [String:AnyObject])["value"] as! String)){
            scale = scaleVal
        }
        if let opacityVal = Int(((dic["opacity"] as! [String:AnyObject])["value"] as! String)){
            opacity = opacityVal
        }
        if let rotateVal = Int(((dic["rotate"] as! [String:AnyObject])["value"] as! String)){
            rotate=rotateVal
        }
        if let blurValue = Int(((dic["blur"] as! [String:AnyObject])["value"] as! String)){
            blur = blurValue
        }
        if let timeVal = Int(((dic["time"] as! [String:AnyObject])["value"] as! String)){
            time = timeVal
        }
        wait = ((dic["wait"] as! [String:AnyObject])["value"] as! Bool)
        imageURL = ((dic["image"] as! [String:AnyObject])["value"] as! String)
            
        
        DispatchQueue.global(qos: .default).async {
            let image = URL.init(fileURLWithPath: imageURL).lastPathComponent.removingPercentEncoding
            imgData = FileHelper.shared.GetCharacterImageFormZipFolder(fileName:image!) as Data
            
            DispatchQueue.main.async {
                if(imgData != nil){
                    let imgView = UIImageView.init()
                    imgView.contentMode = UIImageView.ContentMode.scaleAspectFill
                    imgView.alpha = 0;
                    imgView.image = UIImage.init(data: imgData as Data)
                    if(scale > 0){
                        let width = (Int(vc.view.frame.width) * scale)/100
                        let height = (Int(vc.view.frame.height) * scale)/100
                        imgView.frame = CGRect.init(x: 0, y:0 , width: width, height: height)
                        
                    }
                    else{
                        imgView.frame = CGRect.init(x: 0, y:0 , width: Int(vc.bgView.frame.size.width), height: Int(vc.bgView.frame.size.height))
                    }
                    vc.bgView.addSubview(imgView)
                    vc.displayedImages[key] = imgView
                    if(ancherX != 0){
                        imgView.layer.anchorPoint = CGPoint.init(x: 0.460, y: ancherY)
                    }
                    if(ancherY != 0){
                        imgView.layer.anchorPoint = CGPoint.init(x: 0.460, y: ancherY)
                    }
                    
                    
                    
                    UIView.animate(withDuration: 3.0, animations: {
                        imgView.alpha = 1.0
                        imgView.layer.anchorPoint = CGPoint.init(x: ancherX, y: ancherY)
                    }) { (res) in
                        
                        imgView.alpha = 1.0
                        imgView.layer.anchorPoint = CGPoint.init(x: ancherX, y: ancherY)
                        
                        
                        for (key , _) in (dic["children"] as! [String:AnyObject]) {
                            let tempDic = ((Helper.senarioDic!["data"] as! [String:AnyObject])[key]) as! [String:AnyObject]?
                            let timeDic =  (tempDic!["laterTime"] as! [String:AnyObject])
                            if(tempDic != nil){
                                if((tempDic!["tagName"] as! String) == "playse"){
                                    
                                    let filename = URL.init(fileURLWithPath: ((tempDic!["name"] as! [String:AnyObject])["value"] as! String)).lastPathComponent
                                    if((Int(timeDic["value"] as! String))==0){
                                        FileHelper.shared.PlayOtherFile(playFile: "sound/se/\(filename)")
                                    }
                                    else{
                                        let timeinterval = ((Int(timeDic["value"] as! String)!))/1000000
                                        Timer.scheduledTimer(timeInterval: TimeInterval(timeinterval), target: self, selector: #selector(CharacterController.PlayOtherfile(timer:)), userInfo: filename, repeats: false)
                                    }
                                    
                                }
                                else if((tempDic!["tagName"] as! String) == "playvoice"){
                                    let filename = URL.init(fileURLWithPath: ((tempDic!["name"] as! [String:AnyObject])["value"] as! String)).lastPathComponent
                                    if((Int(timeDic["value"] as! String))==0){
                                        FileHelper.shared.PlayOggFile(playFile: "sound/voice/\(filename)")
                                    }
                                    else{
                                        let timeinterval = ((Int(timeDic["value"] as! String)!))/1000000
                                        Timer.scheduledTimer(timeInterval: TimeInterval(timeinterval), target: self, selector: #selector(CharacterController.PlayOggfile(timer:)), userInfo: filename, repeats: false)
                                    }
                                }
                            }
                        }
                        vc.index = vc.index + 1
                        vc.LoadAnimation();
                    }
                }
            }
        }
    }
    
    @objc func PlayOtherfile(timer: Timer){
        FileHelper.shared.PlayOtherFile(playFile: "sound/se/\(timer.userInfo as! String)")
    }
    
    @objc func PlayOggfile(timer: Timer){
        FileHelper.shared.PlayOggFile(playFile: "sound/voice/\(timer.userInfo as! String)")
    }
}

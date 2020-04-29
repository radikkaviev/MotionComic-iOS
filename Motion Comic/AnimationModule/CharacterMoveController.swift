//
//  CharacterMoveController.swift
//  Motion Comic
//
//  Created by Apple on 28/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class CharacterMoveController: NSObject {
    static let shared = CharacterMoveController()
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
        var again:Int = 0
        var wait:Bool?
        var imageURL:String = ""
        
        if let ancherXval = (dic["anchorX"]){
            ancherX = Double((ancherXval as! [String:AnyObject])["value"] as! String)!
        }
        if let ancherYval = (dic["anchorY"]){
            ancherY = Double((ancherYval as! [String:AnyObject])["value"] as! String)!
        }
        if let centerVal = (dic["center"]){
            center = ((centerVal as! [String:AnyObject])["value"] as! Bool)
        }
        
        if let posXVal = (dic["posX"]){
            posX = Int((posXVal as! [String:AnyObject])["value"] as! String)!
        }
        if let posYVal = (dic["posY"]){
            posY = Int((posYVal as! [String:AnyObject])["value"] as! String)!
        }
        if let scaleVal = (dic["scale"]){
            scale = Int((scaleVal as! [String:AnyObject])["value"] as! String)!
        }
        if let opacityVal = (dic["opacity"]){
            opacity = Int((opacityVal as! [String:AnyObject])["value"] as! String)!
        }
        if let rotateVal = (dic["rotate"]){
            rotate=Int((rotateVal as! [String:AnyObject])["value"] as! String)!
        }
        if let blurValue = (dic["blur"]){
            blur = Int((blurValue as! [String:AnyObject])["value"] as! String)!
        }
        if let timeVal = (dic["time"]){
            time = Int((timeVal as! [String:AnyObject])["value"] as! String)!
        }
        if let waitVal = (dic["wait"]){
            wait = ((waitVal as! [String:AnyObject])["value"] as! Bool)
        }
        if let imageURLVal = (dic["image"]){
            imageURL = ((imageURLVal as! [String:AnyObject])["value"] as! String)
        }
        if let againVal = (dic["again"]){
            again = Int((againVal as! [String:AnyObject])["value"] as! String)!
        }
        
        
        DispatchQueue.global(qos: .default).async {
            //            let image = URL.init(fileURLWithPath: imageURL).lastPathComponent.removingPercentEncoding
            //            imgData = FileHelper.shared.GetCharacterImageFormZipFolder(fileName:image!) as Data
            
            var imgView:UIImageView!
            if let parent = (dic["parent"]){
                if(vc.displayedImages[parent as! String] == nil)
                {
                    vc.index = vc.index + 1
                    vc.LoadAnimation();
                    return;
                }
                imgView = vc.displayedImages[parent as! String]!
            }
            if(imgView == nil){
                vc.index = vc.index + 1
                vc.LoadAnimation();
                return
            }
            DispatchQueue.main.async {
                if(imgView != nil){
                    let positions = Helper.CalculatePos(posX: posX, posY: posY, view: vc.bgView)
                    
                    var duration:TimeInterval = 0;
                    duration = TimeInterval(time.msToSeconds)
                    
                    if(duration == 0){
                        duration = 3;
                    }
                    
                    UIView.animate(withDuration: duration, animations: {
                        let yPos = (positions.1-(Int(vc.bgView.frame.size.height)/2))
                        //Helper.random(min: <#T##CGFloat#>, max: <#T##CGFloat#>)
                        //let yPos = Helper.random(min: imgView.frame.size.height/2, max: vc.bgView.frame.size.height - imgView.frame.size.height/2)
                        
                        if(yPos>0){
                        imgView.frame = CGRect.init(x: (positions.0-(Int(vc.bgView.frame.size.width)/2)), y:Int(yPos) , width: Int(vc.bgView.frame.size.width), height: Int(vc.bgView.frame.size.height))
                        imgView.alpha = CGFloat(opacity/100)
                        //imgView.layer.anchorPoint = CGPoint.init(x: ancherX, y: ancherY)
                        if(again>0){
                            imgView.alpha = 1;
                        }
                        }else{
                            imgView.alpha = 0
                        }
                        
                    }) { (res) in
                        vc.index = vc.index + 1
                        vc.LoadAnimation();
                    }
                    for (key , _) in (dic["children"] as! [String:AnyObject]) {
                        let tempDic = ((Helper.senarioDic!["data"] as! [String:AnyObject])[key]) as! [String:AnyObject]?
                        if(tempDic != nil){
                            let timeDic =  (tempDic!["laterTime"] as! [String:AnyObject])
                            if(timeDic != nil){
                                if((tempDic!["tagName"] as! String) == "playse"){
                                    
                                    let filename = URL.init(fileURLWithPath: ((tempDic!["name"] as! [String:AnyObject])["value"] as! String)).lastPathComponent
                                    if((Int(timeDic["value"] as! String))==0){
                                        FileHelper.shared.PlayOtherFile(playFile: "sound/se/\(filename)")
                                    }
                                    else{
                                        let timeinterval = ((Int(timeDic["value"] as! String)!))/1000000
                                        Timer.scheduledTimer(timeInterval: TimeInterval(timeinterval), target: self, selector: #selector(CharacterMoveController.PlayOtherfile(timer:)), userInfo: filename, repeats: false)
                                    }
                                    
                                }
                                else if((tempDic!["tagName"] as! String) == "playvoice"){
                                    let filename = URL.init(fileURLWithPath: ((tempDic!["name"] as! [String:AnyObject])["value"] as! String)).lastPathComponent
                                    if((Int(timeDic["value"] as! String))==0){
                                        FileHelper.shared.PlayOggFile(playFile: "sound/voice/\(filename)")
                                    }
                                    else{
                                        let timeinterval = ((Int(timeDic["value"] as! String)!))/1000000
                                        Timer.scheduledTimer(timeInterval: TimeInterval(timeinterval), target: self, selector: #selector(CharacterMoveController.PlayOggfile(timer:)), userInfo: filename, repeats: false)
                                    }
                                }
                            }
                        }
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

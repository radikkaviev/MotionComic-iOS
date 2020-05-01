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
        
        let dispatchQues = DispatchQueue(label: "move");
        dispatchQues.async {
            var imgView:UIImageView!
            if let parent = (dic["parent"]){
                imgView = vc.displayedImages[parent as! String]!
            }
            if(imgView == nil){
                vc.index = vc.index + 1
                vc.LoadAnimation();
                return
            }
            var WatVal:Double = time.msToSeconds;
            if(!wait!){
                WatVal = 0;
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + WatVal, execute: { () -> Void in
                if(imgView != nil){
                    
                    UIView.animate(withDuration: time.msToSeconds, animations: { () -> Void in
                        imgView.layer.contentsScale = CGFloat(scale)
                        imgView.layer.position = CGPoint.init(x: posX, y: posY)
                        imgView.layer.frame = CGRect.init(x: posX, y:posY , width: Int(vc.bgView.frame.size.width), height: Int(vc.bgView.frame.size.height))
                        
                        imgView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
                        imgView.alpha = CGFloat(opacity/100)
                        if(rotate != 0){
                            let radians = CGFloat(Double(rotate) * Double.pi/180)
                            imgView.transform = CGAffineTransform(rotationAngle: radians)
                        }
                        //imgView.alpha = 1;
                        for (key , _) in (dic["children"] as! [String:AnyObject]) {
                            let tempDic = ((Helper.senarioDic!["data"] as! [String:AnyObject])[key]) as! [String:AnyObject]?
                            if(tempDic != nil){
                                let timeDic =  (tempDic!["laterTime"] as! [String:AnyObject])
                                if(timeDic != nil){
                                    if((tempDic!["tagName"] as! String) == TagName.Playse.rawValue){
                                        if let timeplayseVal = (tempDic!["laterTime"]){
                                            let timeplayse = Int((timeplayseVal as! [String:AnyObject])["value"] as! String)!
                                            
                                            let filename = URL.init(fileURLWithPath: ((tempDic!["name"] as! [String:AnyObject])["value"] as! String)).lastPathComponent
                                            FileHelper.shared.PlayOtherFileAfterInterval(fileName: filename, delayTime: Double(CGFloat(timeplayse/1000)))
                                            
                                        }
                                    }
                                    else if((tempDic!["tagName"] as! String) == TagName.Playvoice.rawValue){
                                        
                                        if let timeplayseVal = (tempDic!["laterTime"]){
                                            let timeplayse = Int((timeplayseVal as! [String:AnyObject])["value"] as! String)!
                                            print("Time3- \(Double(timeplayse))")
                                            let filename = URL.init(fileURLWithPath: ((tempDic!["name"] as! [String:AnyObject])["value"] as! String)).lastPathComponent
                                            FileHelper.shared.PlayOggFileAfterInterval(fileName: filename, delayTime: Double(CGFloat(timeplayse/1000)))
                                            
                                        }
                                    }
                                }
                            }
                        }
                        vc.index = vc.index + 1
                        vc.LoadAnimation()
                    })
                }})
        }
    }
    
    @objc func PlayOtherfile(timer: Timer){
        FileHelper.shared.PlayOtherFile(playFile: "sound/se/\(timer.userInfo as! String)")
        
    }
    
    @objc func PlayOggfile(timer: Timer){
        FileHelper.shared.PlayOggFile(playFile: "sound/voice/\(timer.userInfo as! String)")
    }
}

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
        
        let dispatchQues = DispatchQueue(label: "show")
        dispatchQues.async {
            let image = URL.init(fileURLWithPath: imageURL).lastPathComponent.removingPercentEncoding
            imgData = FileHelper.shared.GetCharacterImageFormZipFolder(fileName:image!) as Data
            
            DispatchQueue.main.async {
                if(imgData != nil){
                    let positions = Helper.CalculatePos(posX: posX, posY: posY, view: vc.bgView)
                    var waittime:Int = 0
                    var duration:Double = 0;
                    if(!wait!){
                        if(time==0){
                            duration = 0;
                        }
                        else{
                            duration = time.msToSeconds;
                        }
                    }
                    else{
                        if(time==0){
                            waittime=100
                        }
                        else{
                            waittime = time;
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + waittime.msToSeconds, execute: { () -> Void in
                        let imgView = UIImageView.init()
                        imgView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleBottomMargin.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleRightMargin.rawValue | UIView.AutoresizingMask.flexibleLeftMargin.rawValue | UIView.AutoresizingMask.flexibleTopMargin.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
                        imgView.contentMode = UIView.ContentMode.scaleAspectFill
                        
                        if(scale > 0){
                            //imgView.layer.contentsScale = CGFloat(scale)
                            imgView.transform = CGAffineTransform(scaleX: CGFloat(scale/100), y: CGFloat(scale/100))
                        }
                        imgView.alpha = 0;//CGFloat(opacity/100);
                        imgView.image = UIImage.init(data: imgData as Data)
                        imgView.frame = CGRect.init(x: positions.0, y:positions.1 , width: Int(vc.bgView.frame.size.width), height: Int(vc.bgView.frame.size.height))
                        
                        vc.bgView.addSubview(imgView)
                        vc.displayedImages[key] = imgView
                        imgView.layer.position = CGPoint.init(x: posX, y: posY)
                        imgView.layer.frame = vc.view.bounds
                        
                        UIView.animate(withDuration: duration, animations: { () -> Void in
                            imgView.fadeIn(value: 1)
                            imgView.layer.anchorPoint = CGPoint.init(x: ancherX, y: ancherY)
                            
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
                                //vc.index = vc.index + 1
                                //vc.LoadAnimation()
                            }
                            let dicSub = Helper.senarioDic!["data"]
                            let moreExist = (Helper.senarioDicLinks! as! [AnyObject])[Int(key)!]
                            if moreExist is [String:AnyObject]{
                                if(moreExist.count>0){
                                    if(dicSub != nil){
                                        for tag in Helper.charActionArr {
                                            let subDic = (dicSub as! [String:AnyObject]).filter { (arg0) -> Bool in
                                                let (_, value1) = arg0
                                                if (value1["parent"] as? String) != nil{
                                                    return ((value1["parent"] as! String) == key && (value1["tagName"] as! String) == tag.rawValue)
                                                }
                                                return false
                                                
                                            }
                                            if (subDic as? [String:AnyObject]) != nil{
                                                
                                                if(tag == TagName.CharaMove){
                                                    for (key2 , value2) in (subDic as! [String:AnyObject]){
                                                        CharacterMoveController.shared.SetAnimation(dic: (value2 as! [String:AnyObject]), vc: vc, key: key2)
                                                        print("Calling move")
                                                    }
                                                    
                                                }
                                                //                                            else if(tag == TagName.CharaHide){
                                                //                                                for (key2 , value2) in (subDic as! [String:AnyObject]){
                                                //                                                    CharacterHideController.shared.SetAnimation(dic: (value2 as! [String:AnyObject]), vc: vc, key: key2)
                                                //                                                }
                                                //                                            }
                                            }
                                            
                                        }
                                        
                                    }
                                }
                            }
                            vc.index = vc.index + 1
                            vc.LoadAnimation()
                        })
                    })
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

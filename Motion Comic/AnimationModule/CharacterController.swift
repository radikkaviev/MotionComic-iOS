//
//  CharacterController.swift
//  Motion Comic
//
//  Created by Apple on 27/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class CharacterController: NSObject {
    private static var sharedInstance: CharacterController?
    class var shared : CharacterController {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = CharacterController()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
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
        var wait:Bool = false
        var imageURL:String = ""
        var label:String = ""
        var name:String = ""
        
        if let nameVal = (dic["name"]){
            name = (nameVal as! String)
        }
        if let ancherXval = (dic["anchorX"]){
            ancherX = Double(ancherXval as! String)!
        }
        if let ancherYval = (dic["anchorY"]){
            ancherY = Double(ancherYval as! String)!
        }
        if let centerVal = (dic["center"]){
            center = Bool(centerVal as! String)
        }
        if let labelval = (dic["label"]){
            label = (labelval as! String)
        }
        if let posXVal = (dic["posX"]){
            posX = Int(posXVal as! String)!
        }
        if let posYVal = (dic["posY"]){
            posY = Int(posYVal as! String)!
        }
        if let scaleVal = (dic["scale"]){
            scale = Int(scaleVal as! String)!
        }
        if let opacityVal = (dic["opacity"]){
            opacity = Int(opacityVal as! String)!
        }
        if let rotateVal = (dic["rotate"]){
            rotate=Int(rotateVal as! String)!
        }
        if let blurValue = (dic["blur"]){
            blur = Int(blurValue as! String)!
        }
        if let timeVal = (dic["time"]){
            time = Int(timeVal as! String)!
        }
        if let waitVal = (dic["wait"]){
            wait = Bool(waitVal as! String)!
        }
        if let imageURLVal = (dic["image"]){
            imageURL = (imageURLVal as! String)
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
                    if(!wait){
                        if(time==0){
                            duration = 0;
                        }
                        else{
                            duration = time.msToSeconds;
                        }
                    }
                    else{
                        waittime = time;

                    }
                   
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+waittime.msToSeconds, execute: { () -> Void in
                        let imgView = UIImageView.init()
                        imgView.alpha = 0;
                        imgView.clipsToBounds = false;
                        imgView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleBottomMargin.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleRightMargin.rawValue | UIView.AutoresizingMask.flexibleLeftMargin.rawValue | UIView.AutoresizingMask.flexibleTopMargin.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
                        imgView.contentMode = UIView.ContentMode.scaleAspectFill
                        imgView.image = UIImage.init(data: imgData as Data)
                        imgView.frame = CGRect.init(x: positions.0, y:(Int(vc.bgView.frame.size.height/2)-Int(vc.bgView.frame.size.height/4)) , width: Int(vc.bgView.frame.size.width), height: Int(vc.bgView.frame.size.height/2))
                        imgView.layer.position = CGPoint.init(x: posX, y: posY)
                        if(center == true){
                            //imgView.layer.contentsGravity = .center
                        }
                        imgView.layer.frame = vc.bgView.bounds
                        vc.bgView.addSubview(imgView)
                        imgView.layer.anchorPoint = CGPoint.init(x: ancherX, y: ancherY)
                        vc.displayedImages[label] = imgView
                        UIView.animate(withDuration: duration, animations: { () -> Void in
                            imgView.alpha = CGFloat(opacity)/100
                            if(scale > 0){
                                print("Chara_Show-scale")
                                print(scale)
                                if(scale>110){
                                    scale = 110
                                }
                                imgView.transform = CGAffineTransform(scaleX: CGFloat(scale)/100, y: CGFloat(scale)/100)
                                
                            }
                            vc.index = vc.index + 1
                            vc.LoadAnimation()
                        })
                    })
                }
            }
        }
    }
    
    class func dispose()
    {
        CharacterController.sharedInstance = nil
        print("Disposed Singleton instance")
    }
    
}

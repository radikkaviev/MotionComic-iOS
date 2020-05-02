//
//  Helper.swift
//  Motion Comic
//
//  Created by Apple on 23/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner
public class Helper{
    public static var senarioJSON:String = "";
    public static var senarioDic:[String: Any]!;
    public static var senarioDicLinks:[AnyObject]!;
    public static var senarioDicDataArr:[AnyObject]!;
    public static var senarioAllKeys:[String] = [String]();
    public static var hideParentKeys:[String] = [String]();
    public static var senarioFilterData:[String:[String:AnyObject]] = [String:[String:AnyObject]]();
    public static var childArr:[String] = [String]();
    public static var moveChilds:[String] = [String]();
    public static var charActionArr:[TagName] = [TagName.CharaMove,TagName.CharaHide]
    public static func ShowAlert(title:String,message:String,btntitle:String,vc:UIViewController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: btntitle, style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func ShowLoadder(message:String){
        SwiftSpinner.showBlurBackground = true;
        SwiftSpinner.show(message)
    }
    
    static func HideLoadder(){
        SwiftSpinner.hide()
    }
    
    static func CalculatePos(posX:Int,posY:Int,view:UIView) -> (Int,Int){
        let webwidth:Int =  640;
        let webHeight:Int =  960;
        let widthPer:Int = (posX*100)/webwidth
        let heightPer:Int = (posY*100)/webHeight
        let viewWidth:Int = Int(view.frame.size.width)
        let viewHeight:Int = Int(view.frame.size.height)
        let calWidth:Int = ((viewWidth * widthPer)/100)
        let calHeight:Int = ((viewHeight * heightPer)/100)
        return (0,0)
    }
    
    static func resizeImage(image: UIImage, scale:CGFloat) -> UIImage {
        
        let newscale = scale / image.size.width
        let newwidth = image.size.width + scale
        let newHeight = image.size.height + scale
        UIGraphicsBeginImageContext(CGSize.init(width: newwidth, height: newHeight))
        image.draw(in: CGRect.init(x: 0, y: 0, width: newwidth, height: newwidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
}

public enum TagName: String {
    case CharaMove = "chara_move"
    case CharaHide = "chara_hide"
    case Stopse = "stopse"
    case Sfade = "sfade"
    case Charashow = "chara_show"
    case Playvoice = "playvoice"
    case Wait = "wait"
    case SpineMove = "spine_move"
    case Select = "select"
    case Playbgm = "playbgm"
    case End = "end"
    case Stopbgm = "stopbgm"
    case Playse = "playse"
    case SpineHide = "spine_hide"
    case Spine = "spine"
    case DefaultColor = "defaultColor"
    case Quake = "quake"
}


public enum AudioFileType: String {
    case OGG = "ogg"
    case MP3 = "mp3"
}

extension String {

    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension UIButton {
    func addLeftPadding(_ padding: CGFloat) {
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: -padding)
        contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: padding)
    }
    func addRightPadding(_ padding: CGFloat) {
           titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -padding, bottom: 0.0, right: padding)
        contentEdgeInsets = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: 0.0)
    }
}

extension UIView {
    func fadeIn(value:Double,delay:Double=0.0,duration:Double=1.0) {
        // Move our fade out code from earlier
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = CGFloat(value) // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    
    func fadeOut(value:Double,delay:Double=0.0,duration:Double=1.0) {
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = CGFloat(value)
        }, completion: nil)
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(Float(self) / 1000)
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

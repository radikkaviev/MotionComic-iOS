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
    public static var senarioDicDataArr:[AnyObject]!;
    public static var senarioAllKeys:[String] = [String]();
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

extension UIView {
    func fadeIn(value:Double,delay:Double=0.0,duration:Double=1.0) {
         // Move our fade out code from earlier
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = CGFloat(value) // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
             }, completion: nil)
    }

    func fadeOut(value:Double,delay:Double=0.0,duration:Double=1.0) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = CGFloat(value)
            }, completion: nil)
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}

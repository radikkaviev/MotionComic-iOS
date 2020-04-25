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
    public static var senarioDic:[String: Any]?;
    public static var senarioDicDataArr:[AnyObject]?;
    
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

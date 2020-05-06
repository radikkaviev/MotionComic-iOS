//
//  HomeVC.swift
//  Motion Comic
//
//  Created by Jigar on 13/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
import Photos
import MobileCoreServices
import WebKit
import AVKit
import JavaScriptCore


class HomeVC: UIViewController,WKNavigationDelegate,WKUIDelegate {
    @IBOutlet var img:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FileHelper.shared.StopPlayer();
        FileHelper.shared.StopOggPlayer();
        FileHelper.playersOtherInPlayModes.removeAll()
        FileHelper.playersOggInPlayModes.removeAll()
    }
    
    @IBAction func btnOpenFile(sender:UIButton){
        self.openCloud()
    }
    
    @IBAction func btnSelected(_ sender: Any) {
        Helper.ShowLoadder(message: "Processing..")
        DispatchQueue.global(qos: .background).async {
            FileHelper.shared.GetJSONString();
            //let senarioJSOn = FileHelper.shared.read(fromDocumentsWithFileName: "STK/scenario/main.sc")
            let senarioJSOn = FileHelper.shared.read(fromDocumentsWithFileName: "STK/script/main.ssk")
            let arrScript = senarioJSOn.components(separatedBy: .newlines)
            Helper.animationList.removeAll()
            for obj in arrScript{
                let arrobjects = obj.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "\"", with: "").components(separatedBy: .whitespaces)
                var jsonObject: [String:AnyObject] = [String:AnyObject]()
                print("arraobj+-\(arrobjects)")
                for objKey in arrobjects{
                    if(objKey != "" && objKey != "animations" && objKey != "<select" ){
                        let arrObjKeys = (objKey as! String).split(separator: "=")
                        if(arrObjKeys.count>1){
                            jsonObject[String(arrObjKeys[0])] = arrObjKeys[1] as AnyObject
                            //jsonObject.setValue(String(arrObjKeys[1]), forKey: String(arrObjKeys[0]))
                        }
                        else{
                            print("tagName+-\(arrObjKeys[0] as AnyObject)")
                            if((jsonObject["tagName"]) == nil){
                                jsonObject["tagName"] = arrObjKeys[0] as AnyObject
                            }
                            //jsonObject.setValue(String(arrObjKeys[0]), forKey: "tagname")
                        }
                    }
                }
                if(jsonObject.keys.count>0){
                    Helper.animationList.append(jsonObject)
                }
            }
            DispatchQueue.main.async {
                let pathVC = storyBoard.instantiateViewController(withIdentifier: "PathVC") as! PathVC
                self.navigationController?.pushViewController(pathVC, animated: true)
                Helper.HideLoadder()
            }
            
        }
        
    }
}


//MARK:- UIDocumentPickerDelegate
extension HomeVC: UIDocumentPickerDelegate {
    
    func openCloud() {
        
        let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        documentPickerController.delegate = self
        documentPickerController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPickerController, animated: true, completion: nil)
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        if let filename =  urls.first?.pathExtension {
            if(filename != "data"){
                Helper.ShowAlert(title: "Alert", message: "Invalid File", btntitle: "OK", vc: self)
                return;
            }
        }
        var result:Bool = false;
        Helper.ShowLoadder(message: "Processing..")
        DispatchQueue.global(qos: .background).async {
            let filedata = NSData.init(contentsOf: urls.first!)
            result = FileHelper.shared.SaveFile(withFileName: "STK.zip", data: filedata!)
            
            DispatchQueue.main.async {
                if(!result){
                    Helper.ShowAlert(title: "Failed", message: "Unable to use file.", btntitle: "OK", vc: self)
                }
                else{
                    if controller.documentPickerMode == UIDocumentPickerMode.import {
                        
                        let pathVC = storyBoard.instantiateViewController(withIdentifier: "PathVC") as! PathVC
                        self.navigationController?.pushViewController(pathVC, animated: true)
                        
                    }
                    Helper.HideLoadder()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
}

//MARK:- Button Click
extension HomeVC {
    
    @IBAction func openFileTapped(_ sender: UIButton) {
        
        self.openCloud()
        
    }
}

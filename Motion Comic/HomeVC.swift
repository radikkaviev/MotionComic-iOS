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
            let senarioJSOn = FileHelper.shared.read(fromDocumentsWithFileName: "STK/scenario/main.sc")
            Helper.senarioDic = Helper.convertToDictionary(text: senarioJSOn)
            Helper.senarioDicLinks = (Helper.senarioDic!["links"] as! [AnyObject])
            Helper.senarioAllKeys.removeAll()
            Helper.senarioFilterData.removeAll()
            Helper.childArr.removeAll()
            for (key, value) in (Helper.senarioDic!["data"] as! [String:AnyObject]) {
                if let isparent = value["parent"]{
                    if (isparent as? String) == nil{
                        if let objexist = Helper.senarioFilterData[key]{
                            print("exist")
                        }
                        else{
                            
                            let dicarr = (Helper.senarioDic!["data"] as! [String:AnyObject]).filter({ (arg0) -> Bool in
                                
                                let (_, value1) = arg0
                                if let parent = value1["parent"] as? String{
                                    return (value1["parent"] as! String) == key
                                }
                                return false
                                }
                            )
                            if(key == "280"){
                                print(key)
                            }
                            if(!Helper.childArr.contains(key)){
                                for k in dicarr.keys {
                                    Helper.childArr.append(k)
                                }
                                Helper.senarioFilterData[key] = dicarr
                                Helper.senarioAllKeys.append(key);
                            }
                            
                        }
                    }
                }
                
            }
            //print(Helper.childArr)
            Helper.senarioAllKeys = Helper.senarioAllKeys.sorted()
            //print(Helper.senarioAllKeys)
//          //print(Helper.tagArr)
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

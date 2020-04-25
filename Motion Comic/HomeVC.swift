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
    
    @IBAction func btnOpenFile(sender:UIButton){
        self.openCloud()
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

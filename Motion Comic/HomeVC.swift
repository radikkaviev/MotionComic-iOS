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

class HomeVC: UIViewController {
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

//MARK:- UIDocumentPickerDelegate
extension HomeVC: UIDocumentPickerDelegate {
    
    func openCloud() {
        
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypePlainText), String(kUTTypeMP3), String(kUTTypeFont), String(kUTTypeRTFD), String(kUTTypeContent), String(kUTTypeSpreadsheet), String(kAudioFileGlobalInfo_UTIsForType)], in: .import)
        documentPickerController.delegate = self
        documentPickerController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPickerController, animated: true, completion: nil)

    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        if controller.documentPickerMode == UIDocumentPickerMode.import {
                       
            let pathVC = storyBoard.instantiateViewController(withIdentifier: "PathVC") as! PathVC
            pathVC.selectedPath = urls.first?.absoluteString ?? ""
            self.navigationController?.pushViewController(pathVC, animated: true)
                        
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

//
//  PathVC.swift
//  Motion Comic
//
//  Created by Jigar on 13/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class PathVC: UIViewController {
    
    @IBOutlet var txtPath: UITextView!
    @IBOutlet var imgView:UIImageView!
    var selectedPath: String = ""
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Motion Comic"
        //FileHelper.PlayOggFile(playFile: "STK/resource/sound/voice/MC01_BOY_01.ogg")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FileHelper.shared.PlayOggFile(playFile: "STK/resource/sound/voice/MC01_BOY_02.ogg")
        FileHelper.shared.PlayOtherFile(playFile: "STK/resource/sound/bgm/bgm_004.mp3")
    }
    
    
}

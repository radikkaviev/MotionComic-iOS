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
    
    var selectedPath: String = ""
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtPath.text = selectedPath
        
    }
}

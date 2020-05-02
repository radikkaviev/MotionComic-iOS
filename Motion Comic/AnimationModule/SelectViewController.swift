//
//  SelectViewController.swift
//  Motion Comic
//
//  Created by Apple on 30/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class SelectViewController: UIView {
    static let shared = SelectViewController()
    private var _vc:PathVC!
    public func SetEndView(vc:PathVC,key:String){
        self._vc = vc;
        self.frame = vc.view.bounds;
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { () -> Void in
                let stackView   = UIStackView()
                stackView.axis  = .vertical
                stackView.distribution  = UIStackView.Distribution.equalSpacing
                stackView.alignment = UIStackView.Alignment.center
                stackView.spacing   = 16.0
                stackView.translatesAutoresizingMaskIntoConstraints = false
  
                self.addSubview(stackView)
                stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

                
                let dicSub = Helper.senarioDic!["data"]
                let subDic = (dicSub as! [String:AnyObject]).filter { (arg0) -> Bool in
                    let (_, value1) = arg0
                    return ((value1["tagName"] as! String) == TagName.Select.rawValue)
                    
                }
                if (subDic as? [String:AnyObject]) != nil{
                    
                    for (key2 , value2) in (subDic as! [String:AnyObject]){
                        if let imageURLVal = (value2["image"]){
                            
                            let image = URL.init(fileURLWithPath: (imageURLVal as! [String:AnyObject])["value"] as! String).lastPathComponent.removingPercentEncoding!
                            let imgData = FileHelper.shared.GetEndImageFormZipFolder(fileName:image) as Data
                            let button = UIButton.init()
                            let Image = UIImage.init(data: imgData as Data)
                            button.setBackgroundImage(Image, for: UIControl.State.normal)
                            button.frame = CGRect.init(x:0, y: 0, width:200, height: 40)
                            if let title = (value2["text"]){
                                button.setTitle(((title as! [String:AnyObject])["value"] as! String), for: UIControl.State.normal)
                                button.titleLabel?.textColor = UIColor.white
                               
                            }
                            button.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                           
                            button.clipsToBounds = true;
                            button.addTarget(self, action: #selector(self.StartAnimation), for: .touchUpInside)
                            stackView.addArrangedSubview(button)
                        }
                    }
                }
            })
        }
    
    @IBAction func StartAnimation(){
        _vc.RestartAnimation()
        self.removeFromSuperview()
    }
}

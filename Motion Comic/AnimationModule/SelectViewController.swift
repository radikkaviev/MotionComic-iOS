//
//  SelectViewController.swift
//  Motion Comic
//
//  Created by Apple on 30/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit

class SelectViewController: UIView {
    private static var sharedInstance: SelectViewController?
    class var shared : SelectViewController {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = SelectViewController()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
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

                
               let arrFrame = Helper.animationList
                let subDic = arrFrame.filter {
                    if($0.keys.count>0){
                        print($0["tagName"] as! String)
                       return ($0["tagName"] as! String) == "select"
                    }
                    return false;
                }
                if (subDic as? [[String:AnyObject]]) != nil{
                    
                    for value2 in subDic{
                        if let imageURLVal = (value2["image"]){
                            
                            let image = URL.init(fileURLWithPath: (imageURLVal as! String)).lastPathComponent.removingPercentEncoding!
                            let imgData = FileHelper.shared.GetEndImageFormZipFolder(fileName:image) as Data
                            let button = UIButton.init()
                            let Image = UIImage.init(data: imgData as Data)
                            button.setBackgroundImage(Image, for: UIControl.State.normal)
                            button.frame = CGRect.init(x:0, y: 0, width:200, height: 40)
                            if let title = (value2["text"]){
                                button.setTitle((title as! String), for: UIControl.State.normal)
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
    class func dispose()
    {
        SelectViewController.sharedInstance = nil
        print("Disposed Singleton instance")
    }
}

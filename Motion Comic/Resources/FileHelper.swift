//
//  Helper.swift
//  Motion Comic
//
//  Created by Apple on 23/04/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import Foundation
import AVFoundation
import Zip

public class FileHelper{
    static let shared = FileHelper()
    public var avPlayer:AVAudioPlayer? = nil
    public var oggPlayer:IDZAQAudioPlayer? = nil
    private var oggDecoder:IDZOggVorbisFileDecoder? = nil
    public static var playersOtherInPlayModes:[String:AVAudioPlayer] = [String:AVAudioPlayer]()
    public static var playersOggInPlayModes:[String:IDZAQAudioPlayer] = [String:IDZAQAudioPlayer]()
    
    private let  fileManager = FileManager.default
    private  func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask,
                                                                    true)
        return documentDirectory[0]
    }
    
    private  func append(toPath path: String,
                         withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            
            return pathURL.absoluteString
        }
        
        return nil
    }
    
    public  func save(text: String,
                      toDirectory directory: String,
                      withFileName fileName: String) {
        guard let filePath = self.append(toPath: directory,
                                         withPathComponent: fileName) else {
                                            return
        }
        
        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error", error)
            return
        }
        
        print("Save successful")
    }
    
    public  func Copy(fromDirectory: String,
                      withFileName fileName: String) {
        guard let filePath = self.append(toPath:  self.documentDirectory(),
                                         withPathComponent: fileName) else {
                                            return
        }
        
        do {
            try fileManager.copyItem(atPath: fromDirectory, toPath: filePath)
        } catch {
            print("Error", error)
            return
        }
        
        print("Save successful")
    }
    
    public  func SaveFile(withFileName fileName: String,data:NSData)->Bool{
        guard let filePath = self.append(toPath:  self.documentDirectory(),
                                         withPathComponent: fileName) else {
                                            return false
        }
        do {
            try
                fileManager.createFile(atPath: filePath, contents: data as Data, attributes: nil)
            UnZipFilePath();
            GetJSONString();
            return true;
            
        } catch {
            print("Error", error)
            return false;
        }
        return true;
        print("Save successful")
    }
    
    public  func DeleteZipFile(withFileName fileName: String) {
        guard let filePath = self.append(toPath:  self.documentDirectory(),
                                         withPathComponent: fileName) else {
                                            return
        }
        do {
            try fileManager.removeItem(atPath: filePath)
            
        } catch {
            print("Error", error)
            return
        }
        
        print("Save successful")
    }
    
    public  func read(fromDocumentsWithFileName fileName: String)->String {
        guard let filePath = self.append(toPath: self.documentDirectory(),
                                         withPathComponent: fileName) else {
                                            return "{}"
        }
        
        do {
            
            let savedString = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
            //print(savedString)
            return savedString
            
        } catch {
            print("Error reading saved file")
        }
        return "{}"
    }
    
    public  func GetJSONString(){
        guard let filePath = self.append(toPath:  self.documentDirectory(),
                                         withPathComponent: "STK/scenario/main.sc") else {
                                            return
        }
        do {
            let filedata = try NSData.init(contentsOf: URL.init(fileURLWithPath: filePath))
            fileManager.createFile(atPath: filePath, contents: filedata as! Data, attributes: nil)
            guard let jsonfilePath = self.append(toPath: self.documentDirectory(),
                                                 withPathComponent: "STK/scenario/main.txt") else {
                                                    return
            }
            
        } catch {
            print("Error", error)
            
        }
        
    }
    
    public  func GetFile(fromDocumentsWithFileName fileName: String)->NSData {
        var filedata:NSData?
        guard let filePath = self.append(toPath: self.documentDirectory(),
                                         withPathComponent: fileName) else {
                                            return NSData();
        }
        
        do {
            if fileManager.fileExists(atPath: filePath){
                
                filedata = NSData.init(contentsOfFile: filePath)
                
            }else{
                print("File does not exist")
            }
            
        } catch {
            print("Error reading saved file")
        }
        return filedata!;
    }
    
    public  func UnZipFilePath()->String{
        do {
            guard let filePath = self.append(toPath: self.documentDirectory(),
                                             withPathComponent: "STK.zip") else {
                                                return "";
            }
            let unzipDirectory = try Zip.quickUnzipFile(URL.init(fileURLWithPath: filePath))
            DeleteZipFile(withFileName: "STK.zip")
            //let senarioJSOn = FileHelper.shared.read(fromDocumentsWithFileName: "STK/script/main.ssk")
            //let senarioJSOn = read(fromDocumentsWithFileName: "STK/scenario/main.sc")
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
                        }
                        else{
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
            return unzipDirectory.absoluteString;
        }
        catch {
            print("Something went wrong")
        }
        return "";
    }
    
    
    public  func GetCharacterImageFormZipFolder(fileName:String)->NSData{
        do {
            var isDir : ObjCBool = true
            guard let filePath = self.append(toPath: self.documentDirectory(),
                                             withPathComponent: "STK/resource/character") else {
                                                return NSData.init()
            }
            
            if fileManager.fileExists(atPath: filePath, isDirectory: &isDir) {
                if isDir.boolValue {
                    let url = URL.init(fileURLWithPath: filePath+"/"+fileName.removingPercentEncoding!)
                    return try NSData.init(contentsOf: url)
                }
            }
        }
        catch {
            print("Something went wrong")
        }
        return NSData.init()
    }
    
    public  func GetSoundFileFormZipFolder(fileName:String,subDirectory:String)->NSData{
        do {
            var isDir : ObjCBool = true
            guard let filePath = self.append(toPath: self.documentDirectory(),
                                             withPathComponent: "STK/sound/\(subDirectory)") else {
                                                return NSData.init()
            }
            
            if fileManager.fileExists(atPath: filePath, isDirectory: &isDir) {
                if isDir.boolValue {
                    let url = URL.init(fileURLWithPath: filePath+"/"+fileName.removingPercentEncoding!)
                    return try NSData.init(contentsOf: url)
                }
            }
        }
        catch {
            print("Something went wrong")
        }
        return NSData.init()
    }
    
    public  func GetBGFileFormZipFolder(fileName:String,subDirectory:String)->NSData{
        do {
            var isDir : ObjCBool = true
            guard let filePath = self.append(toPath: self.documentDirectory(),
                                             withPathComponent: "STK/bg/") else {
                                                return NSData.init()
            }
            
            if fileManager.fileExists(atPath: filePath, isDirectory: &isDir) {
                if isDir.boolValue {
                    let url = URL.init(fileURLWithPath: filePath+"/"+fileName.removingPercentEncoding!)
                    return try NSData.init(contentsOf: url)
                }
            }
        }
        catch {
            print("Something went wrong")
        }
        return NSData.init()
    }
    
    public  func GetCommonEffectFileFormZipFolder(fileName:String,subDirectory:String)->NSData{
        do {
            var isDir : ObjCBool = true
            guard let filePath = self.append(toPath: self.documentDirectory(),
                                             withPathComponent: "STK/common/effects") else {
                                                return NSData.init()
            }
            
            if fileManager.fileExists(atPath: filePath, isDirectory: &isDir) {
                if isDir.boolValue {
                    let url = URL.init(fileURLWithPath: filePath+"/"+fileName.removingPercentEncoding!)
                    return try NSData.init(contentsOf: url)
                }
            }
        }
        catch {
            print("Something went wrong")
        }
        return NSData.init()
    }
    
    public  func GetCommonSelectBarFileFormZipFolder(fileName:String,subDirectory:String)->NSData{
        do {
            var isDir : ObjCBool = true
            guard let filePath = self.append(toPath: self.documentDirectory(),
                                             withPathComponent: "STK/common/select/bar") else {
                                                return NSData.init()
            }
            
            if fileManager.fileExists(atPath: filePath, isDirectory: &isDir) {
                if isDir.boolValue {
                    let url = URL.init(fileURLWithPath: filePath+"/"+fileName.removingPercentEncoding!)
                    return try NSData.init(contentsOf: url)
                }
            }
        }
        catch {
            print("Something went wrong")
        }
        return NSData.init()
    }
    
    public  func GetEndImageFormZipFolder(fileName:String)->NSData{
        do {
            var isDir : ObjCBool = true
            guard let filePath = self.append(toPath: self.documentDirectory(),
                                             withPathComponent: "STK/resource/common/select/bar") else {
                                                return NSData.init()
            }
            
            if fileManager.fileExists(atPath: filePath, isDirectory: &isDir) {
                if isDir.boolValue {
                    let url = URL.init(fileURLWithPath: filePath+"/"+fileName.removingPercentEncoding!)
                    return try NSData.init(contentsOf: url)
                }
            }
        }
        catch {
            print("Something went wrong")
        }
        return NSData.init()
    }
    
    public  func PlayOggFile(playFile:String){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { () -> Void in
            UIView.animate(withDuration: 0, animations: { () -> Void in
                do {
                    guard let filePath = self.append(toPath: self.documentDirectory(),
                                                     withPathComponent: playFile) else {
                                                        return
                    }
                    if(self.fileManager.fileExists(atPath: filePath.removingPercentEncoding!)){
                        self.oggDecoder = try IDZOggVorbisFileDecoder.init(contentsOf: URL.init(fileURLWithPath: filePath.removingPercentEncoding!))
                        self.oggPlayer = try IDZAQAudioPlayer.init(decoder: self.oggDecoder)
                        let filename = URL.init(fileURLWithPath: playFile).lastPathComponent
                        FileHelper.playersOggInPlayModes[filename] = self.oggPlayer
                        self.oggPlayer!.prepareToPlay()
                        self.oggPlayer!.play();
                        
                    }
                }
                catch {
                    print("Something went wrong")
                }
                DispatchQueue.main.async {
                    
                }
            })
        })
        
    }
    
    public  func PlayOtherFile(playFile:String,volume:Float=100){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { () -> Void in
            UIView.animate(withDuration: 0, animations: { () -> Void in
                do {
                    guard let filePath = self.append(toPath: self.documentDirectory(),
                                                     withPathComponent: playFile) else {
                                                        return
                    }
                    print(filePath.removingPercentEncoding!)
                    if(self.fileManager.fileExists(atPath: filePath.removingPercentEncoding!)){
                        self.avPlayer = try AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: filePath.removingPercentEncoding!))
                        let filename = URL.init(fileURLWithPath: playFile).lastPathComponent
                        FileHelper.playersOtherInPlayModes[filename] = self.avPlayer
                        self.avPlayer!.prepareToPlay()
                        self.avPlayer!.play();
                    }
                }
                catch {
                    print("Something went wrong")
                }
            })
        })
    }
    
    
    public func StopPlayer(){
        DispatchQueue.global(qos: .background).async {
            if((self.avPlayer) != nil){
                self.avPlayer?.stop()
                self.avPlayer=nil
            }
        }
    }
    public func StopOggPlayer(){
        DispatchQueue.global(qos: .background).async {
            if((self.oggPlayer) != nil){
                self.oggPlayer?.stop()
                self.avPlayer=nil
            }
        }
    }
    
    public func StopOtherPlayer(key:String){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { () -> Void in
            var avPlayer = FileHelper.playersOtherInPlayModes[key]
            if((avPlayer) != nil){
                avPlayer?.stop()
                avPlayer=nil
            }
        })
    }
    public func StopOggPlayer(key:String){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { () -> Void in
            
            print(FileHelper.playersOggInPlayModes)
            var oggPlayer = FileHelper.playersOggInPlayModes[key]
            if((oggPlayer) != nil){
                oggPlayer?.stop()
                oggPlayer=nil
            }
            
        })
    }
    
    public func StopAllOggPlayer(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { () -> Void in
            
            print(FileHelper.playersOggInPlayModes)
            for (_ , value) in FileHelper.playersOggInPlayModes {
               
                if((value) != nil){
                    value.stop()
                }
            }
            //FileHelper.playersOggInPlayModes.removeAll()
        })
    }
    
    
    public func PlayOggFileAfterInterval(fileName:String,delayTime:Double){
        print("delayTime1- \(delayTime)")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: { () -> Void in
            UIView.animate(withDuration: 0, animations: { () -> Void in
                FileHelper.shared.PlayOggFile(playFile: "sound/voice/\(fileName)")
            })
        })
    }
    
    public func PlayOtherFileAfterInterval(fileName:String,delayTime:Double){
        print("delayTime2- \(delayTime)")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: { () -> Void in
            UIView.animate(withDuration: 0, animations: { () -> Void in
                // your animation logic here
                FileHelper.shared.PlayOtherFile(playFile: "sound/se/\(fileName)")
            })
        })
    }
    
}

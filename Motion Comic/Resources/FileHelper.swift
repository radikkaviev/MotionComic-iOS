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
    private var avPlayer:AVAudioPlayer? = nil
    private var oggPlayer:IDZAQAudioPlayer? = nil
    private var oggDecoder:IDZOggVorbisFileDecoder? = nil
    
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
            print(savedString)
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
            let senarioJSOn = read(fromDocumentsWithFileName: "STK/scenario/main.sc")
            Helper.senarioDic = Helper.convertToDictionary(text: senarioJSOn)
            Helper.senarioAllKeys.removeAll()
            for (key, value) in (Helper.senarioDic!["data"] as! [String:AnyObject]) {
                Helper.senarioAllKeys.append(key);
            }
            Helper.senarioAllKeys = Helper.senarioAllKeys.sorted()
            print(Helper.senarioAllKeys)
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
    
    public  func PlayOggFile(playFile:String){
        DispatchQueue.global(qos: .background).async {
            do {
                guard let filePath = self.append(toPath: self.documentDirectory(),
                                                 withPathComponent: "STK/resource/\(playFile)") else {
                                                    return
                }
                if(self.fileManager.fileExists(atPath: filePath)){
                    self.oggDecoder = try IDZOggVorbisFileDecoder.init(contentsOf: URL.init(fileURLWithPath: filePath))
                    self.oggPlayer = try IDZAQAudioPlayer.init(decoder: self.oggDecoder)
                    self.oggPlayer!.prepareToPlay()
                    self.oggPlayer!.play();
                }
            }
            catch {
                print("Something went wrong")
            }
            DispatchQueue.main.async {
                
            }
        }
    }
    
    public  func PlayOtherFile(playFile:String){
        DispatchQueue.global(qos: .default).async {
            do {
                guard let filePath = self.append(toPath: self.documentDirectory(),
                                                 withPathComponent: "STK/resource/\(playFile)") else {
                                                    return
                }
                if(self.fileManager.fileExists(atPath: filePath)){
                    self.avPlayer = try AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: filePath))
                    self.avPlayer!.prepareToPlay()
                    self.avPlayer!.play();
                }
            }
            catch {
                print("Something went wrong")
            }
            DispatchQueue.main.async {
                
            }
        }
    }
    
    public func StopPlayer(){
        if((self.avPlayer) != nil){
            self.avPlayer?.stop()
        }
    }
    public func StopOggPlayer(){
        if((self.oggPlayer) != nil){
            self.oggPlayer?.stop()
        }
    }
}

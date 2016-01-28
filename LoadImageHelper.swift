//
//  LoadImageHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/28/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import Foundation


class LoadImageHelper{
    private static var Instance: LoadImageHelper? = nil
    var ImageDic: Dictionary<String,UIImage> = Dictionary<String,UIImage>()
  
    //创建单例
    class func GetInstance()->LoadImageHelper{
        if self.Instance == nil {
            self.Instance = LoadImageHelper()
        }
        return self.Instance!
    }
    class func CleanImageDic(){
        if self.Instance != nil{
            self.Instance!.ImageDic = Dictionary<String,UIImage>()
            self.Instance = nil
        }
    }
    
    
    func IsExist(keyName:String)->Bool{
        for key in self.ImageDic.keys{
            if key == keyName{
            return true
            }
        }
        return false
    }
    
    func GetImage(imageName:String)->UIImage{
        var Name  = themeName + "_" + imageName + ".png"
        if IsExist(Name){
        return self.ImageDic[Name]!
        }
        else{
            let img = UIImage(named:Name)
            self.ImageDic[Name] = img
            return img!
        }
    }
    
   
}

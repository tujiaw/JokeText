//
//  ImageJokeResponse.swift
//  JokeText
//
//  Created by tutujiaw on 15/11/22.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ImgJoke {
    var title = ""
    var thumburl = ""
    var width = 0
    var height = 0
}

class ImageJokeResponse {
    
    static let sharedManager = ImageJokeResponse()
    
    var resCode = -1
    var resError = ""
    var list = [ImgJoke]()
    
    func setData(object: AnyObject) {
        let json = JSON(object)
        self.resCode = json["showapi_res_code"].int ?? -1
        self.resError = json["showapi_res_error"].string ?? ""
        
        if self.list.count > 100 {
            self.list = [ImgJoke]()
        }
        
        if let itemList = json["showapi_res_body"]["list"].array {
            for item in itemList {
                guard let title = item["title"].string,
                    let thumburl = item["thumburl"].string,
                    let width = item["width"].string,
                    let height = item["height"].string else {
                        continue
                }
                let iWidth = Int(NSString(string: width).intValue)
                let iHeight = Int(NSString(string: height).intValue)
                self.list.append(ImgJoke(title: title, thumburl: thumburl, width: iWidth, height: iHeight))
            }
        }
    }
    
    func clear() {
        list = [ImgJoke]()
    }
}
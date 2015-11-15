//
//  JokeTextResponse.swift
//  JokeText
//
//  Created by tutujiaw on 15/11/12.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import Foundation
import SwiftyJSON

struct JokeItem {
    var title = ""
    var text = ""
    var ct = ""
}

class Response {
    
    static let sharedManager = Response()
    
    var resCode = -1
    var resError = ""
    var allNum = 0
    var allPages = 0
    var currentPage = 0
    var maxResult = 0
    var contentList = [JokeItem]()
    
    func setData(object: AnyObject) {
        let json = JSON(object)
        self.resCode = json["showapi_res_code"].int ?? -1
        self.resError = json["showapi_res_error"].string ?? ""
        
        let bodyJson = json["showapi_res_body"]
        self.allNum = bodyJson["allNum"].int ?? 0
        self.allPages = bodyJson["allPages"].int ?? 0
        self.currentPage = bodyJson["currentPage"].int ?? 0
        self.maxResult = bodyJson["maxResult"].int ?? 0
        
        if self.currentPage == 1 {
            self.contentList = [JokeItem]()
        }
        
        if let contentList = json["showapi_res_body"]["contentlist"].array {
            for content in contentList {
                guard let title = content["title"].string, let text = content["text"].string, let ct = content["ct"].string else {
                    continue
                }
                self.contentList.append(JokeItem(title: title, text: text, ct: ct))
            }
        }
    }
}


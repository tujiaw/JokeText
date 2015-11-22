//
//  LaifuJokeResponse.swift
//  JokeText
//
//  Created by tutujiaw on 15/11/18.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TextJoke {
    var title = ""
    var content = ""
    var poster = ""
    var url = ""
}

class LaifuResponse {
    
    static let sharedManager = LaifuResponse()
    
    var resCode = -1
    var resError = ""
    var list = [TextJoke]()
    
    func setData(object: AnyObject) {
        let json = JSON(object)
        self.resCode = json["showapi_res_code"].int ?? -1
        self.resError = json["showapi_res_error"].string ?? ""
        
        if self.list.count > 200 {
            self.list = [TextJoke]()
        }
        if let list = json["showapi_res_body"]["list"].array {
            for item in list {
                guard let title = item["title"].string,
                    let content = item["content"].string,
                    let poster = item["poster"].string,
                    let url = item["url"].string else {
                    continue
                }
                print("poster:\(poster)")
                print("url:\(url)")
                self.list.append(TextJoke(title: title, content: content, poster: poster, url: url))
            }
        }
    }
    
    func clear() {
        list = [TextJoke]()
    }
}


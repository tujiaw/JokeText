//
//  ExtensionNSDate.swift
//  JokeText
//
//  Created by tutujiaw on 15/11/12.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import Foundation

extension NSDate {
    static func currentDate(dateFormat: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = NSLocale.currentLocale()
        return dateFormatter.stringFromDate(NSDate())

    }
}
//
//  MyNews.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/30.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class MyNews: NSObject {
    
    var newsPicName:String!
    var newsTitle:String!
    var newsContent:String!
    var newsFollowUp:String!
    
    init(newsPicName:String,newsTitle:String,newsContent:String,newsFollowUp:String ) {
        self.newsPicName = newsPicName
        self.newsTitle = newsTitle
        self.newsContent = newsContent
        self.newsFollowUp = newsFollowUp
    }
}

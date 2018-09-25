//
//  ApproveData.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/9/13.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class ApproveData: NSObject {
    var index : String = ""
    var current : String = ""
    var name : String = ""
//    var object : String = ""
    var defaultObject:[String:String] = [:]
    var changeObject:[String:String] = [:]
    var objectQty : String = ""
    var jumpStep : [String] = []
    
    init(index:String,current:String,name:String,defaultObject:[String:String],changeObject:[String:String],objectQty:String,jumpStep:[String]) {
            self.index = index
            self.current = current
            self.name = name
//            self.object = object
            self.defaultObject = defaultObject
            self.changeObject = changeObject
            self.objectQty = objectQty
            self.jumpStep = jumpStep
        }
    

    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

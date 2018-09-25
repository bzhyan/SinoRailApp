//
//  Object.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/9/20.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class Object: NSObject {
    var name : String
    var value : String
    var isSelected : Bool
    
    
    init(name:String,value:String,isSelected:Bool){
        self.name = name
        self.value = value
        self.isSelected = isSelected
    }
}

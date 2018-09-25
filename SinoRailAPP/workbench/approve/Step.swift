//
//  Step.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/9/19.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class Step: NSObject {
    var name : String = ""
    var value : String = ""
    var isSelected : Bool = false
    init(name:String,value:String,isSelected:Bool){
        self.name = name
        self.value = value
        self.isSelected = isSelected
    }
    
}

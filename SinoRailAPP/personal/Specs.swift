//
//  Specs.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/26.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit
//
//  Specs.swift
//  FacebookMe
//
//  Copyright © 2017 Yi Gu. All rights reserved.
//

import UIKit

public struct Specs {
    public struct Color {
        public let tint = UIColor.white
        public let red = UIColor.red
        public let white = UIColor.white
        public let black = UIColor.black
        public let gray = UIColor.lightGray
    }
    
    public struct FontSize {
        public let tiny: CGFloat = 10
        public let small: CGFloat = 12
        public let regular: CGFloat = 14
        public let large: CGFloat = 16
    }
    
    public struct Font {
        private static let regularName = "Helvetica Neue"
        private static let boldName = "Helvetica Neue Bold"
        public let tiny = UIFont(name: regularName, size: Specs.fontSize.tiny)
        public let small = UIFont(name: regularName, size: Specs.fontSize.small)
        public let regular = UIFont(name: regularName, size: Specs.fontSize.regular)
        public let large = UIFont(name: regularName, size: Specs.fontSize.large)
        public let smallBold = UIFont(name: boldName, size: Specs.fontSize.small)
        public let regularBold = UIFont(name: boldName, size: Specs.fontSize.regular)
        public let largeBold = UIFont(name: boldName, size: Specs.fontSize.large)
    }
    
    //设置图片名称
    public struct ImageName {
        public let friends = "工作圈"
        public let events = "检查更新"
        public let groups = "文件夹"
        public let education = "home_tabbar_32x32_"
        public let townHall = "home_tabbar_32x32_"
        public let instantGames = "home_tabbar_32x32_"
        public let settings = "设置"
        public let privacyShortcuts = "关于"
        public let helpSupport = "home_tabbar_32x32_"
        public let placeholder = "home_tabbar_32x32_"
    }
    
    public static var color: Color {
        return Color()
    }
    
    public static var fontSize: FontSize {
        return FontSize()
    }
    
    public static var font: Font {
        return Font()
    }
    
    public static var imageName: ImageName {
        return ImageName()
    }
}

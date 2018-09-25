//
//  TableKeys.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/26.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//


import Foundation

public struct TableKeys {
    static let Section = "section"
    static let Rows = "rows"
    static let ImageName = "imageName"
    static let Title = "title"
    static let SubTitle = "subTitle"
    static let seeMore = "See More..."
    static let addFavorites = "Add Favorites..."
    static let logout = "退出登录"
    
    static func populate(withUser user: FBMeUser) -> [[String: Any]] {
        return [
            [
                TableKeys.Rows: [
                    [TableKeys.ImageName: user.avatarName, TableKeys.Title: user.name, TableKeys.SubTitle: "账号：zhangshan"]
                ]
            ],
            [
                TableKeys.Rows: [
                    [TableKeys.ImageName: Specs.imageName.friends, TableKeys.Title: "工作圈"],
                    [TableKeys.ImageName: Specs.imageName.events, TableKeys.Title: "检查更新"],
                    [TableKeys.ImageName: Specs.imageName.groups, TableKeys.Title: "文件夹"],
                    //[TableKeys.ImageName: Specs.imageName.education, TableKeys.Title: user.education],
                    //[TableKeys.ImageName: Specs.imageName.townHall, TableKeys.Title: "Town Hall"],
                    //[TableKeys.ImageName: Specs.imageName.instantGames, TableKeys.Title: "Instant Games"],
                    //[TableKeys.Title: TableKeys.seeMore]
                ]
            ],
            [
                TableKeys.Rows: [
                    [TableKeys.ImageName: Specs.imageName.settings, TableKeys.Title: "设置"],
                    [TableKeys.ImageName: Specs.imageName.privacyShortcuts, TableKeys.Title: "关于协同办公"],
                    //[TableKeys.ImageName: Specs.imageName.helpSupport, TableKeys.Title: "Help and Support"]
                ]
            ],
            [
                TableKeys.Rows: [
                    [TableKeys.Title: TableKeys.logout]
                ]
            ]
        ]
    }
}



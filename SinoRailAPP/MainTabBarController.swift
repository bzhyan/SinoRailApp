//
//  MainTabViewController.swift
//  hangge_592
//
//  Created by hangge on 2017/3/15.
//  Copyright © 2017年 hangge. All rights reserved.
//

import UIKit

class MainTabBarController:UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //一共包含了两个视图
        let message = MyTableViewController();
        message.title="消息"
        let addressBook = AddressBookCompanyVC();
        addressBook.title = "通讯录"
        let workbench = CustomCollectionViewVC()
        workbench.title = "工作台"
        let gateway = GatewayViewController();
        gateway.title = "门户"
        let personal = PersonalViewController()
        personal.title = "用户"
        
        //分别声明两个视图控制器
        let messagePage = UINavigationController(rootViewController:message)
        messagePage.tabBarItem.image = UIImage(named:"message")
        //定义tab按钮添加个badge小红点值
        messagePage.tabBarItem.badgeValue = "6"
        
        let addressBookPage = UINavigationController(rootViewController:addressBook)
        addressBookPage.tabBarItem.image = UIImage(named:"addressBook")
        
        
        let gatewayPage = UINavigationController(rootViewController:gateway)
        gatewayPage.tabBarItem.image = UIImage(named:"gateway")
        
        
        let workbenchPage = UINavigationController(rootViewController: workbench)
        workbenchPage.tabBarItem.image = UIImage(named:"workbench")
        
        let personalPage = UINavigationController(rootViewController: personal)
        personalPage.tabBarItem.image = UIImage(named:"personal")
        self.viewControllers = [messagePage,addressBookPage,gatewayPage,workbenchPage,personalPage]
        //默认选中的是消息视图
        self.selectedIndex = 0
    }
}

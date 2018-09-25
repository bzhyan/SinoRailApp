//
//  MyNewsDetailedViewController.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/30.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//新闻明细页面

import UIKit

class MyNewsDetailedViewController: UIViewController {

    let lable=UILabel(frame: CGRect(x: 10, y: 10, width: KScreenWidth, height:150))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(lable)
        self.view.backgroundColor=UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  BaseViewController.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/22.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createRightBarBtnItem(icon: UIImage, method: Selector ) {
        // 设置导航栏右侧按钮
        let menuBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        menuBtn.addTarget(self, action: method, for: .touchUpInside)
        menuBtn.setImage(icon, for: .normal)
        let rightBtn = UIBarButtonItem(customView: menuBtn)
        
//        self.addFixedSpace(with: rightBtn, direction: .right)
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

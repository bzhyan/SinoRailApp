//
//  GatewayViewController.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/20.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class GatewayViewController: UIViewController{

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.yellow
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//

 
    var exmapleIndex = 0
    var slideMenu:CKSlideMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white 
        //加载数据
         example()
        
    }
    
    func example()  {
        //let titles = ["新闻","集团公告","信息简报","集团总部","集团在京","工会天地"]
        let titles = ["新闻","集团公告","信息简报","集团总部","集团在京","工会天地"]
        var arr:Array<UIViewController> = []
        for i in 0 ..< titles.count {
            switch titles[i] {
            case "新闻":
                let vc = NewsViewController()
                self.addChildViewController(vc)
                arr.append(vc)
            case "集团公告":
                let vc = NoticeViewController()
                self.addChildViewController(vc)
                arr.append(vc)
            case "信息简报":
                let vc = InformationTableViewController()
                self.addChildViewController(vc)
                arr.append(vc)
            case "集团总部":
                let vc = GroupTableViewController()
                self.addChildViewController(vc)
                arr.append(vc)
            case "集团在京":
                let vc = GroupInTableViewController()
                self.addChildViewController(vc)
                arr.append(vc)
            case "工会天地":
                let vc = UnionTableViewController()
                self.addChildViewController(vc)
                arr.append(vc)
            default:
                let vc = GatewayViewController()
                self.addChildViewController(vc)
                arr.append(vc)
            }
            
        }
        slideMenu = CKSlideMenu(frame: CGRect(x:0,y:64,width:view.frame.width,height:40), titles:titles, childControllers:arr)
        
        slideMenu?.titleStyle = .gradient
        slideMenu?.indicatorStyle = .followText
        slideMenu?.bottomPadding = 0
        view.addSubview(slideMenu!)
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

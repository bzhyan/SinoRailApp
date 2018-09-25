//
//  NewsViewController.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/30.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    
    let newsReuseIdentifier = "MynewsCell"
    
    //定义数组存储数据模型news对象
    var newsArray:[MyNews] = Array()
    
    ////拉刷新控制器
    var MyrefreshControl=UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //调用制造数据的方法（放在最前面）
        self.creatData()
      
        self.title = "消息"
        //注册MynewsCell
        self.tableView.register(MyNewsCell.self, forCellReuseIdentifier: newsReuseIdentifier)
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        footView.backgroundColor = UIColor.white
        tableView.tableFooterView = footView
        
        //初始化刷新
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(creatData),
                                       for: .valueChanged)
        self.refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        //creatData()
    }
    //制造数据
    @objc func creatData(){
        
//        for i in 0...6{
//
//            let new = MyNews(newsPicName: "news101", newsTitle: "集团召开2018年度经营责任书签约暨经营工作座谈会\(i)", newsContent: "发布人：明霞   2018-08-18", newsFollowUp: "27万人跟帖")
//
//            //添加到数组
//            newsArray.append(new)
//        }
        //print(newsArray)
        //移除老数据
        self.newsArray.removeAll()
        let new1 = MyNews(newsPicName: "news101", newsTitle: "集团召开2018年度经营责任书签约暨经营工作座谈会", newsContent: "发布人：明霞   2018-08-18", newsFollowUp: "27万人跟帖")
        //添加到数组
        newsArray.append(new1)
        
        let new2 = MyNews(newsPicName: "news101", newsTitle: "SAP ERP 系统配合国家增值税税率调整工作圆满完成", newsContent: "发布人：余淼   2018-05-20", newsFollowUp: "27万人跟帖")
        //添加到数组
        newsArray.append(new2)
        
        let new3 = MyNews(newsPicName: "news103", newsTitle: "走进铁路 认识铁路 创先争优促发展", newsContent: "发布人：余淼   2018-07-20", newsFollowUp: "27万人跟帖")
        //添加到数组
        newsArray.append(new3)
        
        let new4 = MyNews(newsPicName: "news104", newsTitle: "集团工会组织开展“欢乐女职工，巾帼展风采”“三八”节主题竞赛活动", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //添加到数组
        newsArray.append(new4)
        
        let new5 = MyNews(newsPicName: "news105", newsTitle: "集团团总支组织开展五四青年团日活动", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //添加到数组
        newsArray.append(new5)
        
        let new6 = MyNews(newsPicName: "news106", newsTitle: "中铁信技术服务公司荣获ITSS运维服务能力成熟度二级资质", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //添加到数组
        newsArray.append(new6)
        
        let new7 = MyNews(newsPicName: "news105", newsTitle: "恪尽职守、任劳任怨----践行新时期铁路精神", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //添加到数组
        newsArray.append(new7)
        
        let new8 = MyNews(newsPicName: "news105", newsTitle: "集中心团委举办读书分享会", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //添加到数组
        newsArray.append(new8)
        
        let new9 = MyNews(newsPicName: "news105", newsTitle: "集团SAP-ERP升级实施项目顺利通过验收", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //添加到数组
        newsArray.append(new9)
        
        let new10 = MyNews(newsPicName: "news105", newsTitle: "感受五年成就 喜迎十九大—集团第二联合党支部开展主题党日系列活动", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //添加到数组
        newsArray.append(new10)
        
        let new11 = MyNews(newsPicName: "news105", newsTitle: "集团团总支组织青年开展“同心协力，共创未来”团建活动", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //添加到数组
        newsArray.append(new11)
        
        let new12 = MyNews(newsPicName: "news105", newsTitle: "中心召开集团SAP-ERP升级实施试点项目总结汇报会", newsContent: "发布人：余淼   2018-05-10", newsFollowUp: "27万人跟帖")
        //添加到数组
        newsArray.append(new12)
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsReuseIdentifier, for: indexPath) as! MyNewsCell
        print(indexPath)
        //取出数组中对应位置的news对象
        let news = newsArray[indexPath.row]
        cell.newsPic.image = UIImage(named:news.newsPicName)
        cell.newsTitleLabel.text = news.newsTitle
        cell.newsContentLabel.text = news.newsContent
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("333")
        return 70
    }

    //点击事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        //实例化一个界面
        let loginView = MyNewsDetailedViewController()
        //MyNewsDetailedViewController.title=newsArray[indexPath.section][1][indexPath.indexr
        loginView.lable.text = newsArray[indexPath.row].newsTitle
        
         print(indexPath)
        print(indexPath.section)
        //跳转
        self.navigationController?.pushViewController(loginView, animated: true)
    }
}

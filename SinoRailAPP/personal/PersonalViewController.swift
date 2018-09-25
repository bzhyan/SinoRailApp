//
//  PersonalViewController.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/20.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//用户

import UIKit

class PersonalViewController: FBMeBaseViewController {


    typealias RowModel = [String: String]
    
    fileprivate var user: FBMeUser {
        get {
            return FBMeUser(name: "张三", education: "CMU2")
        }
    }
    
    fileprivate var tableViewDataSource: [[String: Any]] {
        get {
            return TableKeys.populate(withUser: user)
        }
    }
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.register(FBMeBaseCell.self, forCellReuseIdentifier: FBMeBaseCell.identifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        title = "用户"
        navigationController?.navigationBar.barTintColor = Specs.color.tint
        //var collectionView = UICollectionView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        // Set layout for tableView.
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tableView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["tableView": tableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tableView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["tableView": tableView]))
    }
    
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("11111111")
        let modelForRow = rowModel(at: indexPath)
       // var cell = UITableViewCell()
        
        let title = modelForRow[TableKeys.Title]
        switch title {
        case "工作圈":
           print(title)
        case "检查更新":
            print(title)
        case "文件夹":
            print(title)
        case "设置":
            print(title)
        case "关于协同平台":
            print(title)
        case "退出登录":
            //弹出退出提示
            let alertVC = UIAlertController(title: "", message: "退出后，你将不再收到消息", preferredStyle: UIAlertControllerStyle.actionSheet)
            let acSure = UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
                print("点击确认退出")
                //登录状态写入缓存,true:登录成功，false：第一次登录或者退出APP
                UserDefaults.standard.setValue("false", forKey: "loginState")
                //实例化一个界面
                let loginView = LoginViewController()
                //跳转
                //self.navigationController?.pushViewController(loginView, animated: true)
                 self.view.window?.rootViewController=LoginViewController()
            }
            let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
                print("点击取消退出")
            }
            alertVC.addAction(acSure)
            alertVC.addAction(acCancel)
            self.present(alertVC, animated: true, completion: nil)
        default:
           print(title)
        }
    }
    
    fileprivate func rows(at section: Int) -> [Any] {
        return tableViewDataSource[section][TableKeys.Rows] as! [Any]
    }
    
    fileprivate func title(at section: Int) -> String? {
        return tableViewDataSource[section][TableKeys.Section] as? String
    }
    
    fileprivate func rowModel(at indexPath: IndexPath) -> RowModel {
        return rows(at: indexPath.section)[indexPath.row] as! RowModel
    }
}

extension PersonalViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows(at: section).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return title(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let modelForRow = rowModel(at: indexPath)
        var cell = UITableViewCell()
        
        guard let title = modelForRow[TableKeys.Title] else {
            return cell
        }
        
        if title == user.name {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: nil)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: FBMeBaseCell.identifier, for: indexPath)
        }
        
        cell.textLabel?.text = title
        
        if let imageName = modelForRow[TableKeys.ImageName] {
            cell.imageView?.image = UIImage(named: imageName)
        } else if title != TableKeys.logout {
            cell.imageView?.image = UIImage(named: Specs.imageName.placeholder)
        }
        
        if title == user.name {
            cell.detailTextLabel?.text = modelForRow[TableKeys.SubTitle]
        }
        
        return cell
    }
}

extension PersonalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let modelForRow = rowModel(at: indexPath)
        
        guard let title = modelForRow[TableKeys.Title] else {
            return 0.0
        }
        
        if title == user.name {
            return 64.0
        } else {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let modelForRow = rowModel(at: indexPath)
        
        guard let title = modelForRow[TableKeys.Title] else {
            return
        }
        
        if title == TableKeys.seeMore || title == TableKeys.addFavorites {
            cell.textLabel?.textColor = Specs.color.tint
            cell.accessoryType = .none
        } else if title == TableKeys.logout {
            cell.textLabel?.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            cell.textLabel?.textColor = Specs.color.red
            cell.textLabel?.textAlignment = .center
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .disclosureIndicator
        }
    }
}

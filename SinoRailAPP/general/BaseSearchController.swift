//
//  FCBSearchController.swift
//  WeChat
//
//  Created by Vancat on 2017/10/7.
//  Copyright © 2017年 Vancat. All rights reserved.
//

import UIKit

fileprivate let searchTintColor = RGBA(r: 0.12, g: 0.74, b: 0.13, a: 1.00)

class BaseSearchController: UISearchController {
    
    
    //懒加载
    lazy var hasFindCancelBtn: Bool = {
        return false
    }()
    var ctrls:[String] = ["Label","Button1","Button2","Switch"]
    // 搜索匹配的结果，Table View使用这个数组作为datasource
    var ctrlsel:[String] = []
    lazy var link: CADisplayLink = {
        CADisplayLink(target: self, selector: #selector(findCancel))
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        searchBar.barTintColor = sectionColor
        
        //搜索框
        searchBar.barStyle = .default
        searchBar.tintColor = searchTintColor
        
        //去除横线
        searchBar.setBackgroundImage(UIImage(named:"welcome"), for: .any, barMetrics: .default)
      
        //右侧语音
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(named:"phone"), for: .bookmark, state: .normal)
        
        searchBar.delegate = self
        
    }
    
    @objc func findCancel() {
        
        let btn = searchBar.value(forKey: "_cancelButton") as AnyObject
        if btn.isKind(of: NSClassFromString("UINavigationButton")!) {
            FCBLog("就是它")
            link.invalidate()
            link.remove(from: RunLoop.current, forMode: .commonModes)
            hasFindCancelBtn = true
            let cancel = btn as! UIButton
            cancel.setTitleColor(searchTintColor, for: .normal)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //设置状态栏的颜色
        UIApplication.shared.statusBarStyle = .default
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension BaseSearchController: UISearchBarDelegate {
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        FCBLog("点击了语音按钮")
    }
    // 搜索代理UISearchBarDelegate方法，每次改变搜索内容时都会调用
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        // 没有搜索内容时显示全部组件
//        if searchText == "" {
//            self.ctrlsel = self.ctrls
//        }
//        else { // 匹配用户输入内容的前缀(不区分大小写)
//            self.ctrlsel = []
//            for ctrl in self.ctrls {
//                if ctrl.lowercased().hasPrefix(searchText.lowercased()) {
//                    self.ctrlsel.append(ctrl)
//                }
//            }
//        }
//        // 刷新Table View显示
//        self.tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if !hasFindCancelBtn {
            link.add(to: RunLoop.current, forMode: .commonModes)
        }
    }
}
func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor (red: r, green: g, blue: b, alpha: a)
}
//颜色属性
func normalRGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
//分割线
let splitLineColor = RGBA(r: 0.97, g: 0.97, b: 0.97, a: 1.00)
// 常规背景颜色
let commonBgColor = RGBA(r: 0.92, g: 0.92, b: 0.92, a: 1.00)
let sectionColor = RGBA(r: 0.94, g: 0.94, b: 0.96, a: 1.00)
// 导航栏背景颜色
let navBarBgColor = normalRGBA(r: 20, g: 20, b: 20, a: 0.9)

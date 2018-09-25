//
//  ObjectSelectVC.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/9/20.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class ObjectSelectVC: UITableViewController {
    var objects : [String:String] = [:]
    var data : [Object] = []
    var obj : Object?
    var selectedObject : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        manageDictionary()
        self.view.backgroundColor = UIColor.white
        tableView.register(ObjectCell.self, forCellReuseIdentifier: "objectCell")
        let footer = UIView(frame:CGRect(x:0,y:0,width:0,height:0))
        tableView.tableFooterView = footer
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func manageDictionary(){
        for item in objects{
            if(item.value == selectedObject){
                obj = Object(name:item.key,value:item.value,isSelected:true)
            }else{
                obj = Object(name:item.key,value:item.value,isSelected:false)
            }
            
            data.append(obj!)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "objectCell") as? ObjectCell
        cell?.displayLab?.text = data[indexPath.row].name
        cell?.choiceBtn?.isSelected = data[indexPath.row].isSelected
        return cell!
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: NSNotification.Name("objectData"), object: self, userInfo: ["name":data[indexPath.row].name,"value":data[indexPath.row].value])
        
        for obj in data{
            obj.isSelected = false
        }
        data[indexPath.row].isSelected = true
        self.tableView.reloadData()
    }



}

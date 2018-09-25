//
//  AddressBookTableViewController.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/21.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class AddressBookTableViewController: UIViewController {
    var ItemId : String = ""
    var name : String = ""
    var company : String = ""
    var duty : String = ""
    var department : String = ""
    var mobile : String = ""
    var phone : String = ""
    var ext : String = ""
    
    
    let newsReuseIdentifier = "cell"
    
    var nameLabel : UILabel?
    var dutyLabel : UILabel?
    var departmentLabel : UILabel?
    var companyLabel : UILabel?
    var mobileLabel : UILabel?
    var phoneLabel : UILabel?
    var extLabel : UILabel?
    //定义数组存储数据模型news对象
    var addressBookArray:[AddressBook] = Array()
//    let tableFooterView : UITableViewHeaderFooterView
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusbarHeight = UIApplication.shared.statusBarFrame.height //获取statusBar的高度
        var height = self.navigationController?.navigationBar.frame.size.height
        self.view.backgroundColor = UIColor.white
        nameLabel = UILabel(frame: CGRect(x: 15, y: 5+height!+statusbarHeight, width: KScreenWidth-30, height: 40))
        nameLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.3))
        nameLabel?.text = name
        self.view.addSubview(nameLabel!)
        
        var seperator1 = UILabel(frame: CGRect(x: 15, y: 45+height!+statusbarHeight, width: KScreenWidth-30, height: 0.5))
        seperator1.layer.backgroundColor = UIColor.black.cgColor
        self.view.addSubview(seperator1)
        dutyLabel = UILabel(frame: CGRect(x: 25, y: 46+height!+statusbarHeight, width: KScreenWidth-10, height: 40))
        dutyLabel?.text = "职务：\(duty)"
        self.view.addSubview(dutyLabel!)
 
        
        departmentLabel = UILabel(frame: CGRect(x: 25, y: 85+height!+statusbarHeight, width: KScreenWidth-10, height: 40))
        departmentLabel?.text = "部门：\(department)"
        self.view.addSubview(departmentLabel!)
        companyLabel = UILabel(frame: CGRect(x: 25, y: 125+height!+statusbarHeight, width: KScreenWidth-10, height: 40))
        companyLabel?.text = "公司：\(company)"
        self.view.addSubview(companyLabel!)
        mobileLabel = UILabel(frame: CGRect(x: 25, y: 165+height!+statusbarHeight, width: KScreenWidth-10, height: 40))
        mobileLabel?.text = "手机：\(mobile)"
        self.view.addSubview(mobileLabel!)
        phoneLabel = UILabel(frame: CGRect(x: 25, y: 205+height!+statusbarHeight, width: KScreenWidth-10, height: 40))
        phoneLabel?.text = "直线：\(phone)"
        self.view.addSubview(phoneLabel!)
        extLabel = UILabel(frame: CGRect(x: 25, y: 245+height!+statusbarHeight, width: KScreenWidth-10, height: 40))
        extLabel?.text = "分机：\(ext)"
        self.view.addSubview(extLabel!)
        let seperator2 = UILabel(frame: CGRect(x: 15, y: 45+height!+statusbarHeight, width: KScreenWidth-30, height: 0.5))
        seperator2.layer.backgroundColor = UIColor.black.cgColor
        let  callButton: UIButton = UIButton(type: .custom)
        callButton.frame = CGRect(x: KScreenWidth/20, y: 285+height!+statusbarHeight, width: 0.4*(KScreenWidth), height: 40)
        callButton.setImage(UIImage(named:"phone"),for:.normal)
        callButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        callButton.addTarget(self,action:#selector(call), for: .touchUpInside)
        self.view.addSubview(callButton)
        	
        let  messageButton: UIButton = UIButton(type: .custom)
        messageButton.frame = CGRect(x: KScreenWidth*0.55, y: 285+height!+statusbarHeight, width: 0.4*(KScreenWidth), height: 40)
        messageButton.setImage(UIImage(named:"message"),for:.normal)
        messageButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        messageButton.addTarget(self,action:#selector(sendMessage), for: .touchUpInside)
        self.view.addSubview(messageButton)
    }
    @objc func call(){
        let url1 = NSURL(string: "tel://\(mobile)")
        UIApplication.shared.openURL(url1! as URL)
    }
    @objc func sendMessage(){
        let url1 = NSURL(string: "sms://\(mobile)")
        UIApplication.shared.openURL(url1! as URL)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

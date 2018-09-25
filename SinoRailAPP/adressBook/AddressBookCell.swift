//
//  AddressBookCell.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/21.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class AddressBookCell: UITableViewCell {
    //姓名
    var name:UILabel!
    //标题
    var company:UILabel!
    //新闻内容
    var department:UILabel!
    //电话图标
    var picture:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupViews(){
        

        
        //姓名
        name = UILabel(frame: CGRect(x: 5, y: 5, width: 80, height:30))
        name.backgroundColor = UIColor.white
        name.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.2))
        self.contentView.addSubview(name)
        
        //公司
        company = UILabel(frame: CGRect(x: 85, y: 5, width: 150, height: 30))
        company.backgroundColor = UIColor.white
        //能换行
        company.numberOfLines = 2
        company.textColor = UIColor.lightGray
        self.contentView.addSubview(company)
        
        //部门
        department = UILabel(frame: CGRect(x: 235, y: 5, width: KScreenWidth-305, height: 30))
        department.textAlignment = .center
        department.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.contentView.addSubview(department)
        //电话图标
        picture = UIImageView(frame: CGRect(x: KScreenWidth-40, y: 5, width: 30, height: 30))
        picture.backgroundColor = UIColor.white
        self.contentView.addSubview(picture)
        //边框的宽度
//        department.layer.borderWidth = 1
        //边框的颜色
//        followUpLabel.layer.borderColor = UIColor.lightGray.cgColor
//        followUpLabel.layer.cornerRadius = 15
        //followUpLabel.backgroundColor = #colorLiteral(red: 0.9605649373, green: 0.7355437001, blue: 0.7516453615, alpha: 1)
//        self.contentView.addSubview(followUpLabel)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //调用布局的方法
        self.setupViews()
        self.setSelected(false, animated: true)
        self.preservesSuperviewLayoutMargins = false

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

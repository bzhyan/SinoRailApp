//
//  ObjectCell.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/9/20.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class ObjectCell: UITableViewCell {
    var displayLab : UILabel?
    var choiceBtn: UIButton?
    var pic : UIImage?
    func setUp(){
        self.choiceBtn = {
            let choiceBtn = UIButton(type: UIButtonType.custom)
            choiceBtn.bounds = CGRect(x:0, y:0, width:30, height:30)
            choiceBtn.center = CGPoint(x:KScreenWidth-20, y:22)
            choiceBtn.setBackgroundImage(UIImage(named: ""), for: UIControlState.normal)
            choiceBtn.setBackgroundImage(UIImage(named: "checked"), for: UIControlState.selected)
            //            choiceBtn.addTarget(self, action: #selector(respondsToButton), for: UIControlEvents.touchUpInside)
            return choiceBtn
        }()
        self.contentView.addSubview(self.choiceBtn!)
        
        self.displayLab = {
            let displayLab = UILabel()
            displayLab.bounds = CGRect(x:0, y:0, width:100, height:30)
            displayLab.center = CGPoint(x:((self.choiceBtn?.frame.width)!)+40, y:(self.choiceBtn!.frame.midY))
            displayLab.textAlignment = NSTextAlignment.left
            return displayLab
        }()
        self.contentView.addSubview(self.displayLab!)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //调用布局的方法
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @objc func respondsToButton(){
        choiceBtn?.isSelected = !(choiceBtn?.isSelected)!
    }
}

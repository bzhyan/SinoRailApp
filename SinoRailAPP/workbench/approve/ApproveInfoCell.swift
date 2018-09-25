//
//  ApproveInfoCell.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/9/7.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

class ApproveInfoCell: UITableViewCell {
    var stepLabel : UILabel = UILabel()
    var titleLabel : UILabel = UILabel()
    var ownerLabel : UILabel = UILabel()
    var arriveLabel : UILabel = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupViews(){

        //当前步骤
        stepLabel = UILabel(frame: CGRect(x: 5, y: 5, width: KScreenWidth - 10, height: 20))
        stepLabel.backgroundColor = UIColor.white
        stepLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.1))
        stepLabel.textColor = UIColor.gray
        self.contentView.addSubview(stepLabel)
        //标题
        titleLabel = UILabel(frame: CGRect(x: 5, y: 30, width: KScreenWidth - 10, height: 25))
        titleLabel.backgroundColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.3))
        self.contentView.addSubview(titleLabel)
        //发起人
        ownerLabel = UILabel(frame: CGRect(x: 5, y: 60, width: KScreenWidth/2-5, height: 20))
        ownerLabel.backgroundColor = UIColor.white
        ownerLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.1))
        ownerLabel.textColor = UIColor.gray
        self.contentView.addSubview(ownerLabel)
        //送达时间
        arriveLabel = UILabel(frame: CGRect(x: KScreenWidth/2, y: 60, width: KScreenWidth/2-5, height: 20))
        arriveLabel.backgroundColor = UIColor.white
        arriveLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.1))
        arriveLabel.textColor = UIColor.gray
        arriveLabel.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(arriveLabel)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //调用布局的方法
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

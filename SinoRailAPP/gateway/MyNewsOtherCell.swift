//
//  MyNewsOtherCell.swift
//  SinoRailAPP
//
//  Created by ybz on 2018/8/30.
//  Copyright © 2018年 SinoRailAPP. All rights reserved.
//

import UIKit

 
class MyNewsOtherCell: UITableViewCell {
    //新闻图片
    var newsPic:UIImageView!
    //标题
    var newsTitleLabel:UILabel!
    //新闻内容
    var newsContentLabel:UILabel!
    //跟帖
    var followUpLabel:UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //调用布局的方法
        self.setupViews()
    }
    
    func setupViews(){
        
        //新闻图片
        newsPic = UIImageView(frame: CGRect(x: 10, y: 5, width: 60, height: 60))
        newsPic.backgroundColor = UIColor.white
        //newsPic.layer.cornerRadius=newsPic.frame.size.width/2;//裁成圆角
        //newsPic.layer.masksToBounds=true//隐藏裁剪掉的部分
        newsPic.layer.borderWidth = 0;//边框宽度
        
        //self.contentView.addSubview(newsPic)
        
        //标题
        newsTitleLabel = UILabel(frame: CGRect(x: 10, y: 5, width: MyKScreenWidth-10, height: 25)) 
        newsTitleLabel.backgroundColor = UIColor.white
        newsTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.3))
        //newsTitleLabel.numberOfLines=0
        //newsTitleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        self.contentView.addSubview(newsTitleLabel)
        
        //新闻内容
        newsContentLabel = UILabel(frame: CGRect(x: 10, y: 35, width: MyKScreenWidth-10, height: 25))
        newsContentLabel.backgroundColor = UIColor.white
        newsContentLabel.font = UIFont.systemFont(ofSize: 16)
        //能换行
        newsContentLabel.numberOfLines = 2
        newsContentLabel.textColor = UIColor.lightGray
        self.contentView.addSubview(newsContentLabel)
        
        //跟帖
        //        followUpLabel = UILabel(frame: CGRect(x: KScreenWidth-120, y: 70, width: 115, height: 30))
        //        followUpLabel.textAlignment = .center
        //        followUpLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //        //边框的宽度
        //        followUpLabel.layer.borderWidth = 1
        //        //边框的颜色
        //        followUpLabel.layer.borderColor = UIColor.lightGray.cgColor
        //        followUpLabel.layer.cornerRadius = 15
        //followUpLabel.backgroundColor = #colorLiteral(red: 0.9605649373, green: 0.7355437001, blue: 0.7516453615, alpha: 1)
        //        self.contentView.addSubview(followUpLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
}
}

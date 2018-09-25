//
//  CoutomeCollectionViewCell.swift
//  TableViewText
//
//  Created by thinkjoy on 2017/7/11.
//  Copyright © 2017年 杜瑞胜. All rights reserved.
//

import UIKit


/// 代理
@objc protocol CoutomeCollectionViewCellDelegate : NSObjectProtocol{
    /// 可选代理
    @objc optional func coutomeCollectionViewCell(_ cell:CoutomeCollectionViewCell,buttType:String)
}

class CoutomeCollectionViewCell: UICollectionViewCell {

    
    /// 声明代理属性
    weak var delegate:CoutomeCollectionViewCellDelegate?
    //xib上的控件
    @IBOutlet weak private var itemImgV: UIImageView!
    @IBOutlet weak private var itemLab: UILabel!

    @IBOutlet weak private var ButtView: UIView!
    
    @IBOutlet weak private var TipLabel: UILabel!
    

    /// cell的itemMD属性Set方法
    var itemMD:Items?{
        didSet{
            //填充对应的数据
            self.itemLab.text   =   self.itemMD?.itemTitle
            self.itemImgV.image =   UIImage.init(named: (self.itemMD?.imageName)!)
            self.ButtView.backgroundColor = UIColor.red
            print(itemMD?.itemCount)
            //如果条数是0，隐藏，否则正常显示
            if(((self.itemMD?.itemCount!)?.caseInsensitiveCompare("0"))!.rawValue != 0){
                ButtView.backgroundColor = UIColor.red
                ButtView.layer.cornerRadius=ButtView.frame.size.width/2
                //            TipLabel = UILabel(frame: CGRect(x: 45, y: 10, width: 15, height: 15))
                TipLabel.backgroundColor = UIColor.clear
                TipLabel.font=UIFont.boldSystemFont(ofSize:12)
                TipLabel.text = self.itemMD?.itemCount as! String
                TipLabel.textColor = UIColor.white
                TipLabel.textAlignment = NSTextAlignment.center
            }else{
                ButtView.backgroundColor = UIColor.clear
                TipLabel.backgroundColor = UIColor.clear
            }

//            self.addSubview(TipLabel)
        }
    }
    
    /// 类方法，获取单元格
    ///
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - indexPath: IndexPath
    /// - Returns: CoutomeCollectionViewCell
    class func getCoutomeCollectionViewCell(collectionView:UICollectionView,indexPath:IndexPath) ->  CoutomeCollectionViewCell{
        let cell:CoutomeCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: CoutomeCollectionViewCell.className, for: indexPath) as! CoutomeCollectionViewCell)
        
        cell.contentView.backgroundColor   =   UIColor.white
        
        return  cell
    }
    
}

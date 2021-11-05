//
//  CollectionViewCell.swift
//  BGSoftTZ
//
//  Created by pro2017 on 03/11/2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Функции для регистрации nib
    static func registerNib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
    
    static func cellIdentifier() -> String {
        return "CollectionViewCell"
    }
    
    
    // Настраиваем дизайн ячейки
    func setupCellDesign() {
        let cornerRadius: CGFloat = 25
        
        self.imageView.layer.cornerRadius = cornerRadius
        self.layer.cornerRadius = cornerRadius
        
        // Создаем тень
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
        
        // Позволяет отобразить тень вокруг скругленных углов
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        
        // Следующие шаги позволяют быстрее редактировать тени
        self.layer.shouldRasterize  = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    // Присваиваем данные ячейке

}

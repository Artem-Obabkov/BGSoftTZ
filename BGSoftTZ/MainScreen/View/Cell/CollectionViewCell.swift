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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // Функции для регистрации nib
    static func registerNib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
    
    static func cellIdentifier() -> String {
        return "CollectionViewCell"
    }
    
    
    // Настраиваем дизайн ячейки
    func setupCellDesign(isPressed: Bool) {
        
        if isPressed {
            
            self.layer.shadowColor = UIColor.clear.cgColor
            self.layer.shadowOpacity = 0
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowRadius = 0
            
            return
        }
        
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
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    // Загрузка данных
    func downloadImage(for user: User, at indexPath: IndexPath, completion: @escaping (User, Int) -> () ) {
        
        // Создаем пользователя, которого будем возвращать обратно
        let currentUser = user
        
        // Меняем значение загрузки пользователя
        currentUser.isAlreadyLoaded = true
        
        // Определяем URL
        guard
            let imageUrl = currentUser.imageUrl
        else { return }
        
        MainNetworkManager.shared.downloadImage(with: imageUrl) { (data) in
            currentUser.imageData = data
            
            DispatchQueue.main.async {
                
                // Передаем значения обратно
                completion(currentUser, indexPath.row)
            }
        }
    }
    
    // Присваиваем данные ячейке
    func setupUser(with user: User) {
        
        // Проверяем данные
        guard
            let userName = user.userName
        else { return }
        
        // Присваиваем данные
        self.authorLabel.text = userName
        
        // Если данные о изображении есть, то присваиваем их и останавливаем индикатор в противном случае присваиваем UIImage()
        if let imageData = user.imageData {
            self.activityIndicator.stopAnimating()
            self.imageView.image = UIImage(data: imageData)
        } else {
            self.imageView.image = UIImage()
        }
        
    }
}

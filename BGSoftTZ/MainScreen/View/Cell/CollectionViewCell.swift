//
//  CollectionViewCell.swift
//  BGSoftTZ
//
//  Created by pro2017 on 03/11/2021.
//

import UIKit

// Используем делегирование, что бы передать данные
protocol CollectionViewCellDelegate {
    func getUrl(urlString: String, for indexPath: IndexPath)
}

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var checkUserProfile: UIButton!
    @IBOutlet weak var checkPhotoURL: UIButton!
    
    var indexPath: IndexPath?
    var user: User?
    var urlString: String?
    
    // Передаем данные с помощью делегированияя
    var delegate: CollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func checkUserProfileAction(_ sender: UIButton) {
        guard
            let indexPath = indexPath,
            let user = user,
            let userUrl = user.userUrl
        else { return }
        
        self.delegate?.getUrl(urlString: userUrl, for: indexPath)
        
    }
    
    @IBAction func checkPhotoUrlAction(_ sender: UIButton) {
        guard
            let indexPath = indexPath,
            let user = user,
            let photoUrl = user.photoUrl
        else { return }
        
        self.delegate?.getUrl(urlString: photoUrl, for: indexPath)
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
        
        checkUserProfile.layer.cornerRadius = 15
        checkPhotoURL.layer.cornerRadius = 15
        
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
    func setupUser(with user: User, for indexPath: IndexPath) {
        
        // Присваиваем данные пользователя
        self.user = user
        self.indexPath = indexPath
        
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

//
//  CollectionViewController.swift
//  BGSoftTZ
//
//  Created by pro2017 on 02/11/2021.
//

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Константы для настройки размера ячейки
    let itemSpacing: CGFloat = 25
    let edgeInsets = UIEdgeInsets(top: 40, left: 25, bottom: 40, right: 25)
    
    // Данные пользователей (как в JSON)
    var users = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Регистрируем ячейку
        collectionView.register(CollectionViewCell.registerNib(), forCellWithReuseIdentifier: CollectionViewCell.cellIdentifier())
        
        // Настраиваем CollectionView
        setupCollectionView()
        
        // Получаем данные
        MainNetworkManager.shared.getImages { [weak self] (response) in
            guard let response = response else { return }
            self?.users = response.users
            
            // Загружаем фотографии
            self?.showImages(from: response)
        }
    }
}

// MARK: - UICollectionViewDelegate UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellIdentifier(), for: indexPath) as! CollectionViewCell
        
        // Получаем пользователя
        let user = users[indexPath.row]
        
        // Настраиваем ячейку
        cell.setupCellDesign()
        cell.setupUser(with: user)
        
        
    
        return cell
    }
    
}

// MARK: - Setup Collection View

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: Collection View Cell Size
    
    // Настраиваем размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Вычисляем ширину ячейки
        let itemsPerRow: CGFloat = 1
        let paddingWidth: CGFloat = itemSpacing * (itemsPerRow + 1)
        let availabelWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availabelWidth / itemsPerRow
        
        // Вычисляем высоту ячейки
        let heightPerItem = collectionView.frame.height - (itemSpacing * 2)
        
        return CGSize(width: widthPerItem, height: heightPerItem )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return edgeInsets.left * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return edgeInsets.left * 2
    }
}


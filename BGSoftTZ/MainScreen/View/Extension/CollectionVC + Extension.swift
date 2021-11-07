//
//  CollectionVC + Extension.swift
//  BGSoftTZ
//
//  Created by pro2017 on 04/11/2021.
//

import Foundation
import UIKit



extension CollectionViewController {
    
    
    // MARK: Дизайн Collection View

    func setupCollectionView() {
        // Указываем направление скролинга
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        // Настраиваем CollecitonView
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
    }
    
    
    // Позволяет применить паралакс эффект
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = collectionView.contentOffset.x + collectionView.frame.width/2
        
        // Перебираем все существующие ячейки в CollectionView
        for cell in collectionView.visibleCells {
            
            // Определяем на сколько сдвинулась ячейка по модулю
            var offsetX = centerX - cell.center.x
            if offsetX < 0 {
                offsetX *= -1
            }
            
            // Применяяем множитель до изменения положения ячейки
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            
            // Если сдвиг был больше чем отступ от ячейки до боковой границы экрана, то применяем множитель
            if offsetX > edgeInsets.left {
                
                // Определяем процент сдвига. Множитель после view.bounds.width позволит определить продолжительность изменения размера ячейки
                let offsetPercentage = (offsetX - edgeInsets.left) / (view.bounds.width * 7)
                
                // Определяем новый множиетель
                var scaleX = 1 - offsetPercentage
                
                // Если множитель меньше, чем 0.8, то присваиваем значение 0.8
                if scaleX < 0.93 {
                    scaleX = 0.93
                }
                
                // Применяем новый множитель
                cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
            }
        }
    }
    
    // MARK: - Показ изображений по мере загрузки
    
    func showImages(from users: MainNeworkManagerResponse) {
        
        // Загружаем фотографии
        DispatchQueue.main.async {
            
            // Короче здесь образуется race condition и я не знаю как решить эту проблему, я потратил часа 4 пытаясь заставить это все работать как надо, но безуспешно. 
            for (index,user) in users.users.enumerated() {
                
                MainNetworkManager.shared.downloadImage(with: user.imageUrl!) { (data) in

                    // Присваиваем данные
                    user.imageData = data
                    self.users[index].imageData = user.imageData
                    
                    // Обновляем collectionView
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

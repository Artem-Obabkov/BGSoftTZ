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
}


// MARK: - Показ изображений по мере загрузки

extension CollectionViewController {
    
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
    

// MARK: - Gestures logic and design
    
extension CollectionViewController {
    
    func setupLongPressGesture() {
        
        // Создаем жест
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecogniser:)))
        
        // Натсраиваем жест
        longPressGesture.minimumPressDuration = 0.3
        longPressGesture.delegate = self
        
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    // Дизайн ячейки при нажатии
    
    func updateCellDesign(for cell: UICollectionViewCell, isPressed: Bool, indexPath: IndexPath) {
        
        guard let cell = cell as? CollectionViewCell else { return }
        
        // Проверяем нажата ли ячейка
        if isPressed {
            
            // Очищаем тени
            cell.layer.shadowColor = UIColor.clear.cgColor
            cell.layer.shadowOpacity = 0
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 0
            
        } else {
            
            // Убираем внутренние тени
            cell.contentView.removeAllShadows()
            
//            // Устанавливаем дизайн
//            let cornerRadius: CGFloat = 25
//
//            cell.imageView.layer.cornerRadius = cornerRadius
//            cell.layer.cornerRadius = cornerRadius
            
            // Создаем тень
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.8
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 5
            cell.layer.masksToBounds = false
            
            // Позволяет отобразить тень вокруг скругленных углов
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
            
            // Следующие шаги позволяют быстрее редактировать тени
            cell.layer.shouldRasterize  = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            
        }
    }
}


// MARK: - Alert Controller

extension CollectionViewController {
    
    func createAlert(with title: String, message: String?, indexPath: IndexPath) {
        
        // Создаем alert
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
        
        // Добавляем кнопки
        let cancelButton = UIAlertAction(title: "Отметна", style: .cancel) { action in
            
            // Отменить выделение
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) { [weak self] in
                self?.updateCellDesign(for: cell, isPressed: false, indexPath: indexPath)
            }
            
            cell.contentView.removeAllShadows()
            
            self.collectionView.performBatchUpdates {
                self.collectionView.reloadData()
            }
        }
        
        let deleteButton = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] action in
            
            // Удалить ячейку
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) { [weak self] in
                self?.updateCellDesign(for: cell, isPressed: false, indexPath: indexPath)
            }
            
            cell.contentView.removeAllShadows()
            
            // Удаляем ячейку
            self?.collectionView.performBatchUpdates {
                self?.users.remove(at: indexPath.row)
                self?.collectionView.deleteItems(at: [indexPath])
            }
        }
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true)
    }
}

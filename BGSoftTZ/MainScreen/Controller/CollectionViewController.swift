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
    
    // Определяет нажата ли ячейка
    private var shouldUnhilight = true
    
    // Данные пользователей (как в JSON)
    var users = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Регистрируем ячейку
        collectionView.register(CollectionViewCell.registerNib(), forCellWithReuseIdentifier: CollectionViewCell.cellIdentifier())
        
        // Настраиваем CollectionView
        setupCollectionView()
        setupLongPressGesture()
        createFlowLayout()
        
        // Получаем данные
        MainNetworkManager.shared.getImages { [weak self] (response) in
            guard let response = response else { return }
            self?.users = response.users
            self?.collectionView.reloadData()
            
            // Добавляем дополнительные значения для бесконечной прокрутки
            guard
                let lastUser = self?.users.last,
                let firstUser = self?.users.first
            else { return }
            
            self?.users.insert(lastUser, at: 0)
            self?.users.append(firstUser)
            
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: Infinitive Scrolling
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.scrollToItem(at: [0, 1], at: .left, animated: false)
    }
}

// MARK: - UICollectionViewDelegate UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
        
        //return Int.max
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellIdentifier(), for: indexPath) as! CollectionViewCell
        
        // Получаем пользователя
        let user = users[indexPath.row]
        //let user = users[indexPath.row % users.count]
        
        // Настраиваем ячейку
        cell.setupCellDesign(isPressed: user.isPressed)
        
        // Ячейка начинает загрузку при условии, что до этого загрузки не было
        if !user.isAlreadyLoaded {
            
            // Вызываем функцию загрузки ячейки 
            cell.downloadImage(for: user, at: indexPath) { user, currentIndex in
                
                print("Loaded image at index: \(currentIndex)", user.imageData)
                
                // Проверяем имя на ячейке и имя пользователя, которое мы хотим присвоить и если они совпадают, то мы находимся в нужном месте.
                if self.users[indexPath.row].userName == user.userName {
                    
                    self.users[currentIndex] = user
                    self.collectionView.reloadData()
                }
            }
        }
        
        cell.setupUser(with: user)
        
        return cell
    }
   
    // MARK: Infinitive Scrolling
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // Получаем индекс текущей ячейки
        let pageIndexFloat = scrollView.contentOffset.x / scrollView.frame.width
        let pageIndex = Int(round(pageIndexFloat))
        
        switch pageIndex {
        
        case 0:
            collectionView.scrollToItem(at: [0, users.count - 2], at: .left, animated: false)
            collectionView.reloadData()
            
        case self.users.count - 1:
            collectionView.scrollToItem(at: [0, 1], at: .right, animated: false)
            collectionView.reloadData()
            
        default:
            break
        }
    }
    
}

// MARK: - Gestures

extension CollectionViewController: UIGestureRecognizerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        // Запрещаем нажимать на ячейку, если нету изображения
        let user = users[indexPath.row]
        
        // Определяем ячейку
        if let cell = collectionView.cellForItem(at: indexPath), user.imageData != nil {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
                // Вызываем обновление дизайна с анимацией
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) { [weak self] in
                    
                    self?.updateCellDesign(for: cell, isPressed: true, indexPath: indexPath)
                    
                    self?.users[indexPath.row].isPressed = true
                }
            }
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        // Определяем ячейку
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // Проверяем должна ли ячейка вернуться в свое номарльное состояние
        if shouldUnhilight {
            
            // Вызываем обновление дизайна с анимацией
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) { [weak self] in
                    
                    self?.updateCellDesign(for: cell, isPressed: false, indexPath: indexPath)
                    
                    self?.users[indexPath.row].isPressed = false
                }
            }
            
        }
        
    }
    
    // Метод, отвечающий за логику после нажатия
    @objc func handleLongPress(gestureRecogniser: UILongPressGestureRecognizer) {
        
        // Если мы отменили жест, то все возвращается в нормальное положение
        if gestureRecogniser.state == .cancelled {
            self.shouldUnhilight = true
        }
        
        // В противном случае мы начинаем прорисовку нажатой ячейки
        guard gestureRecogniser.state == .began else { return }
        self.shouldUnhilight = false
        
        // Определяем ячейку, в которой произошло нажатие
        let position = gestureRecogniser.location(in: collectionView)
        
        // Определяем indexPath
        if let indexPath = collectionView.indexPathForItem(at: position) {
            
            // Запрещаем нажимать на ячейку, если нету изображения
            let user = users[indexPath.row]
            
            // Вызываем alert
            guard user.imageData != nil else { return }
            createAlert(with: "Дополнительные действия", message: "Здесь можно удалить фотографию", indexPath: indexPath)
        }
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


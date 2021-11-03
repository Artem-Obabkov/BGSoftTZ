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
    private let itemSpacing: CGFloat = 30
    private let edgeInsets = UIEdgeInsets(top: 40, left: 30, bottom: 40, right: 30)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Регистрируем ячейку
        collectionView.register(CollectionViewCell.registerNib(), forCellWithReuseIdentifier: CollectionViewCell.cellIdentifier())
        
        // Настраиваем CollectionView
        setupCollectionView()
    }
    
}

// MARK: - UICollectionViewDelegate UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellIdentifier(), for: indexPath) as! CollectionViewCell
        
        cell.setupCellDesign()
        cell.authorLabel.text = "HelloHelloHello"
        
        return cell
    }
    
}

// MARK: - Setup

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionView() {
        
        // Указываем направление скролинга
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        // Настраиваем CollecitonView
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    
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
        return edgeInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return edgeInsets.left
    }
}


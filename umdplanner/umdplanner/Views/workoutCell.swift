//
//  workoutCell.swift
//  
//
//  Created by Robert Choe on 4/25/19.
//

import Foundation
import UIKit
import CoreData

class workoutCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    

    var collectionViewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x
        }
        
        set {
            collectionView.contentOffset.x = newValue
        }
    }
    

    
}

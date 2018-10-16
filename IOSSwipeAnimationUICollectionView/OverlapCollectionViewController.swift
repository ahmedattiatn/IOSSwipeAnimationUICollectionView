//
//  OverlapCollectionViewController.swift
//  IOSSwipeAnimationUICollectionView
//
//  Created by Ahmed ATIA on 16/10/2018.
//  Copyright © 2018 Ahmed ATIA. All rights reserved.
//

import UIKit

private let reuseIdentifier = "OverlapCollectionViewCell"

class OverlapCollectionViewController: UICollectionViewController {
    
    private var numberOfItems = 10
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! OverlapCollectionViewCell
        cell.addGestureRecognizer(UIPanGestureRecognizer.init(target:self, action: #selector(OverlapCollectionViewController.panGestureFired)))
        cell.title.text = String(indexPath.item)
        return cell
    }
    
    @objc func panGestureFired(sender: UIPanGestureRecognizer) {
        if let card = sender.view {
            let point = sender.translation(in: view)
            card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            if sender.state == UIGestureRecognizer.State.ended {
                UIView.animate(withDuration: 0.3) {
                    card.alpha = 0
                    guard self.numberOfItems > 0 else { return }
                    self.numberOfItems -= 1
                    let removalIndex = Int(0) //la Cell suivante devient le 0 dans le collectionview apres suprimer
                    self.collectionView?.deleteItems(at: [IndexPath(item: removalIndex, section: 0)])
                }
                print("Remove Cell ")
            }
        }
    }
    
    @IBAction func didTapAdd(sender: AnyObject) {
        numberOfItems += 1
        let insertionIndex = Int(arc4random() % UInt32(max(numberOfItems, 1)))
        collectionView?.insertItems(at:[IndexPath(item: insertionIndex, section: 0)])
    }
    
    @IBAction func didTapRemove(sender: AnyObject) {
        guard numberOfItems > 0 else { return }
        
        numberOfItems -= 1
        let removalIndex = Int(arc4random() % UInt32(max(numberOfItems, 1)))
        collectionView?.deleteItems(at: [IndexPath(item: removalIndex, section: 0)])
    }
}


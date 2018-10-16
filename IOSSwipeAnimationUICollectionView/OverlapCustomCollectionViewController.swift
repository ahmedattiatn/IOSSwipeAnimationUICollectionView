//
//  OverlapCustomCollectionViewController.swift
//  IOSSwipeAnimationUICollectionView
//
//  Created by Ahmed ATIA on 16/10/2018.
//  Copyright © 2018 Ahmed ATIA. All rights reserved.
//

import UIKit

private let reuseIdentifier = "OverlapCollectionViewCell"

class OverlapCustomCollectionViewController: UICollectionViewController {
    
    private var numberOfItems = 10
    var navbarSize = CGFloat()
    var divisor: CGFloat!
    var imageList: [String] = ["balloon_0003", "balloon_0004","balloon_0005","balloon_0008", "balloon_0010","balloon_0011","balloon_0012", "balloon_0014","balloon_0005","balloon_0003"]
    
    override func viewDidAppear(_ animated: Bool) {
        divisor = (view.frame.width / 2) / 0.61
        navbarSize = (navigationController?.navigationBar.frame.maxY ?? 64) + 10 // + 10 car on a un decalage de 10 PX entre les Cartes
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! OverlapCollectionViewCell
        cell.addGestureRecognizer(UIPanGestureRecognizer.init(target:self, action: #selector(OverlapCollectionViewController.panGestureFired)))
        cell.title.text = String(indexPath.item)
        cell.image.image = UIImage(named: imageList[indexPath.row])
        return cell
    }
    
    @objc func panGestureFired(sender: UIPanGestureRecognizer) {
        if let card = sender.view {
            let point = sender.translation(in: view)
            card.center = CGPoint(x: view.center.x + point.x , y: view.center.y + point.y - navbarSize)
            // - navbarSize :taille de navBar, il faut prendre en consideration Y par raport a la NavBar donc si on na pas de NavBar on fait pas le - navbarSize
            let xFromCenter = card.center.x - view.center.x
            // example to rotate: 100 /2 = 50/0.61 = 81.967
            let scale = min(100/abs(xFromCenter),1)
            // Anything above one will increase the size and under 1 will deacrese the size
            card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor).scaledBy(x: scale, y: scale)
            card.alpha = 1 - (abs(xFromCenter) / view.center.x)
            if sender.state == UIGestureRecognizer.State.ended {
                if card.center.x < 75 {
                    //Move off to the left side of the screen
                    UIView.animate(withDuration: 0.3) {
                        //card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75 )
                        card.alpha = 0
                        self.removeCell()
                    }
                    return
                }
                else if card.center.x > view.frame.width - 75 {
                    //Move off to the right side of the screen
                    UIView.animate(withDuration: 0.3) {
                        //card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                        card.alpha = 0
                        self.removeCell()
                    }
                    return
                }
                //return the card to the Original place
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: self.view.center.x , y: self.view.center.y - self.navbarSize)
                    card.alpha = 1
                    card.transform = CGAffineTransform.identity
                }
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
    
    func removeCell() {
        guard self.numberOfItems > 0 else {
            print("No Cell To Remove!")
            return
            
        }
        self.numberOfItems -= 1
        let removalIndex = Int(0) //la Cell suivante devient le 0 dans le collectionview apres suprimer
        self.collectionView?.deleteItems(at: [IndexPath(item: removalIndex, section: 0)])
    }
}

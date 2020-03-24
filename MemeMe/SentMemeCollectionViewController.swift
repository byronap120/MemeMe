//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Byron Ajin on 3/22/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController : UICollectionViewController {
    
    @IBOutlet var memeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private let numberOfCellsPortrait: CGFloat = 3.0
    private let numberOfCellsLandscape: CGFloat = 6.0
    private let minimunSpace: CGFloat = 3.0
    private let dimensionSpace: CGFloat = 6.0
    private let memeViewCellIdentifier: String = "MemeViewCell"
    private let memeDetailVCIdentifier: String = "MemeDetailViewController"
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeCollectionView.reloadData()
        updateFlowLayoutDimensions(size: view.frame.size, numberOfCells: numberOfCellsPortrait)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memeViewCellIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.memeTitle.text = "\(meme.topText)...\(meme.bottomText)"
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailMeme = self.storyboard!.instantiateViewController(withIdentifier: memeDetailVCIdentifier) as! MemeDetailViewController
        
        detailMeme.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailMeme, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let numberOfCells: CGFloat =
            UIDevice.current.orientation.isLandscape == true ? numberOfCellsLandscape : numberOfCellsPortrait
        updateFlowLayoutDimensions(size: size, numberOfCells: numberOfCells)
    }
    
    private func updateFlowLayoutDimensions(size: CGSize, numberOfCells: CGFloat){
        let dimension = (size.width - dimensionSpace) / numberOfCells
        flowLayout?.minimumInteritemSpacing = minimunSpace
        flowLayout?.minimumLineSpacing = minimunSpace
        flowLayout?.itemSize = CGSize(width: dimension, height: dimension)
    }
}

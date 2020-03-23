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
    
    private let numberOfCells: CGFloat = 3.0
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dimension = (view.frame.size.width - dimensionSpace) / numberOfCells
        flowLayout.minimumInteritemSpacing = minimunSpace
        flowLayout.minimumLineSpacing = minimunSpace
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
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
}

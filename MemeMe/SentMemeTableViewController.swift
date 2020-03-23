//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Byron Ajin on 3/22/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var memeTableView: UITableView!
    
    private let memeViewCellIdentifier: String = "TableMemeCell"
    private let memeDetailVCIdentifier: String = "MemeDetailViewController"
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: memeViewCellIdentifier, for: indexPath) as! MemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.memeTitle?.text = "\(meme.topText)...\(meme.bottomText)"
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailMeme = self.storyboard!.instantiateViewController(withIdentifier: memeDetailVCIdentifier) as! MemeDetailViewController
        
        detailMeme.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailMeme, animated: true)
    }
}

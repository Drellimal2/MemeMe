//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Dane Miller on 8/16/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController {

    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    @IBOutlet weak var sentMemesCollectionView: UICollectionView!
    let memeDetailsSegueIdentifier = "memeDetails"
    
    var memes = [Meme]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 8.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes
        sentMemesCollectionView.reloadData()
        
    }
    
    

}

extension MemeCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = self.memes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! SentMemeCollectionViewCell
        cell.memeImage.image = meme.memeImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        vc.meme = self.memes[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


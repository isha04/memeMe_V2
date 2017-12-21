//
//  collectionViewController.swift
//  MemeMe
//
//  Created by isha on 14/12/17.
//  Copyright © 2017 isha. All rights reserved.
//

import Foundation
import UIKit

class collectonViewController: UICollectionViewController {
    
    var memes : [Meme]?
    var selectedMeme : Meme?
    
    func loadMemes(){
        self.memes = AppDelegate.sharedInstance().memes
        self.collectionView!.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMemes()
    }

    @IBAction func NewButton(_ sender: Any) {
        performSegue(withIdentifier: "showEditor", sender: self)
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let mes = self.memes {
            return mes.count
        } else {
            return 0
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath)
        
        let memeCell = cell as! CollectionViewCell
        let row = memes![indexPath.row]
        memeCell.collectionImage.image = row.memedImage
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "detailViewController") as! detailViewController
        let meme = memes![indexPath.row]
        self.selectedMeme = meme
        vc.memedImage = self.selectedMeme?.memedImage
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
    


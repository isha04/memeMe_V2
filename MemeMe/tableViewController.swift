//
//  tableViewController.swift
//  MemeMe
//
//  Created by isha on 14/12/17.
//  Copyright © 2017 isha. All rights reserved.
//

import Foundation
import UIKit

class tableViewController: UITableViewController {
    
    var memes : [Meme]?
    var selectedMeme : Meme?
    
    
    func loadMemes(){
        self.memes = AppDelegate.sharedInstance().memes
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViewController().refreshTable()
        loadMemes()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sentMeme")!
        let meme = self.memes![(indexPath as NSIndexPath).row]
        cell.textLabel?.text = "\(meme.topText!) ... \(meme.bottomText!)"
        cell.imageView?.image = meme.memedImage
        cell.imageView?.contentMode = .scaleAspectFit
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "detailViewController") as! detailViewController
        let meme = memes![indexPath.row]
        self.selectedMeme = meme
        vc.memedImage = self.selectedMeme?.memedImage
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func newButton(_ sender: Any) {
        performSegue(withIdentifier: "showEditor", sender: self)
    }
    
}


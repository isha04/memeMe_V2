//
//  detailViewController.swift
//  MemeMe
//
//  Created by isha on 18/12/17.
//  Copyright © 2017 isha. All rights reserved.
//

import Foundation
import UIKit

class detailViewController: UIViewController {
    
    @IBOutlet weak var detailImage: UIImageView!
    var memedImage: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailImage.image = memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

//  ViewController.swift
//  MemeMe
//
//  Created by isha on 03/12/17.
//  Copyright © 2017 isha. All rights reserved.
//

import UIKit
import Foundation

struct Meme {
    var topText: String!
    var bottomText: String!
    var orignalImage: UIImage!
    var memedImage: UIImage!
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topMemeText: UITextField!
    @IBOutlet weak var bottomMemeText: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    
    var selectedTextField: UITextField?
    var meme:Meme!
    
    var imagesDirectoryPath:String!
    var images:[UIImage]!
    var titles:[String]!
    let imagePicker = UIImagePickerController()
    
    
    let memeTextAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue:  UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.gray,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -5]
    
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topMemeText.defaultTextAttributes = memeTextAttributes
        topMemeText.text = "TOP"
        bottomMemeText.text = "BOTTOM"
        topMemeText.textAlignment = .center
        bottomMemeText.defaultTextAttributes = memeTextAttributes
        bottomMemeText.textAlignment = .center
        topMemeText.delegate = self
        bottomMemeText.delegate = self
        shareButton.isEnabled = false
    }
    
    
    
    func save(memedImage: UIImage) {
        let meme = Meme(topText: topMemeText.text!, bottomText: bottomMemeText.text!, orignalImage: imageView.image, memedImage: memedImage)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWillDisappear(_ notification:Notification) {
        self.view.frame.origin.y = 0
    }

    
    @objc func keyboardWillShow(_ notification:Notification) {
        if selectedTextField == bottomMemeText {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func pickImagefromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        shareButton.isEnabled = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        shareButton.isEnabled = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
        if selectedTextField?.text == "TOP" || selectedTextField?.text == "BOTTOM" {
            selectedTextField?.text = ""
        }
        textField.becomeFirstResponder()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == topMemeText && textField.text! == "" {
            textField.text = "TOP"
        }
        if textField == bottomMemeText && textField.text! == "" {
            textField.text = "BOTTOM"
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        let memeToShare = generateMemedImage()
        let activity = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        activity.completionWithItemsHandler = { (activity, success, items, error) in
            
            if success {
                self.save(memedImage: memeToShare)
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        present(activity, animated: true, completion:nil)
    }
    
    func refreshTable(){
        do{
            images!.removeAll()
            titles = try FileManager.default.contentsOfDirectory(atPath: imagesDirectoryPath)
            for image in titles{
                let data = FileManager.default.contents(atPath: (imagesDirectoryPath as NSString).appendingPathComponent("/\(image)"))
                let image = UIImage(data: data!)
                images.append(image!)
            }
            //self.tableView.reloadData()
        }catch{
            print("Error")
        }
    }

}

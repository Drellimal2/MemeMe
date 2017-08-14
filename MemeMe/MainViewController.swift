//
//  MainViewController.swift
//  MemeMe
//
//  Created by Dane Miller on 8/14/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var memeView: UIView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName : UIColor(red: 0.0, green: 0.0, blue:0.0, alpha: 1.0),
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4.0,
    ]
    
    @IBAction func cancelMeme(_ sender: Any) {
        memeImageView.image = nil
        shareButton.isEnabled = false
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        memeView.backgroundColor = .clear
    }
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        
        let imageToShare = [ memedImage ]
        
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: { () -> Void in
            self.saveMeme(memedImage: memedImage)
//            activityViewController.dismiss(animated: true, completion: nil)
        })
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = memeTextFieldDelegate
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        
        bottomTextField.delegate = memeTextFieldDelegate
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        
        
    }
    
    func saveMeme(memedImage : UIImage){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: memeImageView.image!, memeImage: memedImage)
        print(meme)
    }
    
    @IBAction func takeMemePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: false, completion: nil)

    }
    
    @IBAction func pickMemeImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: false, completion: nil)

    }
    
    func generateMemedImage() -> UIImage {
        
        UIGraphicsBeginImageContext(memeView.frame.size)
        view.drawHierarchy(in: memeView.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)

    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)

    }
    
    func keyboardWillShow(_ notification:Notification) {
        if topTextField.isEditing || topTextField.isFocused {
            return
        }
        view.frame.origin.y -= getKeyboardHeight(notification)
        
    }
    
    func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

}

extension MainViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ controller : UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info["UIImagePickerControllerOriginalImage"] as! UIImage! {
            memeImageView.image = image
            shareButton.isEnabled = true
            memeView.backgroundColor = .black
        }
        controller.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ controller: UIImagePickerController){
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
}


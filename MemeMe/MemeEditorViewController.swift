//
//  MainViewController.swift
//  MemeMe
//
//  Created by Dane Miller on 8/14/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var memeView: UIView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    var editMeme : Meme!
    
    let cameraTag = 0
    let galleryTag = 1
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName : UIColor(red: 0.0, green: 0.0, blue:0.0, alpha: 1.0),
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName : -4.0,
    ]
    
    @IBAction func cancelMeme(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        
        let imageToShare = [ memedImage ]
        
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.completionWithItemsHandler = {(activity, completed, items, error) in
            self.saveMeme(memedImage: memedImage)
        }

        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextField(textField: topTextField, defaultText:"TOP")
        prepareTextField(textField: bottomTextField, defaultText:"BOTTOM")
        print(editMeme)
        if editMeme != nil{
            memeImageView.image  = editMeme.image
            topTextField.text = editMeme.topText
            bottomTextField.text = editMeme.bottomText
        }

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
    }
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        textField.delegate = memeTextFieldDelegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = defaultText
    }
    
    
    
    func saveMeme(memedImage : UIImage){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: memeImageView.image!, memeImage: memedImage)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        print(appDelegate.memes.count)
        self.dismiss(animated: true, completion: nil)
        
    }
    
        
    @IBAction func pickImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        switch (sender as! UIBarButtonItem).tag {
            case cameraTag:
                imagePicker.sourceType = .camera
                break
            case galleryTag:
                imagePicker.sourceType = .photoLibrary
                break
            default:
                break
        }
        imagePicker.allowsEditing = false // It was set to true to enable cropping however the cropping rect is always a square and I was not able to find a solution to change it.
        present(imagePicker, animated: false, completion: nil)
        
    }
    
    
    func generateMemedImage() -> UIImage {
        let snapView = self.memeView.snapshotView(afterScreenUpdates: true)! // Added this method to get only the view without the padding at the top or the toolbar or navigation bar

        UIGraphicsBeginImageContext(snapView.frame.size)
        view.drawHierarchy(in: snapView.frame, afterScreenUpdates: true)
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
        view.frame.origin.y = -getKeyboardHeight(notification)
        
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

extension MemeEditorViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ controller : UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        /*
             Would use UIImagePickerControllerEditedImage to get the cropped image if editing was enabled.
         */
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


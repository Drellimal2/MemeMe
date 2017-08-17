//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Dane Miller on 8/16/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme : Meme!
    let editMemeIdentifier = "editMeme"
    @IBOutlet weak var imageView : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memeImage
    }

    
    
    /*
     I think a useful feature would be for us to be able to share the meme again in the detail view.
     */
    @IBAction func shareAgain(_ sender: Any) {
        let imageToShare = [meme.memeImage]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)

    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == editMemeIdentifier{
            let vc = segue.destination as! MemeEditorViewController
            vc.editMeme = self.meme
            self.navigationController?.popToRootViewController(animated: false) // I dont want to come back here after I edited the meme.
            
        }
    }
    

    
}

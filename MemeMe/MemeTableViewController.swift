//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Dane Miller on 8/16/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var editAllMemesButton: UIBarButtonItem!
    
    var isEditingAllMemes = false
    
    @IBOutlet weak var sentMemeTableView: UITableView!
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        
    }
    
    @IBAction func editAllMemes(_ sender: Any) {
        sentMemeTableView.isEditing = !sentMemeTableView.isEditing
        editAllMemesButton.title = sentMemeTableView.isEditing ? "Done" : "Edit"
        print(sentMemeTableView.isEditing ? "Done" : "Edit")

    }
    override func viewDidAppear(_ animated: Bool) {
        isEditingAllMemes = false
        updateData()
    }

    func updateData(){
        self.memes = appDelegate.memes
        self.sentMemeTableView.reloadData()
        editAllMemesButton.isEnabled = self.memes.count > 0
    
    }
    
    

   
}

extension MemeTableViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell") as! SentMemeTableViewCell
        let meme = self.memes[indexPath.row]

        cell.memeImage.image = meme.memeImage
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        vc.meme = self.memes[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath){
        switch editingStyle{
        case .delete:
            appDelegate.memes.remove(at: indexPath.row)
            updateData()
            break
        default:
            break
        }
    }
    
    
}

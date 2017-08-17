//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Dane Miller on 8/16/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController {

    @IBOutlet weak var sentMemeTableView: UITableView!
    var memes = [Meme]()
    override func viewDidLoad() {
        super.viewDidLoad()
        sentMemeTableView.tableHeaderView = nil
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes
        self.sentMemeTableView.reloadData()
    }

    

   
}

extension MemeTableViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell")!
        let meme = self.memes[indexPath.row]
        cell.textLabel?.text = meme.topText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        vc.meme = self.memes[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

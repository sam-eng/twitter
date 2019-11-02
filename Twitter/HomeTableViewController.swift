//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Samantha Eng on 11/1/19.
//  Copyright © 2019 Samantha Eng. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var nTweets : Int!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    @objc func loadTweet() {
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 10]
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success:
            { (tweets: [NSDictionary]) in
                
                self.tweetArray.removeAll()
                
                for tweet in tweets {
                    self.tweetArray.append(tweet)
                }
                
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
                
        }, failure: { (Error) in
            print("Could not retrieve tweets.")
        })
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        let photoURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: photoURL!)
        
        if let imageData = data {
            cell.profileView.image = UIImage(data: imageData)
        }
        
        cell.nameLabel.text = user["name"] as! String
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as? String
        
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }

}

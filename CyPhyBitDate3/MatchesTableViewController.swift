//
//  MatchesTableViewController.swift
//  CyPhyBitDate3
//
//  Created by Matt Linaberry on 5/16/15.
//  Copyright (c) 2015 Matt Linaberry. All rights reserved.
//

import UIKit

class MatchesTableViewController: UITableViewController {
    
    var matches: [Match] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = UIImageView(image: UIImage(named: "chat-header"))
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToPreviousVC:")
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        
        // in our page controller, we need to get a fresh set of data any time it appears
        fetchMatches({
            matches in
            self.matches = matches
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToPreviousVC(button: UIBarButtonItem) {
        pageController.goToPreviousVC()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return matches.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as UserCell

        // Configure the cell...
        
        let user = matches[indexPath.row].user
        cell.nameLabel.text = user.name
        user.getPhoto({
            image in
            cell.avatarImageView.image = image
        })

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = ChatViewController()
        let match = matches[indexPath.row]
        vc.matchID = match.id
        vc.title = match.user.name
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

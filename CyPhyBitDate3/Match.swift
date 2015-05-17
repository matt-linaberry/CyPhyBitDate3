//
//  Match.swift
//  CyPhyBitDate3
//
//  Created by Matt Linaberry on 5/16/15.
//  Copyright (c) 2015 Matt Linaberry. All rights reserved.
//

import Foundation

struct Match {
    let id: String
    let user: User
}

func fetchMatches (callback:([Match]) -> ()) {
    // callback for an async operation!
    PFQuery(className: "Action").whereKey("byUser", equalTo: PFUser.currentUser().objectId).whereKey("type", equalTo: "matched").findObjectsInBackgroundWithBlock({
        objects, error in
        if let matches = objects as? [PFObject] {
            let matchedUsers = matches.map({
                (object)->(matchID: String, userID: String) in
                (object.objectId, object.objectForKey("toUser") as String)
            })
            let userIDs = matchedUsers.map({$0.userID})
            
            PFUser.query()
            .whereKey("objectId", containedIn: userIDs)
            .findObjectsInBackgroundWithBlock({
                objects, error in
                // gimmie these users
                if let users = objects as? [PFUser] {
                    var users = reverse(users) // needed because of Parse's fetching
                    var m = Array<Match>()
                    for (index, user) in enumerate(users) {
                        m.append(Match(id: matchedUsers[index].matchID, user: pfUserToUser(user)))
                    }
                    callback(m)
                }
            })
        }
    })
}
//
//  User.swift
//  CyPhyBitDate3
//
//  Created by Matt Linaberry on 5/10/15.
//  Copyright (c) 2015 Matt Linaberry. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let name: String
    private let pfUser: PFUser
    
    func getPhoto(callback:(UIImage) -> ()) {
        let imageFile = pfUser.objectForKey("picture") as PFFile
        imageFile.getDataInBackgroundWithBlock({
            data,error in
            if let data = data {
                callback(UIImage(data: data)!)
            }
        })
    }
}

func pfUserToUser(user: PFUser) -> User {
    return User(id: user.objectId, name: user.objectForKey("first_name") as String, pfUser: user)
}

func currentUser() -> User? {
    if let user = PFUser.currentUser() {
        return pfUserToUser(user)
    }
    else {
        return nil
    }
}

func fetchUnviewedUsers(callback: ([User]) -> ()) {
    PFQuery(className: "Action").whereKey("byUser", equalTo: PFUser.currentUser().objectId).findObjectsInBackgroundWithBlock({
        objects, error in
        let seenIDS = map(objects, {$0.objectForKey("toUser")!})
        PFUser.query()
            .whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)  // lets get all of the users that arent ME!
            .whereKey("objectId", notContainedIn: seenIDS)
            .findObjectsInBackgroundWithBlock({
                objects, error in
                if let pfUsers = objects as? [PFUser] {
                    let users = map(pfUsers, {pfUserToUser($0)})
                    callback(users)
                }
            })
    })
    

}

func saveSkip(user: User) {
    let skip = PFObject(className: "Action")
    skip.setObject(PFUser.currentUser().objectId, forKey: "byUser")
    skip.setObject(user.id, forKey: "toUser")
    skip.setObject("skipped", forKey: "type")
    skip.saveInBackgroundWithBlock(nil) // don't need to do anything when this is done!
}

func saveLike(user: User) {
    PFQuery(className: "Action").whereKey("byUser", equalTo: user.id).whereKey("toUser", equalTo: PFUser.currentUser().objectId).whereKey("type", equalTo: "liked").getFirstObjectInBackgroundWithBlock({
        object, error in
        var matched = false
        if object != nil {
            matched = true
            object.setObject("matched", forKey: "type")
            object.saveInBackgroundWithBlock(nil)
        }
        
        let match = PFObject(className: "Action")
        match.setObject(PFUser.currentUser().objectId, forKey: "byUser")
        match.setObject(user.id, forKey: "toUser")
        match.setObject(matched ? "matched" : "liked", forKey: "type")
        
        match.saveInBackgroundWithBlock(nil)
    })
}
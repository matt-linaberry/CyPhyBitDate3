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

private func pfUserToUser(user: PFUser) -> User {
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
    PFUser.query()
    .whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)  // lets get all of the users that arent ME!
    .findObjectsInBackgroundWithBlock({
        objects, error in
        if let pfUsers = objects as? [PFUser] {
            let users = map(pfUsers, {pfUserToUser($0)})
            callback(users)
        }
    })
}
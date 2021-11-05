//
//  UserModel.swift
//  BGSoftTZ
//
//  Created by pro2017 on 05/11/2021.
//

import Foundation

class User {
    
    var userName: String?
    var userUrl: String?
    var photoUrl: String?
    var colors: [String]?
    
    init?(json: [String: Any]) {
        
        guard
            let userName = json["user_name"] as? String,
            let userUrl = json["user_url"] as? String,
            let photoUrl = json["photo_url"] as? String,
            let colors = json["colors"] as? [String]
        else { return nil}
        
        self.userName = userName
        self.userUrl = userUrl
        self.photoUrl = photoUrl
        self.colors = colors
    }
}

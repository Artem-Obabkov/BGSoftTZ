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
    
    var imageUrl: String?
    var imageData: Data?
    var isAlreadyLoaded: Bool = false
    
    var isPressed: Bool = false
    
    
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
        
        self.imageUrl = editURL(url: photoUrl)
    }
    
    // Получаем название изображения.
    private func editURL(url: String) -> String {
        
        var imageName = ""
        
        // Получаем название
        if let firstRange = url.range(of: "?") {
            
            var name = ""
            name =  String(url[url.startIndex..<firstRange.lowerBound])
            name = String(name.reversed())
            
            if let secondRange = name.range(of: "/") {
                imageName = String(name[name.startIndex..<secondRange.lowerBound])
                imageName = String(imageName.reversed())
                return "http://dev.bgsoft.biz/task/\(imageName).jpg"
            }
        }
        return ""
    }
}

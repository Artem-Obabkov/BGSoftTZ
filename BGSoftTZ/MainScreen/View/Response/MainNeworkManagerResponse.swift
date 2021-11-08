//
//  MainNeworkManagerResponse.swift
//  BGSoftTZ
//
//  Created by pro2017 on 05/11/2021.
//

import Foundation

class MainNeworkManagerResponse {
    
    // Помещаем данные пользователей сюда
    let users: [User]
    
    
    init?(json: Any) {
        
        // Преобразовываем JSON в словарь типа [String: Any]
        guard let jsonUsersArray = json as? [String: Any] else { return nil }
        
        var _users = [User]()
        
        // Перебираем всех пользователей и инициализируем пользователя
        for jsonDict in jsonUsersArray {
            
           // Создаем пользователя
            guard
                let userJson = jsonDict.value as? [String: Any],
                let user = User(json: userJson)
            else { continue }
            
            _users.append(user)
        }
        
        // Сортируем массив по имени пользователя userName
        let sortedUsers = _users.sorted { $0.userName! < $1.userName! }
        
        self.users = sortedUsers
    }
}

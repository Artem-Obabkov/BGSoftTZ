//
//  MainNetworkManager.swift
//  BGSoftTZ
//
//  Created by pro2017 on 05/11/2021.
//

import Foundation

class MainNetworkManager {
    
    private init() {}
    
    static func getImages(completion: @escaping (MainNeworkManagerResponse?) -> () ) {
        
        guard let url = URL(string: "http://dev.bgsoft.biz/task/credits.json") else { return }
        
        
        NetworkManager.shared.getData(from: url) { (json) in
            
            print(json)
            
            // Мы передаем полученный JSON в MainNeworkManagerResponse, который в свою очередь преобразовывает этот JSON и создает массив пользователей, который а последствии с помощью response передается в MainViewController
            DispatchQueue.main.async {
                
                //
                guard
                    let response = MainNeworkManagerResponse(json: json)
                else { return }
                
                completion(response)
            }
        }
    }
}

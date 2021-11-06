//
//  MainNetworkManager.swift
//  BGSoftTZ
//
//  Created by pro2017 on 05/11/2021.
//

import Foundation
import UIKit

class MainNetworkManager {
    
    static let shared = MainNetworkManager()
    private init() {}
    
    public func getImages(completion: @escaping (MainNeworkManagerResponse?) -> () ) {
        
        guard let url = URL(string: "http://dev.bgsoft.biz/task/credits.json") else { return }
        
        NetworkManager.shared.getData(from: url) { (json) in
            
            // Мы передаем полученный JSON в MainNeworkManagerResponse, который в свою очередь преобразовывает этот JSON и создает массив пользователей, который а последствии с помощью response передается в MainViewController
            DispatchQueue.main.async {
                
                guard
                    let response = MainNeworkManagerResponse(json: json)
                else { return }
                
                completion(response)
            }
        }
    }
    
    public func downloadImage(with url: String, completion: @escaping (Data) -> () ) {
        
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            // Проверяем данные
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                completion(data)
            }
        }
        session.resume()
    }
}

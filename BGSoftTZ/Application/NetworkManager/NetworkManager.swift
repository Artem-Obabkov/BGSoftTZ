//
//  NetworkManager.swift
//  BGSoftTZ
//
//  Created by pro2017 on 05/11/2021.
//

import Foundation

class NetworkManager {
    
    // Создали синглтон
    static let shared = NetworkManager()
    private init() {}
    
    // Создаем общий запрос
    public func getData(from url: URL, completion: @escaping (Any) -> () ) {
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            // Обрабатываем ошибку
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // Проверяем данные
            guard let data = data else { return }
            
            // С помощью сериализатора извлекаем json
            do {
                
                // Извлекаем JSON
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                DispatchQueue.main.async {
                    
                    // Передаем данные в клоужер
                    completion(json)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

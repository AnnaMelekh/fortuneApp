//
//  Network.swift
//  fortuneApp
//
//  Created by Anna Melekhina on 07.02.2025.
//

import UIKit

protocol NetworkServiceDelegate {
    func didUpdateData(meme: MemModel)
    func didFailWithError(error: Error)
}

struct NetworkManager {
    
    let url = "https://api.imgflip.com/get_memes"
    var delegate: NetworkServiceDelegate?
    
    func performRequest() {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Ошибка запроса: \(error.localizedDescription)")
                    return
                }
                
                if let safeData = data {
                    if let memeModel = self.parseJSON(safeData) {
                        DispatchQueue.main.async {
                            self.delegate?.didUpdateData(meme: memeModel)
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ memData: Data) -> MemModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(MemData.self, from: memData)
            
            let memeURL = decodedData.data.memes.randomElement()?.url ?? "https://i.imgflip.com/23ls.jpg"
            
            return MemModel(urlMem: memeURL)
            
        } catch {
            print("Ошибка декодирования: \(error)")
            return nil
        }
    }
}







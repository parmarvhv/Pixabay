//
//  NetworkLayer.swift
//  Pixabay
//
//  Created by Nickelfox on 02/03/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import Foundation

class Network {
    static let shared = Network()
    
    func fetch(from urlString: String, completion: @escaping (Any?, String?) -> Void) {
        guard let url = URL(string: urlString) else { completion(nil, "Invalid URL"); return }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, responce, error) in
            if error != nil {
                completion(nil, "Call Failed")
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                completion(json, nil)
            } catch {
                completion(nil, "Couldn't parse JSON")
            }
            
        }
        task.resume()
    }
}

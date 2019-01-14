//
//  JokesServiceApi.swift
//  JakmallListView
//
//  Created by Fachreza Audrian Naufal on 1/12/19.
//  Copyright © 2019 Fachreza Audrian Naufal. All rights reserved.
//

import Foundation

class JokesServiceApi {
    
    var delegate: JokesDelegate?
    
    func getJokes() {
        
        guard let url = URL(string: "\(AppSettings.UrlSession)/jokes/random/10-") else {
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            
            URLSession.shared.dataTask(with: url) {
                
                [weak self] (data,response,err) in
                
                    guard err == nil else {
                        self?.delegate?.getAllJokes(nil, false)
                        return
                    }
                    
                    guard let data = data else {
                        self?.delegate?.getAllJokes(nil, false)
                        return
                    }
                
                DispatchQueue.main.async {
                    do{
                        
                        let decoder = JSONDecoder()
                        let jokes = try decoder.decode(JokesModel.self, from: data)
                        self?.delegate?.getAllJokes(jokes.value, true)
                    
                    }catch{
                        self?.delegate?.getAllJokes(nil, false)
                    }
                    
                }
                
                }.resume()
            
        }
        
    }
    
}

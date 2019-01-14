//
//  JokesProtocol.swift
//  JakmallListView
//
//  Created by Fachreza Audrian Naufal on 1/12/19.
//  Copyright © 2019 Fachreza Audrian Naufal. All rights reserved.
//

import Foundation

protocol JokesDelegate: class {
    
    func getAllJokes(_ jokes: [ValueModel]?, _ status: Bool)
    
}

//
//  MemData.swift
//  fortuneApp
//
//  Created by Anna Melekhina on 07.02.2025.
//

import Foundation

struct MemData: Decodable {
var data: DataStruct
}

struct DataStruct: Decodable {
var memes: [Memes]
}

struct Memes: Decodable {
    var url: String
}
                    

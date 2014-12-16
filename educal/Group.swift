//
//  Group.swift
//  educal
//
//  Created by Jurriaan Lindhout on 15-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import Foundation

class Group: NSObject {
    
    var title:String
    var code:String
    
    init(title:String, code:String) {
        self.title = title
        self.code = code
    }
    
}
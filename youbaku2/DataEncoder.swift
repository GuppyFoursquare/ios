//
//  File.swift
//  youbaku2
//
//  Created by ULAKBIM on 24/07/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import Foundation
class DataEncoder{
static func decode<T>(data: NSData) -> T {
    let pointer = UnsafeMutablePointer<T>.alloc(sizeof(T.Type))
    data.getBytes(pointer)
    
    return pointer.move()
}
static func encode<T>(var value: T) -> NSData {
    return withUnsafePointer(&value) { p in
        NSData(bytes: p, length: sizeofValue(value))
    }
}
}
//
//  Chess.swift
//  Chess
//
//  Created by Hailey on 2022/06/20.
//

import Foundation
struct Point: Equatable {

    var y: Int
    var x: Int
    
    init(point: String) {
        self.y = (Int(String(point.last ?? "0")) ?? 0) - 1
        self.x = Int((UnicodeScalar(String(point.first ?? "0"))?.value ?? 0) - 65)
    }
    
    func checkIndexOutOfRange(y: Int, x: Int) -> Bool {
        if 0 <= x && x < 8 && 0 <= y && y < 8 {
            return true
        } else {
            return false
        }
    }
    
    func convertToString() -> String {
        if let xString = UnicodeScalar(x + 65) {
            let yString = "\(y + 1)"
            return "\(String(describing: xString))\(yString)"
        } else {
            return ""
        }
    }
    
    mutating func move(offsetX: Int, offsetY: Int) -> Bool {
        let nx = x + offsetX
        let ny = y + offsetY
        
        guard checkIndexOutOfRange(y: ny, x: nx) else { return false }
        
        self.x = nx
        self.y = ny
        return true
    }
}

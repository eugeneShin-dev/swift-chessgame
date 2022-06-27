//
//  Point.swift
//  Chess
//
//  Created by Hailey on 2022/06/22.
//

import Foundation

enum PointError: LocalizedError {
    case invalidFormat
    case indexOutOfRange
}

struct Point {
    
    enum X: Int {
        case A, B, C, D, E, F, G, H
        
        static func - (lhs: Self, rhs: Self) -> Int {
            return lhs.rawValue - rhs.rawValue
        }
    }
    
    private static let yDefault: UInt8 = Character("1").asciiValue ?? 1
    private static let xDefault: UInt8 = Character("A").asciiValue ?? 1

    var y: Int
    var x: X
    
    init(y: Int, x: X) {
        self.y = y
        self.x = x
    }

    init?(y: Int, x: Int) throws {
        if let x = X(rawValue: x) {
            self.init(y: y, x: x)
        } else {
            throw PointError.invalidFormat
        }
    }
    
    init?(string: String) {
        guard let point = try? Point.getValidPoint(string: string) else { return nil }
        self.init(y: point.y, x: point.x)
    }

    // 유효한 좌표인지 확인
    static private func getValidPoint(string: String) throws -> Point {
        guard string.count == 2,
              let yValue = string.last?.asciiValue,
              let xValue = string.first?.asciiValue else {
                    throw PointError.invalidFormat
        }
        
        let y = Int(yValue - yDefault)
        let x = Int(xValue - (Character("A").asciiValue ?? 65))
        
        try checkRangeOfIndex(y: y, x: x)
        
        if let x = X(rawValue: x) {
            return Point(y: y, x: x)
        } else {
            throw PointError.invalidFormat
        }
    }

    static private func checkRangeOfIndex(y: Int, x: Int) throws {
        if x < 0 || x >= 8 || y < 0 || y >= 8 {
            throw PointError.indexOutOfRange
        }
    }

    func convertToString() -> String {
        let xString = "\(x)"
        let yString = "\(y + 1)"
        return "\(String(describing: xString))\(yString)"
    }
    
    mutating func move(offsetX: Int, offsetY: Int) throws {
        let nx = x.rawValue + offsetX
        let ny = y + offsetY
        
        try Point.checkRangeOfIndex(y: ny, x: nx)
        
        if let nx = X(rawValue: nx) {
            self.x = nx
            self.y = ny
        } else {
            throw PointError.invalidFormat
        }
    }
}

extension Point: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.y == rhs.y && lhs.x == rhs.x
    }
}

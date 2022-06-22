//
//  Point.swift
//  Chess
//
//  Created by Hailey on 2022/06/22.
//

struct Point: Equatable {

    var y: Int
    var x: Int
    
    init(string: String) {
        self.y = (Int(String(string.last ?? "0")) ?? 0) - 1
        self.x = Int((UnicodeScalar(String(string.first ?? "0"))?.value ?? 0) - 65)
    }

    // 유효한 좌표인지 확인
    static func checkCoordinate(string: String) -> Bool {
        let yString: String? = String(string.last ?? Character.init(""))
        let xString: String? = String(string.first ?? Character.init(""))
        
        guard let yString = yString, let xString = xString else { return false }

        let y = (Int(yString) ?? 0) - 1
        let x = Int(UnicodeScalar(xString)?.value ?? 0) - 65
        
        let isValid = checkIndexOutOfRange(y: y, x: x)
        
        if !isValid {
            ChessError.showErrorMessage(errorType: .invalidCoordinate)
        }
        
        return isValid
    }

    // 이동 시 인덱스 체크
    static func checkIndexOutOfRange(y: Int, x: Int) -> Bool {
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
        
        guard Point.checkIndexOutOfRange(y: ny, x: nx) else { return false }
        
        self.x = nx
        self.y = ny
        return true
    }
}

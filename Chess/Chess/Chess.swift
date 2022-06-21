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

class Chess {

    private var board = [[Piece]](repeating: Array(repeating: Piece(color: .none, type: .none),count: 8), count: 8)
    private var turn: Color = .white
    
    init() {
        reset()
    }
    
    func reset() {
        let order: [PieceType] = [.luke, .knight, .bishop, .none, .queen, .bishop, .knight, .luke]
        
        for rank in 0..<8 {
            board[0][rank] = Piece(color: .black, type: order[rank])
            board[1][rank] = Piece(color: .black, type: .pawn)
            board[6][rank] = Piece(color: .white, type: .pawn)
            board[7][rank] = Piece(color: .white, type: order[rank])
        }
    }
    
    func display() -> String {
        var result = ""

        for file in 0..<8 {
            result += board[file].flatMap { $0.mark }
            result += file < 7 ? "\n" : ""
        }
        
        return result
    }
    
    func showGuide(command: String) -> [String] {
        let startPoint: Point = Point(point: String(command.suffix(2)))
        let piece = board[startPoint.y][startPoint.x]
        
        // 말이 갈 수 있는 포인트 중 막히지 않은 칸만 필터링
        let possiblePoints = piece.getPossiblePoints(startPoint: startPoint).filter { check(from: startPoint, to: $0) && checkEndpoint(point: $0) }
        let convertedPoints = possiblePoints.map { $0.convertToString() } // rank, file 형식으로 변형
        return convertedPoints
    }
    
    func action(command: String) -> Bool {
        let startPoint: Point = Point(point: String(command.prefix(2)))
        let endPoint: Point = Point(point: String(command.suffix(2)))
        
        // 해당 타입의 말의 이동방식으로 갈 수있는 칸인지 검사 && 도착지까지의 루트에 아군말이 있는지 검사
        let isAvailable = check(from: startPoint, to: endPoint)
        
        // 말 이동
        if isAvailable {
            move(from: startPoint, to: endPoint)
        }
        
        // 턴 넘기기
        turn = turn == .white ? .black : .white

        return isAvailable
    }
    
    func check(from startPoint: Point, to endPoint: Point) -> Bool {
        // 해당 타입의 말의 이동방식으로 갈 수있는 칸인지 검사
        var isAvailable = board[startPoint.y][startPoint.x].checkMoving(from: startPoint, to: endPoint)
        // 도착지 전까지의 루트에 말이 있는지 검사 (아군/적군 있으면 이동 불가)
        isAvailable = checkRoute(from: startPoint, to: endPoint)
        // 도착지 상태 확인 (빈칸 / 아군 / 적군)
        isAvailable = checkEndpoint(point: endPoint)
        return isAvailable
    }

    // 도착지 상태 확인 (빈칸 / 아군 / 적군)
    func checkEndpoint(point: Point) -> Bool {
        var isAvailable: Bool
        
        let previousPiece: Piece = board[point.y][point.x]
        
        if previousPiece.type == .none { // 빈 칸
            isAvailable = true
        } else if previousPiece.color == turn { // 아군 말
            isAvailable = false
        } else { // 적군 말
            isAvailable = true
            print(showScore())
        }
        
        return isAvailable
    }
    
    // 도착지 전까지의 루트에 말이 있는지 검사 (아군/적군 있으면 이동 불가)
    func checkRoute(from startPoint: Point, to endPoint: Point) -> Bool {
        var isAvailable: Bool = true
        let piece = board[startPoint.y][startPoint.x]
        let route = piece.getRoute(from: startPoint, to: endPoint)
        
        route.forEach { point in
            if board[point.y][point.x].type != .none {
                isAvailable = false
                return
            }
        }
        
        return isAvailable
    }

    func move(from startPoint: Point, to endPoint: Point) {
        board[endPoint.y][endPoint.x] = board[startPoint.y][startPoint.x]
        board[startPoint.y][startPoint.x] = Piece(color: .none, type: .none)
    }
    
    func showScore() -> (Int, Int) {
        let flattenedArray = board.flatMap { $0 }
        let whiteScore = flattenedArray.filter { $0.color == .white }.map { $0.type.score }.reduce(0, +)
        let blackScore = flattenedArray.filter { $0.color == .black }.map { $0.type.score }.reduce(0, +)
        
        return (whiteScore, blackScore)
    }
}

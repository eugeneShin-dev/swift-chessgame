//
//  Chess.swift
//  Chess
//
//  Created by Hailey on 2022/06/20.
//

import Foundation

class Chess {
    private var board = [[Piece]](repeating: Array(repeating: Piece(color: .none, type: .none),count: 8), count: 8)
    private var turn: Color = .white
    
    init() {
        reset()
    }
    
    func reset() {
        let order: [PieceType] = [.luke, .knight, .bishop, .none, .queen, .bishop, .knight, .luke]
        
        board = [[Piece]](repeating: Array(repeating: Piece(color: .none, type: .none),count: 8), count: 8)
        
        for rank in 0..<8 {
            board[0][rank] = Piece(color: .black, type: order[rank])
            board[1][rank] = Piece(color: .black, type: .pawn)
            board[6][rank] = Piece(color: .white, type: .pawn)
            board[7][rank] = Piece(color: .white, type: order[rank])
        }
    }

    func getPiece(point: Point) -> Piece {
        return board[point.y][point.x.rawValue]
    }
    
    func display() -> String {
        var result = ""

        for file in 0..<8 {
            result += board[file].flatMap { $0.mark }
            result += file < 7 ? "\n" : ""
        }
        
        return result
    }
    
            }
        case .invalid:
            ChessError.showErrorMessage(errorType: .wrongCommand)
            return false
        }
    }

    func showGuide(startPoint: Point) -> [String] {
        let piece = board[startPoint.y][startPoint.x.rawValue]
        
        // 말이 갈 수 있는 포인트 중 막히지 않은 칸만 필터링
        let possiblePoints = piece.getPossiblePoints(startPoint: startPoint).filter { check(from: startPoint, to: $0, color: piece.color) && checkEndpoint(point: $0, color: piece.color) }
        let convertedPoints = possiblePoints.map { $0.convertToString() } // rank, file 형식으로 변형
        return convertedPoints
    }
    
    func performMoveAction(startPoint: Point, endPoint: Point) -> Bool {
        // 해당 타입의 말의 이동방식으로 갈 수있는 칸인지 검사 && 도착지까지의 루트에 아군말이 있는지 검사
        let isAvailable = check(from: startPoint, to: endPoint, color: turn)
        
        // 말 이동
        if isAvailable {
            move(from: startPoint, to: endPoint)
        }
        
        // 턴 넘기기
        turn = turn == .white ? .black : .white

        return isAvailable
    }
    
    func check(from startPoint: Point, to endPoint: Point, color: Color) -> Bool {
        return board[startPoint.y][startPoint.x.rawValue].checkMoving(from: startPoint, to: endPoint) // 해당 타입의 말의 이동방식으로 갈 수있는 칸인지 검사
            && checkRoute(from: startPoint, to: endPoint) // 도착지 전까지의 루트에 말이 있는지 검사 (아군/적군 있으면 이동 불가)
            && checkEndpoint(point: endPoint, color: color) // 도착지 상태 확인 (빈칸 / 아군 / 적군)
    }

    // 도착지 상태 확인 (빈칸 / 아군 / 적군)
    func checkEndpoint(point: Point, color: Color) -> Bool {
        var isAvailable: Bool
        
        let previousPiece: Piece = board[point.y][point.x.rawValue]
        
        if previousPiece.type == .none { // 빈 칸
            isAvailable = true
        } else if previousPiece.color == color { // 아군 말
            isAvailable = false
        } else { // 적군 말
            isAvailable = true
        }
    
        return isAvailable
    }
    
    // 도착지 전까지의 루트에 말이 있는지 검사 (아군/적군 있으면 이동 불가)
    func checkRoute(from startPoint: Point, to endPoint: Point) -> Bool {
        var isAvailable: Bool = true
        let piece = board[startPoint.y][startPoint.x.rawValue]
        let route = piece.getRoute(from: startPoint, to: endPoint)
        
        for point in route {
            if board[point.y][point.x.rawValue].type != .none {
                isAvailable = false
                break
            }
        }

        return isAvailable
    }

    func move(from startPoint: Point, to endPoint: Point) {
        board[endPoint.y][endPoint.x.rawValue] = board[startPoint.y][startPoint.x.rawValue]
        board[startPoint.y][startPoint.x.rawValue] = Piece(color: .none, type: .none)
    }
    
    func showScore() -> (Int, Int) {
        let flattenedArray = board.flatMap { $0 }
        let whiteScore = flattenedArray.filter { $0.color == .white }.map { $0.type.score }.reduce(0, +)
        let blackScore = flattenedArray.filter { $0.color == .black }.map { $0.type.score }.reduce(0, +)
        
        return (whiteScore, blackScore)
    }
}

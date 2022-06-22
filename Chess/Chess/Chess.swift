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
    
    func display() -> String {
        var result = ""

        for file in 0..<8 {
            result += board[file].flatMap { $0.mark }
            result += file < 7 ? "\n" : ""
        }
        
        return result
    }
    
    func perform(command: String) -> Bool {
        guard let commandData = CommandManager.getActionData(command: command) else { return false }

        switch commandData.type {
        case .guide:
            if let data = commandData.data as? GuideData, let startPoint = data.startPoint {
                print(showGuide(startPoint: startPoint))
                return true
            } else {
                return false
            }
        case .move:
            if let data = commandData.data as? MoveData, let startPoint = data.startPoint, let endPoint = data.endPoint {
                return performMoveAction(startPoint: startPoint, endPoint: endPoint)
            } else {
                return false
            }
        case .invalid:
            ChessError.showErrorMessage(errorType: .wrongCommand)
            return false
        }
    }

    private func showGuide(startPoint: Point) -> [String] {
        let piece = board[startPoint.y][startPoint.x]
        
        // 말이 갈 수 있는 포인트 중 막히지 않은 칸만 필터링
        let possiblePoints = piece.getPossiblePoints(startPoint: startPoint).filter { check(from: startPoint, to: $0) && checkEndpoint(point: $0) }
        let convertedPoints = possiblePoints.map { $0.convertToString() } // rank, file 형식으로 변형
        return convertedPoints
    }
    
    private func performMoveAction(startPoint: Point, endPoint: Point) -> Bool {
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
    
    private func check(from startPoint: Point, to endPoint: Point) -> Bool {
        // 해당 타입의 말의 이동방식으로 갈 수있는 칸인지 검사
        var isAvailable = board[startPoint.y][startPoint.x].checkMoving(from: startPoint, to: endPoint)
        // 도착지 전까지의 루트에 말이 있는지 검사 (아군/적군 있으면 이동 불가)
        isAvailable = checkRoute(from: startPoint, to: endPoint)
        // 도착지 상태 확인 (빈칸 / 아군 / 적군)
        isAvailable = checkEndpoint(point: endPoint)
        return isAvailable
    }

    // 도착지 상태 확인 (빈칸 / 아군 / 적군)
    private func checkEndpoint(point: Point) -> Bool {
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
    private func checkRoute(from startPoint: Point, to endPoint: Point) -> Bool {
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

    private func move(from startPoint: Point, to endPoint: Point) {
        board[endPoint.y][endPoint.x] = board[startPoint.y][startPoint.x]
        board[startPoint.y][startPoint.x] = Piece(color: .none, type: .none)
    }
    
    private func showScore() -> (Int, Int) {
        let flattenedArray = board.flatMap { $0 }
        let whiteScore = flattenedArray.filter { $0.color == .white }.map { $0.type.score }.reduce(0, +)
        let blackScore = flattenedArray.filter { $0.color == .black }.map { $0.type.score }.reduce(0, +)
        
        return (whiteScore, blackScore)
    }
}

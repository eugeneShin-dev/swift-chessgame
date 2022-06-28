//
//  Chess.swift
//  Chess
//
//  Created by Hailey on 2022/06/20.
//

import Foundation

protocol ChessDelegate {
    func selectPoint()
    func showScore(whiteScore: Int, blackScore: Int)
}

class Chess {

    var delegate: ChessDelegate?

    private var board = [[Piece]](repeating: Array(repeating: Piece(color: .none, type: .none, isCandidate: false), count: 8), count: 8)
    private var turn: Color = .white
    private var startPoint: Point?
    
    init() {
        reset()
    }
    
    func reset() {
        let order: [PieceType] = [.luke, .knight, .bishop, .none, .queen, .bishop, .knight, .luke]

        for file in 2..<7 {
            for rank in 0..<8 {
                board[file][rank].color = .none
                board[file][rank].type = .none
            }
        }

        for rank in 0..<8 {
            board[0][rank].color = .black
            board[0][rank].type = order[rank]
            board[1][rank].color = .black
            board[1][rank].type = .pawn
            board[6][rank].color = .white
            board[6][rank].type = .pawn
            board[7][rank].color = .white
            board[7][rank].type = order[rank]
        }
    }

    func getPiece(of point: Point) -> Piece {
        return board[point.y][point.x.rawValue]
    }

    func selectPoint(point: Point) throws {
        let selectedPiece = getPiece(of: point)

        if selectedPiece.color != turn {
            if startPoint == nil { // 시작 시 잘못된 칸 선택 : 빈칸 or 상대
                throw ChessError.wrongPointSelected
            } else if selectedPiece.isCandidate { // 가능한 endPoint 선택
                removeCandidates()
                if let score = getScoreAfterMovement(endPoint: point) { // 상대말 선택
                    delegate?.showScore(whiteScore: score.white, blackScore: score.black)
                } else { // 빈 칸 선택
                    delegate?.selectPoint()
                }
            }
        } else { // 새로운 아군말 선택
            removeCandidates()
            try selectStartPoint(point)
            delegate?.selectPoint()
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

    private func selectStartPoint(_ point: Point) throws {
        startPoint = point
        getCandidatePoints(startPoint: point)
    }

    private func getScoreAfterMovement(endPoint: Point) -> (white: Int, black: Int)? {
        var score: (Int, Int)?
        let pieceOfEndPoint = getPiece(of: endPoint)
        let didCatch = pieceOfEndPoint.color != .none

        if let startPoint = startPoint {
            move(from: startPoint, to: endPoint)
            changeTurn()

            if didCatch {
                score = getScore()
            }
        }

        return score
    }

    private func getScore() -> (white: Int, black: Int) {
        let flattenedArray = board.flatMap { $0 }
        let whiteScore = flattenedArray.filter { $0.color == .white }.map { $0.type.score }.reduce(0, +)
        let blackScore = flattenedArray.filter { $0.color == .black }.map { $0.type.score }.reduce(0, +)

        return (whiteScore, blackScore)
    }

    private func getCandidatePoints(startPoint: Point) {
        let piece = board[startPoint.y][startPoint.x.rawValue]

        // 말이 갈 수 있는 포인트 중 막히지 않은 칸만 필터링
        let possiblePoints = piece.getPossiblePoints(startPoint: startPoint).filter { check(from: startPoint, to: $0, color: piece.color) && checkEndpoint(point: $0, color: piece.color) }
        possiblePoints.forEach {
            board[$0.y][$0.x.rawValue].isCandidate = true

        }
    }

    private func check(from startPoint: Point, to endPoint: Point, color: Color) -> Bool {
        return board[startPoint.y][startPoint.x.rawValue].checkMoving(from: startPoint, to: endPoint) // 해당 타입의 말의 이동방식으로 갈 수있는 칸인지 검사
            && checkRoute(from: startPoint, to: endPoint) // 도착지 전까지의 루트에 말이 있는지 검사 (아군/적군 있으면 이동 불가)
            && checkEndpoint(point: endPoint, color: color) // 도착지 상태 확인 (빈칸 / 아군 / 적군)
    }

    // 도착지 상태 확인 (빈칸 / 아군 / 적군)
    private func checkEndpoint(point: Point, color: Color) -> Bool {
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
    private func checkRoute(from startPoint: Point, to endPoint: Point) -> Bool {
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

    private func move(from startPoint: Point, to endPoint: Point) {
        board[endPoint.y][endPoint.x.rawValue] = board[startPoint.y][startPoint.x.rawValue]
        board[startPoint.y][startPoint.x.rawValue].color = .none
        board[startPoint.y][startPoint.x.rawValue].type = .none
    }

    private func changeTurn() {
        startPoint = nil
        turn = turn == .white ? .black : .white
    }

    private func removeCandidates() {
        (0..<8).forEach { y in
            (0..<8).forEach { x in
                board[y][x].isCandidate = false
            }
        }
    }
}

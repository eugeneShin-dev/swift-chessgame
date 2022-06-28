//
//  Piece.swift
//  Chess
//
//  Created by Hailey on 2022/06/20.
//

import UIKit

enum Color {
    case black, white, none
}

enum PieceType {
    case pawn
    case knight
    case bishop
    case luke
    case queen
    case none
    
    var score: Int {
        switch self {
        case .pawn:
            return 1
        case .knight:
            return 3
        case .bishop:
            return 3
        case .luke:
            return 5
        case .queen:
            return 9
        case .none:
            return 0
        }
    }
    
    var moveLimit: Int { // 폰인 경우 한 번만 이동하도록
        if self == .pawn {
            return 1
        } else {
            return 7
        }
    }
    
    var getOffsetX: [Int] {
        switch self {
        case .pawn:
            return [0]
        case .knight:
            return []
        case .bishop:
            return [-1, -1, 1, 1]
        case .luke:
            return [-1, 0, 1, 0]
        case .queen:
            return []
        case .none:
            return []
        }
    }
    
    func getOffsetY(color: Color) -> [Int] {
        switch self {
        case .pawn:
            // 화이트폰과 블랙폰의 방향이 다르므로
            if color == .white {
                return [-1]
            } else {
                return [1]
            }
        case .knight:
            return []
        case .bishop:
            return [-1, 1, -1, 1]
        case .luke:
            return [0, -1, 0, 1]
        case .queen:
            return []
        case .none:
            return []
        }
    }
}

struct Piece: Equatable {

    var color: Color = .none
    var type: PieceType = .none
    var isCandidate: Bool = false
    
    var mark: String {
        switch type {
        case .pawn:
            return color == .white ? "\u{2659}" : "\u{265F}"
        case .knight:
            return color == .white ? "\u{2658}" : "\u{265E}"
        case .bishop:
            return color == .white ? "\u{2657}" : "\u{265D}"
        case .luke:
            return color == .white ? "\u{2656}" : "\u{265C}"
        case .queen:
            return color == .white ? "\u{2655}" : "\u{265B}"
        case .none:
            return ""
        }
    }

    init(color: Color, type: PieceType, isCandidate: Bool) {
        self.color = color
        self.type = type
        self.isCandidate = isCandidate
    }
    
    // 갈 수 있는 모든 칸 찾기 (현재 보드판 상황과 무관)
    func getPossiblePoints(startPoint: Point) -> [Point] {
        var possiblePoints: [Point] = []
        let count = max(type.getOffsetX.count, type.getOffsetY(color: color).count) // 말이 갈 수 있는 방향 개수
        
        for index in 0..<count { // 각 방향마다 탐색
            var nextPosition = startPoint
            
            for _ in 0..<type.moveLimit {
                do {
                    try nextPosition.move(offsetX: type.getOffsetX[index], offsetY: type.getOffsetY(color: color)[index])
                    possiblePoints.append(nextPosition)
                } catch {
                    break
                }
            }
        }
        
        return possiblePoints
    }
    
    // 해당 타입의 말이 갈 수 있는 칸(도착지)인지 검사
    func checkMoving(from startPoint: Point, to endPoint: Point) -> Bool {
        let possiblePoints: [Point] = getPossiblePoints(startPoint: startPoint)
        return possiblePoints.contains(endPoint)
    }
    
    // 도착지까지의 경로 찾기
    func getRoute(from startPoint: Point, to endPoint: Point) -> [Point] {
        var route: [Point] = []

        var offsetY = endPoint.y - startPoint.y
        
        if abs(offsetY) > 1 {
            offsetY = offsetY / abs(offsetY)
        }

        var offsetX = endPoint.x - startPoint.x
        
        if abs(offsetX) > 1 {
            offsetX = offsetX / abs(offsetX)
        }

        var nextPoint = startPoint
        
        while(nextPoint != endPoint) {
            do {
                try nextPoint.move(offsetX: offsetX, offsetY: offsetY)
            } catch {
                break
            }

            if nextPoint != endPoint {
                route.append(nextPoint)
            }            
        }
        
        return route
    }
}

//
//  Piece.swift
//  Chess
//
//  Created by Hailey on 2022/06/20.
//

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

class Piece {

    var color: Color = .none
    var type: PieceType = .none
    
    lazy var mark: String = {
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
            return "."
        }
    }()

    init(color: Color, type: PieceType) {
        self.color = color
        self.type = type
    }
    
    // 갈 수 있는 모든 칸 찾기 (현재 보드판 상황과 무관)
    func getPossiblePoints(startPoint: Point) -> [Point] {
        var possiblePoints: [Point] = []
        let count = max(type.getOffsetX.count, type.getOffsetY(color: color).count) // 말이 갈 수 있는 방향 개수
        
        for index in 0..<count { // 각 방향마다 탐색
            var nextPosition = startPoint
            
            for _ in 0..<type.moveLimit {
                guard nextPosition.move(offsetX: type.getOffsetX[index], offsetY: type.getOffsetY(color: color)[index]) else { break }
                possiblePoints.append(nextPosition)
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

        let offsetY = startPoint.y - endPoint.y
        let directionY = offsetY / abs(offsetY)

        let offsetX = startPoint.x - endPoint.x
        let directionX = offsetX / abs(offsetX)
        
        var nextPoint = startPoint
        
        while(nextPoint != endPoint) {
            guard nextPoint.move(offsetX: directionY, offsetY: directionX) else { break }

            if nextPoint != endPoint {
                route.append(nextPoint)
            }            
        }
        
        return route
    }
}

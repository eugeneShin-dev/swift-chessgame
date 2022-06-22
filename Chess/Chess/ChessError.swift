//
//  ChessError.swift
//  Chess
//
//  Created by Hailey on 2022/06/22.
//

struct ChessError {
    enum ErrorType {
        case wrongCommand
        case invalidCoordinate
        
        var message: String {
            switch self {
            case .wrongCommand:
                return "잘못된 명령어입니다."
            case .invalidCoordinate:
                return "잘못된 좌표를 입력했습니다."
            }
        }
    }
    
    static func showErrorMessage(errorType: ErrorType) {
        print(errorType.message)
    }
}

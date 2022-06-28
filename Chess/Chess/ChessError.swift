//
//  ChessError.swift
//  Chess
//
//  Created by Hailey on 2022/06/22.
//

enum ChessError: Error {
    case wrongCommand
    case wrongPointSelected

    var message: String {
        switch self {
        case .wrongCommand:
            return "잘못된 명령어입니다."
        case .wrongPointSelected:
            return "잘못된 칸을 선택했습니다."
        }
    }
}

//
//  Command.swift
//  Chess
//
//  Created by Hailey on 2022/06/22.
//

protocol ActionData {}

struct GuideData: ActionData {

    var startPoint: Point

    init?(command: String) {
        let pointString = String(command.suffix(2))
        
        if let point = Point(string: pointString) {
            self.startPoint = point
        } else {
            return nil
        }
    }
}

struct MoveData: ActionData {

    var startPoint: Point
    var endPoint: Point
    
    init?(command: String) {
        let startPointString = String(command.prefix(2))
        let endPointString = String(command.suffix(2))
        
        if let startPoint = Point(string: startPointString), let endPoint = Point(string: endPointString) {
            self.startPoint = startPoint
            self.endPoint = endPoint
        } else {
            return nil
        }
    }
}

struct CommandManager {
    
    enum CommandType: Int {
        case guide
        case move
        case invalid

        init(command: String) {
            if command.first == "?" && command.count == 3 {
                self = .guide
            } else if command.contains("->")  && command.count == 6 {
                self = .move
            } else {
                self = .invalid
            }
        }
    }
    
    typealias CommandData = (type: CommandType, data: ActionData?)
    
    static func getActionData(command: String) -> CommandData? {
        let commandType = CommandType(command: command)

        switch commandType {
        case .guide:
            return CommandData(type: commandType, data: GuideData(command: command))
        case .move:
            return CommandData(type: commandType, data: MoveData(command: command))
        case .invalid:
            ChessError.showErrorMessage(errorType: .wrongCommand)
            return nil
        }
    }
}

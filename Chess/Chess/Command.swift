//
//  Command.swift
//  Chess
//
//  Created by Hailey on 2022/06/22.
//

protocol ActionData {}

struct GuideData: ActionData {
    var startPoint: Point?

    init(command: String) {
        let pointString = String(command.suffix(2))

        if verifyFormat(pointString: command) {
            self.startPoint = Point(string: pointString)
        }
    }

    private func verifyFormat(pointString: String) -> Bool {
        return Point.checkCoordinate(string: pointString)
    }
}

struct MoveData: ActionData {
    
    var startPoint: Point?
    var endPoint: Point?
    
    init(command: String) {
        let startPointString = String(command.prefix(2))
        let endPointString = String(command.suffix(2))

        if verifyFormat(startPointString: startPointString, endPointString: endPointString) {
            self.startPoint = Point(string: startPointString)
            self.endPoint = Point(string: endPointString)
        }
    }
    
    private func verifyFormat(startPointString: String, endPointString: String) -> Bool {
        return Point.checkCoordinate(string: startPointString) && Point.checkCoordinate(string: endPointString)
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
    
    typealias CommandData = (type: CommandType, data: ActionData)
    
    static func getActionData(command: String) -> CommandData? {
        let commandType = CommandType(command: command)

        switch commandType {
        case .guide:
            return (type: commandType, data: GuideData(command: command))
        case .move:
            return (type: commandType, data: MoveData(command: command))
        case .invalid:
            ChessError.showErrorMessage(errorType: .wrongCommand)
            return nil
        }
    }
}

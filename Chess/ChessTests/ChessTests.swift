//
//  ChessTests.swift
//  ChessTests
//
//  Created by Hailey on 2022/06/20.
//

import XCTest
@testable import Chess

class ChessTests: XCTestCase {
    
    private var sut: Chess!

    // 테스트 케이스 1개가 시작되기 전에 한번 실행되는 함수
    // 테스트 케이스 시행되기 전 특정 상태를 지정할 때 사용
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = Chess()
    }

    // 테스트 케이스 1개가 끝나면 한번 실행됨
    // 모든 테스트 함수가 종료된 후 정리를 할 때 사용
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let chess = Chess()
        let board = """
                    ♜♞♝.♛♝♞♜
                    ♟♟♟♟♟♟♟♟
                    ........
                    ........
                    ........
                    ........
                    ♙♙♙♙♙♙♙♙
                    ♖♘♗.♕♗♘♖
                    """
        XCTAssertEqual(chess.display(), board)
    }

    func testPointMethods() {
        XCTAssertEqual(Point.convertIndexToPoint(8), Point(y: 1, x: .A))
        XCTAssertEqual(Point.convertPointToIndex(Point(y: 1, x: .A)), 8)
        XCTAssertEqual(Point.convertPointToIndex(Point(y: 1, x: .H)), 15)
    }

    func testGettingPiece() {
        let chess = Chess()
        guard let point1 = Point(string: "A1") else { return }
        XCTAssertEqual(chess.getPiece(of: point1), Piece(color: .black, type: .luke, isCandidate: false))
    }

    func testSelectingWrongPointInInitial() {
        let chess = Chess()
        guard let pointWithWrongColor = Point(string: "B1") else { return }
        XCTAssertThrowsError(try chess.selectPoint(point: pointWithWrongColor))

        guard let emptyPoint = Point(string: "C5") else { return }
        XCTAssertThrowsError(try chess.selectPoint(point: emptyPoint))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBoardInitialization() {
        
    }

}

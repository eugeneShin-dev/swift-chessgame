//
//  ViewController.swift
//  Chess
//
//  Created by Hailey on 2022/06/20.
//

import AVFoundation
import UIKit

class ViewController: UIViewController, ChessDelegate {

    // MARK: - Property

    private let chess: Chess = Chess()

    // MARK: - UI Componen

    private let collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.layer.borderWidth = 6
        collectionView.layer.borderColor = UIColor.black.cgColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        chess.delegate = self
        configureCollectionView()
        setuputoLayout()
        prepareChessBoard()
    }

    // MARK: - Private Method

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SquareCell.self, forCellWithReuseIdentifier: SquareCell.reuseIdentifier)
    }

    private func setuputoLayout() {
        view.addSubview(collectionView)

        let boardSize: CGFloat = view.frame.width - 10

        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: boardSize),
            collectionView.heightAnchor.constraint(equalToConstant: boardSize),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func prepareChessBoard() {
        chess.reset()
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - ChessDelegate

    func showScore(whiteScore: Int, blackScore: Int) {
        collectionView.reloadData()
        showAlert(title: "점수 확인", message: "백 \(whiteScore) : 흑 \(blackScore)")
    }


    func selectPoint() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 64
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SquareCell.reuseIdentifier, for: indexPath) as? SquareCell else { return UICollectionViewCell() }

        if let point =  Point.convertIndexToPoint(indexPath.row) {
            cell.update(point: point, piece: chess.getPiece(of: point))
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedPoint = Point.convertIndexToPoint(indexPath.row) {
            do {
                try chess.selectPoint(point: selectedPoint)
            } catch ChessError.wrongPointSelected {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                showAlert(title: "경고", message: "잘못된 칸을 선택하셨습니다.")
            } catch {
                print(error)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 8
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension Point {
    static func convertIndexToPoint(_ index: Int) -> Point? {
        let y = index / 8
        let x = index % 8
        return try? Point(y: y, x: x)
    }

    static func convertPointToIndex(_ point: Point) -> Int {
        return point.y * 8 + (point.x.rawValue + (8 * (point.x.rawValue / 8)))
    }
}

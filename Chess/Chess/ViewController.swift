//
//  ViewController.swift
//  Chess
//
//  Created by Hailey on 2022/06/20.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Property

    private let chess: Chess = Chess()

    // MARK: - UI Componen

    private let collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
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
}

// MARK: - UICollectionViewDelegates
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 64
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SquareCell.reuseIdentifier, for: indexPath) as? SquareCell else { return UICollectionViewCell() }

        let index = indexPath.row
        let y = index / 8
        let x = index % 8

        if let point = try? Point(y: y, x: x) {
            cell.update(point: point, piece: chess.getPiece(point: point))
        }
        return cell
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

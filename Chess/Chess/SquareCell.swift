//
//  BoardView.swift
//  Chess
//
//  Created by Hailey on 2022/06/27.
//

import UIKit

class SquareCell: UICollectionViewCell {

    static let reuseIdentifier: String = "SquareCell"

    // MARK: - UI Components

    private let markLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Public Method

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(point: Point, piece: Piece) {
        contentView.backgroundColor = getBackgroundColor(of: point)
        markLabel.text = piece.mark
    }

    // MARK: - Private Method

    private func setupAutoLayout() {
        contentView.addSubview(markLabel)

        NSLayoutConstraint.activate([
            markLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            markLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func getBackgroundColor(of point: Point) -> UIColor {
        if point.y % 2 == 0 {
            return point.x.rawValue % 2 == 0 ? .white : .brown
        } else {
            return point.x.rawValue % 2 == 0 ? .brown : .white
        }
    }
}

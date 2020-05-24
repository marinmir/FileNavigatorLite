//
//  DowlnloadAllCell.swift
//  FileNavigatorLite
//
//  Created by Мирошниченко Марина on 23.05.2020.
//  Copyright © 2020 Мирошниченко Марина. All rights reserved.
//

import UIKit

class DownloadAllCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "DownloadAllCell"
    
    private let downloadAllLabel = UILabel()
    
    // MARK: - Public methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: DownloadAllCell.identifier)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setConstraints() -> Void {
        downloadAllLabel.translatesAutoresizingMaskIntoConstraints = false
        downloadAllLabel.text = "Download all"
        downloadAllLabel.textColor = .systemBlue
        downloadAllLabel.textAlignment = .center
        contentView.addSubview(downloadAllLabel)
        
        NSLayoutConstraint.activate([
            downloadAllLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            downloadAllLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            downloadAllLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            downloadAllLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}

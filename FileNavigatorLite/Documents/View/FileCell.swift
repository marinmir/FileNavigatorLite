//
//  FileCell.swift
//  FileNavigatorLite
//
//  Created by Мирошниченко Марина on 24.05.2020.
//  Copyright © 2020 Мирошниченко Марина. All rights reserved.
//

import UIKit

class FileCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "FileCell"
    
    private let fileNameLabel = UILabel()
    private let fileSizeLabel = UILabel()
    
    // MARK: - Public methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: FileCell.identifier)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(fileName: String, fileSize: String, fileUrl: URL) {
        fileNameLabel.text = fileName
        fileSizeLabel.text = "Size: \(fileSize) bytes"
        
        let controller = UIDocumentInteractionController(url: fileUrl)
        imageView?.image = controller.icons[0]
    }
    
    // MARK: - Private methods
    private func setConstraints() -> Void {
        fileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fileNameLabel.textAlignment = .left
        fileNameLabel.lineBreakMode = .byWordWrapping
        fileNameLabel.numberOfLines = 4
        contentView.addSubview(fileNameLabel)
        
        fileSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        fileSizeLabel.textAlignment = .left
        fileSizeLabel.numberOfLines = 1
        contentView.addSubview(fileSizeLabel)
        
        NSLayoutConstraint.activate([
            fileNameLabel.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: 4),
            fileNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            fileNameLabel.bottomAnchor.constraint(equalTo: fileSizeLabel.topAnchor, constant: -4),
            fileNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            fileSizeLabel.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: 4),
            fileSizeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            fileSizeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }
}

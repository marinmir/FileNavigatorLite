//
//  URLCell.swift
//  FileNavigatorLite
//
//  Created by Мирошниченко Марина on 23.05.2020.
//  Copyright © 2020 Мирошниченко Марина. All rights reserved.
//

import UIKit

class URLCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "URLCell"
    let indicator = UIActivityIndicatorView()
    
    private let urlLabel = UILabel()
    
    // MARK: - Public methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: URLCell.identifier)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(url: String) {
        urlLabel.text = url
    }
    
    // MARK: - Private methods
    private func setConstraints() -> Void {
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        urlLabel.textAlignment = .left
        urlLabel.lineBreakMode = .byWordWrapping
        urlLabel.numberOfLines = 5
        contentView.addSubview(urlLabel)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        contentView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            urlLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            urlLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            urlLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            urlLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            indicator.leadingAnchor.constraint(equalTo: urlLabel.trailingAnchor, constant: 4),
            indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}

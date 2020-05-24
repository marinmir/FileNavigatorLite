//
//  DownloadView.swift
//  FileNavigatorLite
//
//  Created by Мирошниченко Марина on 23.05.2020.
//  Copyright © 2020 Мирошниченко Марина. All rights reserved.
//

import UIKit

class DownloadView: UIView {
    // MARK: - Properties
    let urlsTable = UITableView(frame: CGRect.zero, style: .plain)
    private weak var vc: DownloadViewController?
    
    // MARK: - Public methods
    init(viewController vc: DownloadViewController) {
        self.vc = vc
        
        super.init(frame: CGRect.zero)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setConstraints() {
        backgroundColor = UIColor.white
           
        urlsTable.translatesAutoresizingMaskIntoConstraints = false
        urlsTable.dataSource = vc
        urlsTable.delegate = vc
        urlsTable.register(URLCell.self, forCellReuseIdentifier: URLCell.identifier)
        urlsTable.register(DownloadAllCell.self, forCellReuseIdentifier: DownloadAllCell.identifier)
        addSubview(urlsTable)

           NSLayoutConstraint.activate([
            urlsTable.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            urlsTable.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            urlsTable.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
               urlsTable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(vc!.tabBarController?.tabBar.frame.height ?? 0))
           ])
    }
}

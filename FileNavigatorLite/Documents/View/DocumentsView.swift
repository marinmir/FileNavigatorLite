//
//  DocumentsView.swift
//  FileNavigatorLite
//
//  Created by Мирошниченко Марина on 24.05.2020.
//  Copyright © 2020 Мирошниченко Марина. All rights reserved.
//

import UIKit

class DocumentsView: UIView {
    // MARK: - Properties
    let filesTable = UITableView(frame: CGRect.zero, style: .plain)
    private weak var vc: DocumentsViewController?
    
    // MARK: - Public methods
    init(viewController vc: DocumentsViewController) {
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
           
        filesTable.translatesAutoresizingMaskIntoConstraints = false
        filesTable.dataSource = vc
        filesTable.delegate = vc
        filesTable.register(FileCell.self, forCellReuseIdentifier: FileCell.identifier)
        addSubview(filesTable)

        NSLayoutConstraint.activate([
            filesTable.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            filesTable.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            filesTable.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            filesTable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(vc!.tabBarController?.tabBar.frame.height ?? 0))
       ])
    }
}

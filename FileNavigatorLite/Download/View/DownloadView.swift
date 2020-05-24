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
    let URLSTable = UITableView(frame: CGRect.zero, style: .plain)
    private weak var vc: DownloadViewController?
    
    // MARK: - Public methods
    init(viewController vc: DownloadViewController) {
        self.vc = vc
        
        super.init(frame: CGRect.zero)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setConstraint() {
        backgroundColor = UIColor.white
           
        URLSTable.translatesAutoresizingMaskIntoConstraints = false
        URLSTable.dataSource = vc
        URLSTable.delegate = vc
        URLSTable.register(URLCell.self, forCellReuseIdentifier: URLCell.identifier)
        URLSTable.register(DownloadAllCell.self, forCellReuseIdentifier: DownloadAllCell.identifier)
        addSubview(URLSTable)

           NSLayoutConstraint.activate([
            URLSTable.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            URLSTable.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            URLSTable.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
               URLSTable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(vc!.tabBarController?.tabBar.frame.height ?? 0))
           ])
    }
}

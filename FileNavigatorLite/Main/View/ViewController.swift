//
//  ViewController.swift
//  FileNavigatorLite
//
//  Created by Мирошниченко Марина on 23.05.2020.
//  Copyright © 2020 Мирошниченко Марина. All rights reserved.
//

import UIKit

class ViewController: UITabBarController, UITabBarControllerDelegate {
    // MARK: - Properties
    private let documentsTabController = DocumentsViewController()
    private let downloadTabController = DownloadViewController()

    // MARK: - Public methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        delegate = self
        createTabBarItems()
        viewControllers = [documentsTabController, downloadTabController]
    }

    // MARK: - Private methods
    private func createTabBarItems() {
        documentsTabController.title = "Documents"
        let documentsTabItem = UITabBarItem(title: "Documents", image: UIImage(named: "Documents"), selectedImage: UIImage(named: "Documents"))
        documentsTabController.tabBarItem = documentsTabItem
        
        downloadTabController.title = "Download"
        let downloadTabItem = UITabBarItem(title: "Download", image: UIImage(named: "Download"), selectedImage: UIImage(named: "Download"))
        downloadTabController.tabBarItem = downloadTabItem
    }
    
}

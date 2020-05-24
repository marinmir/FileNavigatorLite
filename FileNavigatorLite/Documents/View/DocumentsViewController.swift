//
//  DocumentsController.swift
//  FileNavigatorLite
//
//  Created by Мирошниченко Марина on 23.05.2020.
//  Copyright © 2020 Мирошниченко Марина. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController {
    // MARK: - Properties
    private var files: [FileModel] = []
    
    // MARK: - Public methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view = DocumentsView(viewController: self)
        getNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Private methods
    private func getNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleFileNotification(_:)), name: NSNotification.Name(rawValue: Constants.notificationFileName), object: nil)
    }
    
    // handle notification
    @objc private func handleFileNotification(_ notification: NSNotification) {
           if let dict = notification.userInfo as NSDictionary? {
               if let item = dict["file"] {
                files.append(item as! FileModel)
                
                
                DispatchQueue.main.async { [weak self] in
                    guard let view = self?.view as? DocumentsView else {
                        return
                    }
                    view.filesTable.reloadData()
                }

               }
           }
    }
    
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FileCell()
        cell.setContent(fileName: files[indexPath.row].name, fileSize: String(files[indexPath.row].size))
        return cell
    }
    
    
}

//
//  DocumentsController.swift
//  FileNavigatorLite
//
//  Created by Мирошниченко Марина on 23.05.2020.
//  Copyright © 2020 Мирошниченко Марина. All rights reserved.
//

import UIKit
import QuickLook

class DocumentsViewController: UIViewController {
    // MARK: - Properties
    private var files: [FileModel] = []
    private lazy var previewItem = NSURL()
    
    // MARK: - Public methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view = DocumentsView(viewController: self)
        setNotificationListener()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Private methods
    private func setNotificationListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleFileNotification(_:)), name: NSNotification.Name(rawValue: Constants.notificationFileName), object: nil)
    }
    
    @objc private func handleFileNotification(_ notification: NSNotification) {
       if let dict = notification.userInfo as NSDictionary? {
           if let items = dict["files"] as? [FileModel] {
            files.append(contentsOf: items)
            
            DispatchQueue.main.async { [weak self] in
                guard let view = self?.view as? DocumentsView else {
                    return
                }
                view.filesTable.reloadData()
            }
           }
       }
    }
    
    private func displayFile(index: Int) {
        let qlController = QLPreviewController()
        qlController.dataSource = self
        qlController.providesPresentationContextTransitionStyle = true
        qlController.definesPresentationContext = true
        qlController.modalPresentationStyle = .overCurrentContext
        qlController.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        qlController.currentPreviewItemIndex = index
        self.present(qlController, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FileCell()
        cell.setContent(fileName: files[indexPath.row].name, fileSize: String(files[indexPath.row].size), fileUrl: files[indexPath.row].url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayFile(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - QLPreviewControllerDataSource
extension DocumentsViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return files.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        previewItem = NSURL(fileURLWithPath: files[index].url.path)
        return self.previewItem as QLPreviewItem
    }
    
}

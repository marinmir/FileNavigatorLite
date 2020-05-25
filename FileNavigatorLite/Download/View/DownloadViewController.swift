//
//  DownloadViewController.swift
//  FileNavigatorLite
//
//  Created by Мирошниченко Марина on 23.05.2020.
//  Copyright © 2020 Мирошниченко Марина. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController {
    // MARK: - Properties
    private var urls: [URL] = []
    private var filesWereDownloaded: [Bool] = []
    private var clickedDownloadAll = false
    private var loadedFiles: [FileModel] = []
    
    // MARK: - Public methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view = DownloadView(viewController: self)

        getUrls()
        filesWereDownloaded = [Bool](repeating: false, count: urls.count)
    }
    
    // MARK: Private methods
    private func getUrls() {
        guard let urlPlist = Bundle.main.url(forResource: "URLS", withExtension: "plist"),
            let contents = try? Data(contentsOf: urlPlist),
            let serial = try? PropertyListSerialization.propertyList(
                                  from: contents,
                                  format: nil),
            let serialUrls = serial as? [String: String] else {
                print("Something went wrong!")
                return
        }
        urls = serialUrls.values.compactMap(URL.init)
    }
    
    private func downloadFile(index: Int, shouldPostNotification: Bool = true) {
        DispatchQueue.main.async {
            guard let view = self.view as? DownloadView,
                let cell = view.urlsTable.cellForRow(at: IndexPath(row: index, section: 0)) as? URLCell else {
                    return
            }
            cell.indicator.startAnimating()
        }
        
        guard let loadedItem = try? Data(contentsOf: self.urls[index]) else {
            return
        }
        
        let fullUrl = self.getFileUrl(fileUrl: self.urls[index])
        self.saveFile(fullUrl: fullUrl, loadedItem: loadedItem)
        
        let file = self.createFileModel(URL: fullUrl, name: self.urls[index].lastPathComponent, size: Double(loadedItem.count))
        self.loadedFiles.append(file)
        
        if shouldPostNotification {
            self.postNotification(items: self.loadedFiles)
        }
        
        DispatchQueue.main.async {
            guard let view = self.view as? DownloadView,
                let cell = view.urlsTable.cellForRow(at: IndexPath(row: index, section: 0)) as? URLCell else {
                    return
            }
            cell.indicator.stopAnimating()
        }
        
    }
    
    private func saveFile(fullUrl: URL, loadedItem: Data) {
        try? loadedItem.write(to: fullUrl, options: .atomic)
    }
    
    private func getFileUrl(fileUrl: URL) -> URL {
        let localUrl = fileUrl.lastPathComponent
        
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            assert(false)
            return URL(fileURLWithPath: "")
        }
        return dir.appendingPathComponent(localUrl)
    }
    
    private func postNotification(items: [FileModel]) {
        let notificationData = ["files" : items]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.notificationFileName), object: nil, userInfo: notificationData)
    }
    
    private func createFileModel(URL: URL, name: String, size: Double) -> FileModel {
        return FileModel(url: URL, name: name, size: size)
    }
    
    private func showAlertAlreadyDownoaded(with text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func wasDownloadedFile(index: Int) -> Bool {
        return filesWereDownloaded[index]
    }
    
    private func downloadAll() {
        if !clickedDownloadAll {
            let downloadGroup = DispatchGroup()
            clickedDownloadAll = true
            DispatchQueue.concurrentPerform(iterations: urls.count) { index in
                downloadGroup.enter()
                if !wasDownloadedFile(index: index) {
                    filesWereDownloaded[index] = true
                    downloadFile(index: index, shouldPostNotification: false)
                }
                downloadGroup.leave()
            }
            
            downloadGroup.notify(queue: DispatchQueue.main) { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.postNotification(items: self.loadedFiles)
            }
        } else {
                    showAlertAlreadyDownoaded(with: "All files were already downloaded")
                }
        }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count + 1 //for button
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == urls.count
        {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DownloadAllCell.identifier, for: indexPath) as? DownloadAllCell else {
                return UITableViewCell()
            }
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: URLCell.identifier, for: indexPath) as? URLCell else {
                return UITableViewCell()
            }
            
            cell.setContent(url: urls[indexPath.row].absoluteString)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == urls.count {
            loadedFiles = []
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.downloadAll()
            }
            
        } else {
            if wasDownloadedFile(index: indexPath.row) {
                showAlertAlreadyDownoaded(with: "File \(urls[indexPath.row].lastPathComponent) was already downloaded")
            } else {
                filesWereDownloaded[indexPath.row] = true
                loadedFiles = []
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.downloadFile(index: indexPath.row)
                }
                
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

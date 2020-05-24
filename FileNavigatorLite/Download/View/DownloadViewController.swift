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
    
    private func downloadFile(index: Int) {
        guard let view = self.view as? DownloadView,
            let cell = view.urlsTable.cellForRow(at: IndexPath(row: index, section: 0)) as? URLCell else {
                return
        }
        cell.indicator.startAnimating()
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
              guard let self = self else {
                  return
              }
            
            guard let loadedItem = try? Data(contentsOf: self.urls[index]) else {
                return
            }
            
            self.saveFile(index: index, loadedItem: loadedItem)
            
            DispatchQueue.main.async {
                cell.indicator.stopAnimating()
            }
        }
    }
    
    private func saveFile(index: Int, loadedItem: Data) {
        let localUrl = self.urls[index].lastPathComponent
        
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            assert(false)
            return
        }
        let fullURL = dir.appendingPathComponent(localUrl)
        try? loadedItem.write(to: fullURL, options: .atomic)
        
        self.postNotification(fileURL: fullURL, name: localUrl, size: Double(loadedItem.count))
    }
    
    private func postNotification(fileURL: URL, name: String, size: Double) {
        let fileModel = createFileModel(URL: fileURL, name: name, size: size)
        let notificationData = ["file" : fileModel]
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
            clickedDownloadAll = true
            for i in 0..<urls.count {
                if !wasDownloadedFile(index: i){
                    filesWereDownloaded[i] = true
                    downloadFile(index: i)
                }
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
            downloadAll()
        } else {
            if wasDownloadedFile(index: indexPath.row) {
                showAlertAlreadyDownoaded(with: "File \(urls[indexPath.row].lastPathComponent) was already downloaded")
            } else {
                filesWereDownloaded[indexPath.row] = true
                downloadFile(index: indexPath.row)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

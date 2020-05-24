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
    private var flagsWasDownloaded: [Bool] = []
    private var wasDownloadedAll = false
    
    // MARK: - Public methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view = DownloadView(viewController: self)

        getURLS()
        flagsWasDownloaded = [Bool](repeating: false, count: urls.count)
    }
    
    // MARK: Private methods
    private func getURLS() {
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
    
    private func downloadAndSaveItem(index: Int) {
        guard let view = self.view as? DownloadView,
            let cell = view.URLSTable.cellForRow(at: IndexPath(row: index, section: 0)) as? URLCell else {
                return
        }
        cell.indicator.startAnimating()
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
              guard let self = self else {
                  return
              }
            
            let loadedItem = try? Data(contentsOf: self.urls[index])
            let localUrl = self.urls[index].lastPathComponent
            try? loadedItem?.write(to: URL(fileURLWithPath: localUrl), options: .atomic)
            self.postNotification(fileURL: localUrl, name: localUrl, size: Double(loadedItem?.count ?? 0))
            
            DispatchQueue.main.async {
                cell.indicator.stopAnimating()
            }
        }
    }
    
    private func postNotification(fileURL: String, name: String, size: Double) {
        let fileModel = createFileModel(URL: fileURL, name: name, size: size)
        let notificationData = ["file" : fileModel]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.notificationFileName), object: nil, userInfo: notificationData)
    }
    
    private func createFileModel(URL: String, name: String, size: Double) -> FileModel {
        return FileModel(url: URL, name: name, size: size)
    }
    
    private func showAlertAlreadyDownoaded(with text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func wasDownloadedFile(index: Int) -> Bool {
        return flagsWasDownloaded[index]
    }
    
    private func downloadAll() {
        if !wasDownloadedAll {
            wasDownloadedAll = true
            for i in 0..<urls.count {
                if !wasDownloadedFile(index: i){
                    flagsWasDownloaded[i] = true
                    downloadAndSaveItem(index: i)
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
                flagsWasDownloaded[indexPath.row] = true
                downloadAndSaveItem(index: indexPath.row)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

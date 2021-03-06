//
//  ProfileViewController.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 22/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import QRCodeReader


class ProfileViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    let parser = ParserService()
    let localStorage = LocalStorageService()
    
    var info = [UserDataModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        info = localStorage.getAllData()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    

    
    @IBAction func qrScanTapped(_ sender: Any) {
        readerVC.delegate = self
        
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    //MARK: - QR Delegate
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        guard let parsedData: QRCodeDataModel = parser.parseQRCode(data: result.value) else {
            return
        }
        
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "showSendScreen", sender: parsedData)
        })
    }
    
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SendDataViewController {
            guard let parsedData = sender as? QRCodeDataModel else { return }
            vc.data = localStorage.getDataForTypes(types: parsedData.fields)
            vc.siteUrlString = parsedData.address
            vc.model = parsedData
        }
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as? InformationCell else { return UITableViewCell() }
        cell.configureCell(withData: info[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

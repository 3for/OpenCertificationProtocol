//
//  QRCodeDataModel.swift
//  KYCApp
//
import Foundation

struct QRCodeDataModel: Codable {
    let url: String
    let typeIDs: [String]
}

struct QRCodeSendKeyModel: Codable {
    let mainURL: String
    let sessionId: Int
    let address: String
}

struct QRCodeGetDataModel: Codable {
    let sessionId: Int
    let address: String
}

//
//  String+SHA256.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import Foundation

extension String {
    func sha256() -> String {
        guard let data = data(using: .utf8) else { return self }
        return data.sha256().map { String(format: "%02x", $0) }.joined()
    }
}

extension Data {
    func sha256() -> [UInt8] {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(count), &hash)
        }
        return hash
    }
}

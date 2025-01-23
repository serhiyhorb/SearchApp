//
//  FileStorage.swift
//  SearchApp
//
//  Created by Serhii on 23.01.2025.
//

import Foundation

class QFile {

    init(fileURL: URL) {
        self.fileURL = fileURL
    }

    deinit {
        // You must close before releasing the last reference.
        precondition(self.file == nil)
    }

    let fileURL: URL

    private var file: UnsafeMutablePointer<FILE>? = nil

    func open() throws {
        guard let f = fopen(fileURL.path, "r") else {
            throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno), userInfo: nil)
        }
        self.file = f
    }

    func close() {
        if let f = self.file {
            self.file = nil
            let success = fclose(f) == 0
            assert(success)
        }
    }

    func readLine(_ maxLength: Int = 1024) throws -> String? {
        guard let f = self.file else {
            throw NSError(domain: NSPOSIXErrorDomain, code: Int(EBADF), userInfo: nil)
        }
        var buffer = [CChar](repeating: 0, count: maxLength)
        guard fgets(&buffer, Int32(maxLength), f) != nil else {
            if feof(f) != 0 {
                return nil
            } else {
                throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno), userInfo: nil)
            }
        }
        return String(cString: buffer)
    }
}

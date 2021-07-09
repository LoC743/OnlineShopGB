//
//  Logging.swift
//  OnlineShopGB
//
//  Created by Alexey on 09.07.2021.
//

import Foundation

extension LogMessage {
    
    static var funcStart: LogMessage { "-->" }
    static var funcEnd: LogMessage { "<--" }
    static var call: LogMessage { "--" }
}

struct LogMessage: ExpressibleByStringLiteral {
    
    let message: String
    
    init(stringLiteral value: String) {
        self.message = value
    }
}

func logging(_ logInstance: Any, file: String = #file, funcName: String = #function, line: Int = #line) {
    let logMessage = "\(funcName) \(line): \(logInstance)"
    print("\(Date()): \(logMessage)")
}

func logging(_ logInstance: LogMessage, file: String = #file, funcName: String = #function, line: Int = #line) {
    logging(logInstance.message, funcName: funcName, line: line)
}

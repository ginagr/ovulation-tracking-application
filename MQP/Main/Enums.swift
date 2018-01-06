//
//  Enums.swift
//  MQP
//
//  Created by GGR on 12/27/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import Foundation

enum LoggingMethod {
    case binary //yes/no
    case checklist
    case radio
    case emoji
}

func getLoggingMethodEnum(string: LoggingMethod) -> String {
    switch string {
    case .binary:
        return "binary"
    case .checklist:
        return "checklist"
    case .radio:
        return "radio"
    case .emoji:
        return "emoji"
    }
}

func getLoggingMethodEnum(enumString: String) -> LoggingMethod {
    switch enumString {
    case "binary":
        return .binary
    case "checklist":
        return .checklist
    case "radio":
        return .radio
    case "emoji":
        return .emoji
    default:
        return .binary
    }
}

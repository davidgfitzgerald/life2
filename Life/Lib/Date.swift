//
//  Date.swift
//  Life
//
//  Created by David Fitzgerald on 30/10/2025.
//

import Foundation

enum DateFormatters {
    static let DDMMYYYY: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
}

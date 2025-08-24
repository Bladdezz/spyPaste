//
//  ClipboardItem.swift
//  SpyPaste
//
//  Created by nathan on 8/20/25.
//


import Foundation

struct ClipboardItem: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let timestamp: Date
}

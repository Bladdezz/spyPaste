//
//  ClipboardItem.swift
//  SpyPaste
//
//  Created by bladdezz on 8/20/25.
//


import Foundation

enum ClipboardContent: Equatable {
    case text(String)
    case files([URL])
}

struct ClipboardItem: Identifiable, Equatable {
    let id = UUID()
    let content: ClipboardContent
    let timestamp: Date
}

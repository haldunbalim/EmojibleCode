//
//  Constants.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 23.11.2020.
//

import UIKit

public class Constants{
    public static let TAB_BAR_WIDTH = CGFloat(90)
    public static let reservedEmojis: [String] = ["👉",  "🟦", "📝", "➗", "👎", "🙃", "🔁", "🟩", "🤔", "📱", "💡", "➖", "✖️", "🔢", "🦜", "📣", "➕", "🟥", "👻", "👋", "🔉", "🤚", "💬", "🪐", "👍", "🟨"]
    public static let VisionModelURL = "http://ec2-18-197-151-213.eu-central-1.compute.amazonaws.com:8000/file/upload/"
    
    // 1000000  = 1second
    public static let SLEEP_DURATION_IN_WHILE = 1000000 / 20
    
    public static let SLEEP_DURATION_IN_FOR = 1000000 * 2
    
    public static let FUNCTION_IDENTIFIER_PREFIX = "FUNC:\n"
}

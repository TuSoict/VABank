//
//  Colors.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import UIKit

struct Colors {
    static var black = UIColor.color(hex: "191925")
    static var lightGray = UIColor.color(hex: "F3F5FA")
    static var violet = UIColor.color(hex: "5560B4")
    static var blue = UIColor.color(hex: "1464F4")
    static var oragne = UIColor.color(hex: "F08757")
    static var green = UIColor.color(hex: "4FAC68")
}

private extension UIColor {
    static func color(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

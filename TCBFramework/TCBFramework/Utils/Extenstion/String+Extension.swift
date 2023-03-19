//
//  String+Extension.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import UIKit

extension String {
    func toDate(format: String) -> Date? {
        let format = DateFormatter().apply {
            $0.dateFormat = format
            $0.timeZone = .current
        }
        return format.date(from: self)
    }
    
    func toMoney() -> String {
        guard !self.isEmpty else { return "" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        let value = Double(self).doubleValue()
        
        return formatter.string(from: NSNumber(value: value)).stringValue() + " VND"
    }
}

extension NSMutableAttributedString {
    @discardableResult
    func appendWith(color: UIColor = .white,
                    weight: UIFont.Weight = .regular,
                    ofSize: CGFloat = 12.0,
                    _ text: String) -> NSMutableAttributedString {
        
        let attribute = NSAttributedString.makeWith(color: color, weight: weight, ofSize:ofSize, text)
        self.append(attribute)
        return self
    }
    
    @discardableResult
    func appendImage(_ image: UIImage) -> NSMutableAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        
        let attribute = NSAttributedString(attachment: attachment)
        
        self.append(attribute)
        
        return self
    }
    
    func addLineSpacing(_ lineSpacing: CGFloat, alignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        self.addAttribute(NSAttributedString.Key.paragraphStyle,
                          value:paragraphStyle,
                          range:NSMakeRange(0, self.length))
        return self
    }
}

extension NSAttributedString {
    public static func makeWith(color: UIColor = UIColor.darkText,
                                weight: UIFont.Weight = .regular,
                                ofSize: CGFloat = 12.0,
                                _ text: String) -> NSMutableAttributedString {
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: ofSize, weight: weight),
            NSAttributedString.Key.foregroundColor: color
        ]
        
        let mutableAttribute = NSMutableAttributedString(string: text, attributes: attributes)
        return mutableAttribute
    }
}

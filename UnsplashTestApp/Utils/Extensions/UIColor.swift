//
//  UIColor.swift
//  UnsplashTestApp
//
//  Created by Vladislav Avrutin on 18.09.2024.
//

import UIKit

extension UIColor {
    
    enum Hex: String {
        case eaeaea = "000000"
    }
    
    static func color(light: UIColor, dark: UIColor) -> UIColor {
        
        return .init { traitCollection in
            
            return traitCollection.userInterfaceStyle == .dark ? dark : light
        }
   }
    
    convenience init(hex: Hex) {
        
        var hexString: String = hex.rawValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") { hexString.remove(at: hexString.startIndex) }
        
        var rgbValue:UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


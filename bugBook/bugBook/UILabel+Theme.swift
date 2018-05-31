//
//  UILabel+Theme.swift
//  bugBook
//
//  Created by SaTHYa on 08/04/17.
//  Copyright © 2017 Sathya. All rights reserved.
//

import Foundation
//
//  UILabel+Theme.swift
//  SellQuick
//
//  Created by harish on 11/03/16.
//  Copyright © 2016 GFT. All rights reserved.
//

import UIKit

extension UILabel {
    
    struct Color {
        static let Black = UIColor.black
        static let White = UIColor.white
        static let Clear = UIColor.clear
        static let AppTheme = UIColor(red: 35/255, green: 77/255, blue: 109/255, alpha: 1.0)
        static let AppThemeLowAlpha = UIColor(red: 35/255, green: 77/255, blue: 109/255, alpha: 0.8)
        static let CellHighlight = UIColor.darkGray
        static let PrimaryButtonNormal = UIColor(red: 59/255, green: 159/255, blue: 243/255, alpha: 1.0)
        static let PrimaryButtonDisabled = UIColor(red: 59/255, green: 159/255, blue: 243/255, alpha: 0.2)
        static let SecondaryBarButtonNormal = UIColor.white
        static let SecondaryBarButtonDisabled = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        static let SecondaryButtonNormal = UIColor(red: 206/255.0, green: 213/255.0, blue: 219/255.0, alpha: 1.0)
        static let titleTextColor = UIColor.white
        static let Error = UIColor(red: 239/255, green: 72/255, blue: 54/255, alpha: 1.0)
        static let Success = UIColor(red: 106/255, green: 192/255, blue: 57/255, alpha: 1.0)
        static let BackgroundOverlay = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        static let ProductScanOnlyOverlay = UIColor(red:215/255, green:228/255, blue:236/255, alpha:0.92)
        static let TableSection = UIColor(red: 220/255, green: 238/255, blue: 242/255, alpha: 1.0)
        static let Hold = UIColor(red: 255/255, green: 210/255, blue: 0/255, alpha: 1.0)
        static let BaseBackground = UIColor(red:215/255, green:228/255, blue:236/255, alpha:1.0)
        static let Border = UIColor(red:122/255, green:156/255, blue:181/255, alpha:1.0)
        static let MasterBaseBackground = UIColor(red:240/255, green:245/255, blue:248/255, alpha:1.0)
        static let OffCanvas = UIColor(red:28/255, green:45/255, blue:58/255, alpha:1.0)
        static let CartTopBackground = UIColor(red:122/255, green:156/255, blue:181/255, alpha:1.0)
        static let WhiteTableCellSeparator = UIColor(red:215/255, green:228/255, blue:236/255, alpha:1.0)
        static let DetailText = UIColor(red: 115/255.0, green: 115/255.0, blue: 115/255.0, alpha: 1.0)
        static let LogoutButton = UIColor(red: 18/255.0, green: 30/255.0, blue: 38/255.0, alpha: 1.0)
        static let cashDrawer = UIColor(red:59/255.0, green:159/255.0, blue:243/255.0, alpha: 1.0)
    }
    
    func setTitleCellTheme() {
        font = UIFont(name: "HelveticaNeue" , size: 14 )
        textColor = Color.Black
        applyFontAutoShrink()
    }
    
    func setBodyCellTheme() {
        font = UIFont(name: "HelveticaNeue" , size: 12 )
        textColor = Color.DetailText
        applyFontAutoShrink()
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
    }
    
    fileprivate func applyFontAutoShrink() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
    }
    
    func setTitleTheme() {
        font = UIFont(name: "HelveticaNeue" , size: 14 )
        textColor = Color.titleTextColor
        backgroundColor = Color.AppTheme
        textAlignment = .center
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
    }
    
    func attributedText(_ firstText: String, firstTextFont: UIFont, firstTextColor: UIColor, secondText: String, secondTextFont: UIFont, secondTextColor: UIColor) {
        let firstTextRange = NSMakeRange(0, firstText.count)
        let secondTextRange = NSMakeRange(firstText.count, secondText.count)
        let attributedString = NSMutableAttributedString(string: firstText + secondText)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: firstTextColor, range: firstTextRange)
        attributedString.addAttribute(NSAttributedStringKey.font, value: firstTextFont, range: firstTextRange)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: secondTextColor, range: secondTextRange)
        attributedString.addAttribute(NSAttributedStringKey.font, value: secondTextFont, range: secondTextRange)
        attributedString.addAttribute(NSAttributedStringKey.baselineOffset, value: ((firstTextFont.pointSize - secondTextFont.pointSize)/2), range: secondTextRange)
        attributedText = attributedString
    }
    
}


extension CALayer {
    func applyTopLayerTheme(_ view: UIView, color: UIColor, topSpacing: CGFloat) {
        frame = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y + topSpacing, width: view.bounds.size.width, height: 1.0);
        backgroundColor = color.cgColor
        view.layer.addSublayer(self)
    }
}

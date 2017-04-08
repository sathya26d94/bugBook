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
        static let Black = UIColor.blackColor()
        static let White = UIColor.whiteColor()
        static let Clear = UIColor.clearColor()
        static let AppTheme = UIColor(colorLiteralRed: 35/255, green: 77/255, blue: 109/255, alpha: 1.0)
        static let AppThemeLowAlpha = UIColor(colorLiteralRed: 35/255, green: 77/255, blue: 109/255, alpha: 0.8)
        static let CellHighlight = UIColor.darkGrayColor()
        static let PrimaryButtonNormal = UIColor(colorLiteralRed: 59/255, green: 159/255, blue: 243/255, alpha: 1.0)
        static let PrimaryButtonDisabled = UIColor(colorLiteralRed: 59/255, green: 159/255, blue: 243/255, alpha: 0.2)
        static let SecondaryBarButtonNormal = UIColor.whiteColor()
        static let SecondaryBarButtonDisabled = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        static let SecondaryButtonNormal = UIColor(colorLiteralRed: 206/255.0, green: 213/255.0, blue: 219/255.0, alpha: 1.0)
        static let titleTextColor = UIColor.whiteColor()
        static let Error = UIColor(colorLiteralRed: 239/255, green: 72/255, blue: 54/255, alpha: 1.0)
        static let Success = UIColor(colorLiteralRed: 106/255, green: 192/255, blue: 57/255, alpha: 1.0)
        static let BackgroundOverlay = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        static let ProductScanOnlyOverlay = UIColor(colorLiteralRed:215/255, green:228/255, blue:236/255, alpha:0.92)
        static let TableSection = UIColor(colorLiteralRed: 220/255, green: 238/255, blue: 242/255, alpha: 1.0)
        static let Hold = UIColor(colorLiteralRed: 255/255, green: 210/255, blue: 0/255, alpha: 1.0)
        static let BaseBackground = UIColor(colorLiteralRed:215/255, green:228/255, blue:236/255, alpha:1.0)
        static let Border = UIColor(colorLiteralRed:122/255, green:156/255, blue:181/255, alpha:1.0)
        static let MasterBaseBackground = UIColor(colorLiteralRed:240/255, green:245/255, blue:248/255, alpha:1.0)
        static let OffCanvas = UIColor(colorLiteralRed:28/255, green:45/255, blue:58/255, alpha:1.0)
        static let CartTopBackground = UIColor(colorLiteralRed:122/255, green:156/255, blue:181/255, alpha:1.0)
        static let WhiteTableCellSeparator = UIColor(colorLiteralRed:215/255, green:228/255, blue:236/255, alpha:1.0)
        static let DetailText = UIColor(colorLiteralRed: 115/255.0, green: 115/255.0, blue: 115/255.0, alpha: 1.0)
        static let LogoutButton = UIColor(colorLiteralRed: 18/255.0, green: 30/255.0, blue: 38/255.0, alpha: 1.0)
        static let cashDrawer = UIColor(colorLiteralRed:59/255.0, green:159/255.0, blue:243/255.0, alpha: 1.0)
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
        lineBreakMode = .ByWordWrapping
        numberOfLines = 0
    }
    
    private func applyFontAutoShrink() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
    }
    
    func setTitleTheme() {
        font = UIFont(name: "HelveticaNeue" , size: 14 )
        textColor = Color.titleTextColor
        backgroundColor = Color.AppTheme
        textAlignment = .Center
        lineBreakMode = .ByWordWrapping
        numberOfLines = 0
    }
    
    func attributedText(firstText: String, firstTextFont: UIFont, firstTextColor: UIColor, secondText: String, secondTextFont: UIFont, secondTextColor: UIColor) {
        let firstTextRange = NSMakeRange(0, firstText.characters.count)
        let secondTextRange = NSMakeRange(firstText.characters.count, secondText.characters.count)
        let attributedString = NSMutableAttributedString(string: firstText + secondText)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: firstTextColor, range: firstTextRange)
        attributedString.addAttribute(NSFontAttributeName, value: firstTextFont, range: firstTextRange)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: secondTextColor, range: secondTextRange)
        attributedString.addAttribute(NSFontAttributeName, value: secondTextFont, range: secondTextRange)
        attributedString.addAttribute(NSBaselineOffsetAttributeName, value: ((firstTextFont.pointSize - secondTextFont.pointSize)/2), range: secondTextRange)
        attributedText = attributedString
    }
    
}


extension CALayer {
    func applyTopLayerTheme(view: UIView, color: UIColor, topSpacing: CGFloat) {
        frame = CGRectMake(view.bounds.origin.x, view.bounds.origin.y + topSpacing, view.bounds.size.width, 1.0);
        backgroundColor = color.CGColor
        view.layer.addSublayer(self)
    }
}
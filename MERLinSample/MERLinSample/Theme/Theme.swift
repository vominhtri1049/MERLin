//
//  Theme.swift
//  
//
//  Created by Giuseppe Lanza on 20/04/18.
//  Copyright © 2018 Gilt. All rights reserved.
//

import UIKit
import MERLin

fileprivate extension ThemeFontAttribute {
    func primaryFont(withSize size: CGFloat = UIFont.labelFontSize) -> UIFont {
        switch self {
        case .regular: return .systemFont(ofSize: size)
        case .bold: return .boldSystemFont(ofSize: size)
        case .sBold: return .systemFont(ofSize: size, weight: .semibold)
        }
    }
}

fileprivate extension ThemeFontStyle {
    var fontSize: CGFloat {
        switch self {
        case .small(_): return 11
        case .caption(_): return 12
        case .subhead(_): return 13
        case .body(_): return 15
        case .headline(_): return 18
        case .title(_): return 22
        case .display(_): return 26
        }
    }
    
    var font: UIFont {
        return attribute.primaryFont(withSize: fontSize)
    }
}

fileprivate extension ThemeColorPalette {
    var color: UIColor {
        switch self {
        case .white: return .white
        case .gray_1: return .color(fromHex: "#f7f7f7")
        case .gray_2: return .color(fromHex: "#dedede")
        case .gray_3: return .color(fromHex: "#9e9e9e")
        case .gray_4: return .color(fromHex: "#3d3d3d")
        case .black: return .color(fromHex: "#1a1a1a")
        case .primary: return .color(fromHex: "#06498f")
        case .primaryFocused: return .color(fromHex: "#042e5c")
        case .error: return .color(fromHex: "#ff0000")
        case .warning: return .color(fromHex: "#ffcc01")
        case .success: return .color(fromHex: "#73bb04")
        case .info: return .color(fromHex: "#3a86ad")
        case .sales: return .color(fromHex: "#e32235")
        case .custom(let color): return color
        }
    }
}

final class Theme: ModuleThemeProtocol {
    
    func color(forColorPalette colorPalette: ThemeColorPalette) -> UIColor {
        return colorPalette.color
    }

    func font(forStyle style: ThemeFontStyle) -> UIFont {
        return style.font
    }

    func fontSize(forStyle style: ThemeFontStyle) -> CGFloat {
        return style.fontSize
    }

    func applyAppearance() {
        //UINavigationBar
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = color(forColorPalette: .primary)
        UINavigationBar.appearance().titleTextAttributes = [
            .font: font(forStyle: .headline(attribute: .regular)),
            .foregroundColor: color(forColorPalette: .gray_4)
        ]
        
        //UIBarButtonItem
        UIBarButtonItem.appearance().setTitleTextAttributes([
            .font: font(forStyle: .body(attribute: .regular)),
            .foregroundColor: color(forColorPalette: .primary)
            ], for: .normal)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            .font: font(forStyle: .body(attribute: .regular)),
            .foregroundColor: color(forColorPalette: .gray_4)
            ], for: .highlighted)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            .font: font(forStyle: .body(attribute: .regular)),
            .foregroundColor: color(forColorPalette: .gray_3)
            ], for: .disabled)
        
        //UITabBar
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().tintColor = color(forColorPalette: .primary)
        
        //UITabBarItem
        UITabBarItem.appearance().badgeColor = color(forColorPalette: .primary)
        UITabBarItem.appearance().setTitleTextAttributes([
            .font: font(forStyle: .small(attribute: .regular)),
            .foregroundColor: color(forColorPalette: .primary)
            ], for: .selected)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary([
            NSAttributedString.Key.font.rawValue: font(forStyle: .body(attribute: .regular)),
            NSAttributedString.Key.foregroundColor.rawValue: color(forColorPalette: .gray_4)
        ])
    }
    
    func cleanThemeCopy() -> Theme {
        return Theme()
    }
}

//MARK: - Labels

extension Theme {
    func attributedString(withString string: String, andStyle style: ThemeFontStyle) -> NSAttributedString {
        let attributedString = NSAttributedString(string: string,
                                                  attributes: [
                                                    .font: style.font,
                                                    .foregroundColor: color(forColorPalette: .gray_4) ])
        
        return attributedString
    }
    
    func configure(range: NSRange, of attributedString: NSAttributedString, withStyle style: ThemeFontStyle, andColor color: ThemeColorPalette) -> NSAttributedString {
        let mutableCopy = attributedString.mutableCopy() as! NSMutableAttributedString
        
        mutableCopy.setAttributes([
            NSAttributedString.Key.font: style.font,
            NSAttributedString.Key.foregroundColor: self.color(forColorPalette: color)
            ], range: range)
        
        return mutableCopy
    }
    
    @discardableResult
    func configure(label: UILabel, withStyle style: ThemeFontStyle, customizing: ((UILabel, ModuleThemeProtocol)->Void)?) -> UILabel {
        label.font = style.font
        label.textColor = color(forColorPalette: .gray_4)
        
        customizing?(label, self)

        return label
    }
}

//MARK: - Buttons

extension Theme {
    @discardableResult
    func configurePrimaryButton(button: UIButton, withTitleStyle style: ThemeFontStyle, customizing: ((UIButton, ModuleThemeProtocol)->Void)? = nil) -> UIButton {
        button.setupTitle(font: style.font)
            .setupLayer(cornerRadius: 2, borderWidth: 0, borderColor: nil)
            .setBackgroundColor(color: color(forColorPalette: .primary), for: .normal)
            .setBackgroundColor(color: color(forColorPalette: .gray_2), for: .disabled)
            .setBackgroundColor(color: color(forColorPalette: .primaryFocused), for: [.highlighted, .focused])
            .setTitleTextColor(color: color(forColorPalette: .white), for: .normal)
            .setTitleTextColor(color: color(forColorPalette: .gray_3), for: .disabled)
            .tintColor = .white

        button.showsTouchWhenHighlighted = false

        customizing?(button, self)
        
        return button
    }
    
    @discardableResult
    func configureSecondaryButton(button: UIButton, withTitleStyle style: ThemeFontStyle, customizing: ((UIButton, ModuleThemeProtocol)->Void)? = nil) -> UIButton {
        button.setupTitle(font: style.font)
            .setupLayer(cornerRadius: 4, borderWidth: 1, borderColor: color(forColorPalette: .primary).cgColor)
            .resetBackgrounds()
            .setTitleTextColor(color: color(forColorPalette: .primary), for: .normal)
            .tintColor = color(forColorPalette: .primary)

        button.showsTouchWhenHighlighted = false

        customizing?(button, self)
        
        return button
    }
    
    @discardableResult
    func configureTextOnlyButton(button: UIButton, withTitleStyle style: ThemeFontStyle, customizing: ((UIButton, ModuleThemeProtocol)->Void)? = nil) -> UIButton {
        button.setupTitle(font: style.font)
            .setupLayer(cornerRadius: 0, borderWidth: 0, borderColor: nil)
            .resetBackgrounds()
            .setTitleTextColor(color: color(forColorPalette: .primary), for: .normal)
            .setTitleTextColor(color: color(forColorPalette: .gray_3), for: .disabled)
            .setTitleTextColor(color: color(forColorPalette: .gray_1), for: [.highlighted, .focused])
            .tintColor = color(forColorPalette: .primary)
        
        button.showsTouchWhenHighlighted = false

        customizing?(button, self)
        
        return button
    }
}

//TextField
extension Theme {
    @discardableResult
    func configureBoxedTextField(textfield: UITextField, withTextStyle style: ThemeFontStyle, customizing: ((UITextField, ModuleThemeProtocol)->Void)? = nil) -> UITextField {
        
        textfield.backgroundColor = color(forColorPalette: .gray_1)
        textfield.font = font(forStyle: style)
        textfield.textColor = color(forColorPalette: .black)
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        paddingView.backgroundColor = .clear
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
        
        customizing?(textfield, self)
        return textfield
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

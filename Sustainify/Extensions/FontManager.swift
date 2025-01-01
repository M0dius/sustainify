import Foundation
import UIKit

struct FontManager {
    //deviceWidthSize == Your default screen width. For example, if your designer created a design using iPhone 11, then the size will be the width of iPhone 11 and so on... Therefore, you should adjust it according to your designed screens.
//    static let deviceWidthSize = 393.0
//    
//    //You can change it based on your requirements
//    static private let adjustFactorWithConsiderationOfIpad = UIScreen.main.traitCollection.userInterfaceIdiom == .pad ? 0.65 : 1
//    
//    static let scaleFactorWidth: CGFloat = (UIScreen.main.bounds.width / FontManager.deviceWidthSize) * CGFloat(adjustFactorWithConsiderationOfIpad)
//}
//
//extension UILabel {
//    @objc dynamic var adjustedFont: UIFont? {
//        get {
//            return self.font
//        }
//        set {
//            if let newFont = newValue {
//                self.font = newFont.withSize(newFont.pointSize * FontManager.scaleFactorWidth)
//            }
//        }
//    }
//    
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        self.font = UIFont(name: self.font.fontName, size: self.font.pointSize * FontManager.scaleFactorWidth)
//    }
//}
//	
//extension UIButton {
//    @objc dynamic var adjustedFont: UIFont? {
//        get {
//            return self.titleLabel?.font
//        }
//        set {
//            if let newFont = newValue {
//                self.titleLabel?.font = newFont.withSize(newFont.pointSize * FontManager.scaleFactorWidth)
//            }
//        }
//    }
//    
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        if let fontName = self.titleLabel?.font.fontName {
//            self.titleLabel?.font = UIFont(name: fontName, size: (self.titleLabel?.font.pointSize ?? 15.0) * FontManager.scaleFactorWidth)
//        }
//    }
//}
//
//extension UITextField {
//    @objc dynamic var adjustedFont: UIFont? {
//        get {
//            return self.font
//        }
//        set {
//            if let newFont = newValue {
//                self.font = newFont.withSize(newFont.pointSize * FontManager.scaleFactorWidth)
//            }
//        }
//    }
//    
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        if let fontName = self.font?.fontName {
//            self.font = UIFont(name: fontName, size: (self.font?.pointSize ?? 15.0) * FontManager.scaleFactorWidth)
//        }
//    }
//}
//
//extension UITextView {
//    @objc dynamic var adjustedFont: UIFont? {
//        get {
//            return self.font
//        }
//        set {
//            if let newFont = newValue {
//                self.font = newFont.withSize(newFont.pointSize * FontManager.scaleFactorWidth)
//            }
//        }
//    }
//    
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        if let fontName = self.font?.fontName {
//            self.font = UIFont(name: fontName, size: (self.font?.pointSize ?? 15.0) * FontManager.scaleFactorWidth)
//        }
//    }
}

////This will be used when you want to setup font programmatically.
////name = name of your font. You can add it in Fonts enum
////Size = Size of your font
//extension UIFont {
//    static func setFont(name: Fonts, size: CGFloat) -> UIFont {
//        return UIFont(name: name.rawValue, size: size * FontManager.scaleFactorWidth)!
//    }
//}
//
//enum Fonts: String {
//    case Rubik_Bold = "Rubik-Bold"
//    case Rubik_Medium = "Rubik-Medium"
//    case Rubik_Regular = "Rubik-Regular"
//}

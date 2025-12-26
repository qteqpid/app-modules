import SwiftUI
import UIKit

/// 应用配置参数
struct AppConfigs {
    // 背景颜色
    static var backgroundColor = Color(red: 51/255, green: 51/255, blue: 51/255)
    
    // 应用版本号
    static var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0"
    }

    // 打开指定URL
    static func openUrl(url: String) {
        if let targetUrl = URL(string: url) {
            if UIApplication.shared.canOpenURL(targetUrl) {
                UIApplication.shared.open(targetUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
    // 获取App Store链接
    static func getAppStoreUrl(appId: String) -> String {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return "itms-apps://itunes.apple.com/app/id\(appId)"
        } else {
            return "https://apps.apple.com/app/id\(appId)"
        }
    }
    
    // 加载图片
    static func loadImage(name: String?) -> UIImage? {
        guard let name = name else {
            print("图片名称为空")
            return nil
        }

        // 解析文件名和扩展名
        let components = name.split(separator: ".")
        if components.count != 2 {
            print("无效的图片名称格式: \(name)")
            return nil
        }

        let imageName = String(components[0])
        let imageType = String(components[1])

        // 使用解析出的文件名和扩展名加载图片
        if let filePath = Bundle.main.path(forResource: imageName, ofType: imageType) {
            return UIImage(contentsOfFile: filePath)
        }

        print("无法加载图片: \(name)")
        return nil
    }
}

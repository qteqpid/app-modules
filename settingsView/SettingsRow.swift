import SwiftUI
import UIKit
import Combine

// 可复用的设置行组件
struct SettingsRow<RightContent: View>: View {
    let iconName: String
    let title: String
    let rightContent: RightContent
    let isLast: Bool
    let destination: AnyView? // 添加可选的导航目标
    
    private let rowBgColor = Color.white // 行背景色
    private let settingFontColor = Color.black
    private let settingDividerColor = Color.black
    private let rowHeight: CGFloat = 40
    
    init(
        iconName: String,
        title: String,
        isLast: Bool = false,
        destination: AnyView? = nil, // 可选的导航目标
        @ViewBuilder rightContent: () -> RightContent
    ) {
        self.iconName = iconName
        self.title = title
        self.rightContent = rightContent()
        self.isLast = isLast
        self.destination = destination
    }
    
    var body: some View {
        ZStack {
            // 如果提供了destination，在底层放置一个不可见的NavigationLink
            if let destination = destination {
                NavigationLink(destination: destination) {
                    EmptyView()
                }
                .opacity(0) // 设置为完全透明
            }
            
            // 在顶层放置实际的行内容
            rowContent
        }
    }
    
    // 提取行内容为单独的计算属性，方便复用
    private var rowContent: some View {
        HStack {
            // 判断iconName是否以图片文件扩展名结尾
            if iconName.hasSuffix(".png") || iconName.hasSuffix(".jpg") || iconName.hasSuffix(".jpeg") || iconName.hasSuffix(".gif") || iconName.hasSuffix(".svg") {
                // 如果是以常见图片文件扩展名结尾，则使用AppConfigs.loadImage加载图片
                if let uiImage = AppConfigs.loadImage(name: iconName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(settingFontColor)
                        .frame(width: 24, height: 24)
                        .cornerRadius(2)
                } else {
                    // 如果加载失败，显示原始的iconName作为系统图标
                    Image(systemName: iconName)
                        .foregroundColor(settingFontColor)
                }
            } else {
                // 否则，使用systemName加载系统图标
                Image(systemName: iconName)
                    .foregroundColor(settingFontColor)
            }
            Text(LocalizedStringKey(title))
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                .foregroundColor(settingFontColor)
            Spacer()
            rightContent
        }
        .background(rowBgColor)
        .frame(height: rowHeight)
    }
}

// 简化版本的SettingsRow，用于只有右箭头的情况
struct SimpleSettingsRow: View {
    let iconName: String
    let title: String
    let isLast: Bool
    let destination: AnyView? // 添加可选的导航目标
    
    init(
        iconName: String,
        title: String,
        isLast: Bool = false,
        destination: AnyView? = nil // 可选的导航目标
    ) {
        self.iconName = iconName
        self.title = title
        self.isLast = isLast
        self.destination = destination
    }
    
    var body: some View {
        SettingsRow(iconName: iconName, title: title, isLast: isLast, destination: destination) {
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}

// 带标签的SettingsRow
struct SettingsRowWithBadge: View {
    let iconName: String
    let title: String
    let badgeText: String
    let badgeColor: Color
    let isLast: Bool
    
    var body: some View {
        SettingsRow(iconName: iconName, title: title, isLast: isLast) {
            Text(LocalizedStringKey(badgeText))
                .foregroundColor(.white)
                .font(.caption)
                .padding(4)
                .background(badgeColor)
                .cornerRadius(4)
        }
    }
}

// 带标签的SettingsRow
struct SettingsRowWithText: View {
    let iconName: String
    let title: String
    let text: String
    let isLast: Bool
    
    var body: some View {
        SettingsRow(iconName: iconName, title: title, isLast: isLast) {
            Text(LocalizedStringKey(text))
                .foregroundColor(.gray)
        }
    }
}

// 带标签和箭头的SettingsRow
struct SettingsRowWithBadgeAndArrow: View {
    let iconName: String
    let title: String
    let badgeText: String
    let badgeColor: Color
    let isLast: Bool
    
    var body: some View {
        SettingsRow(iconName: iconName, title: title, isLast: isLast) {
            HStack {
                Text(LocalizedStringKey(badgeText))
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding(4)
                    .background(badgeColor)
                    .cornerRadius(4)
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }
}

// 带文本和箭头的SettingsRow，支持点击操作
struct SettingsRowWithTextAndArrow: View {
    let iconName: String
    let title: String
    let rightText: String
    let arrowIconName: String
    let isLast: Bool
    let action: (() -> Void)? // 添加可选的点击操作
    
    init(
        iconName: String,
        title: String,
        rightText: String,
        arrowIconName: String,
        isLast: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.iconName = iconName
        self.title = title
        self.rightText = rightText
        self.arrowIconName = arrowIconName
        self.isLast = isLast
        self.action = action
    }
    
    var body: some View {
        ZStack {
            if let action = action {
                Button(action: action) {
                    SettingsRow(iconName: iconName, title: title, isLast: isLast) {
                        HStack {
                            Text(rightText)
                                .foregroundColor(.gray)
                            Image(systemName: arrowIconName)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                SettingsRow(iconName: iconName, title: title, isLast: isLast) {
                    HStack {
                        Text(LocalizedStringKey(rightText))
                            .foregroundColor(.gray)
                        Image(systemName: arrowIconName)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

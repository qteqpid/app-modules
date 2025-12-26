# App Modules

这是一个分享iOS移动应用开发中可重用模块的仓库，旨在提高开发效率，避免重复造轮子。

## 目录结构

```
├── README.md
├── inAppPurchase/          # 应用内购模块
│   ├── InAppPurchaseManager.swift
│   └── PurchaseView.swift
└── settingsView/           # 设置页面模块
    ├── AppConfigs.swift
    ├── SettingsAppListView.swift
    ├── SettingsRow.swift
    └── SettingsView.swift
```

## 当前模块

### 1. 应用内购模块 (inAppPurchase)

一个基于StoreKit的完整应用内购解决方案，适用于iOS应用。

#### 功能特点：
- ✅ **高级版功能管理**：一键开通/检查高级版状态
- ✅ **灵活的免费使用限制**：支持天数限制或使用次数限制
- ✅ **完整的购买流程**：产品加载、购买、恢复购买
- ✅ **内置购买界面**：精美的订阅/购买页面UI
- ✅ **错误处理**：完善的错误提示和处理机制
- ✅ **用户默认值存储**：购买状态持久化保存

#### 主要组件：
1. **InAppPurchaseManager**：内购核心管理类
   - 单例设计模式
   - 产品管理和购买流程处理
   - 高级版状态管理
   - 免费使用限制策略

2. **PurchaseView**：购买界面组件
   - 美观的UI设计
   - 购买按钮和恢复购买功能
   - 加载状态和错误提示
   - 响应式布局

## 使用方法

### 内购模块使用示例：

```swift
// 初始化并加载产品
let purchaseManager = InAppPurchaseManager.shared
Task {
    await purchaseManager.loadProducts()
}

// 检查是否需要显示购买提示
if purchaseManager.shouldShowPurchaseAlert() {
    // 显示购买视图
    let purchaseView = PurchaseView(purchaseManager: purchaseManager, showRatingAlert: $showRatingAlert)
    // 以模态方式呈现
}

// 检查是否为高级版用户
if purchaseManager.isPremium {
    // 提供高级功能
} else {
    // 提供基本功能
}

// 增加使用次数（用于使用次数限制）
purchaseManager.increaseUseTimes()
```

### 2. 设置页面模块 (settingsView)

一个完整的iOS应用设置页面解决方案，提供了可复用的设置组件和布局。

#### 功能特点：
- ✅ **完整的设置页面结构**：包含分组、行项目、图标等
- ✅ **可复用的设置行组件**：多种样式的设置行满足不同需求
- ✅ **应用内链接跳转**：支持打开URL、App Store等
- ✅ **响应式布局**：适配不同屏幕尺寸
- ✅ **自定义背景颜色**：支持主题定制
- ✅ **可扩展的架构**：易于添加新的设置项

#### 主要组件：
1. **AppConfigs**：应用配置管理类
   - 提供应用版本、背景颜色等全局配置
   - 处理URL打开和App Store链接生成
   - 图片资源加载功能

2. **SettingsView**：设置页面主视图
   - 完整的设置页面布局
   - 支持分组和自定义标题
   - 集成联系我们、评分等常见功能

3. **SettingsRow**：可复用的设置行组件
   - 支持多种样式：基本行、带标签、带文本、带箭头等
   - 灵活的自定义内容支持
   - 导航目标和点击事件支持

4. **SettingsAppListView**：应用列表视图
   - 展示其他应用的列表
   - 支持点击跳转到App Store
   - 响应式布局设计

#### 使用示例：

```swift
// 显示设置页面
let settingsView = SettingsView()

// 使用自定义背景颜色
let backgroundColor = Color(red: 51/255, green: 51/255, blue: 51/255)

// 创建设置行
let simpleRow = SimpleSettingsRow(iconName: "star", title: "给我们评分")
    .onTapGesture {
        AppConfigs.openUrl(url: "itms-apps://itunes.apple.com/app/id1234567890?action=write-review")
    }

// 创建带导航的设置行
let navigableRow = SimpleSettingsRow(
    iconName: "iphone", 
    title: "更多应用", 
    destination: AnyView(AppListView(backgroundColor: backgroundColor))
)

// 打开URL
AppConfigs.openUrl(url: "https://example.com")

// 获取应用版本
let version = AppConfigs.appVersion
```

## 未来规划

- [ ] 添加更多实用模块
- [ ] 完善文档和使用示例
- [ ] 支持更多平台
- [ ] 增加单元测试
- [ ] 添加主题切换功能
- [ ] 支持多语言设置

## 贡献

欢迎提交Issue和Pull Request来帮助改进这个项目！

## 许可证

MIT License

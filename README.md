# App Modules

这是一个分享iOS移动应用开发中可重用模块的仓库，旨在提高开发效率，避免重复造轮子。

## 目录结构

```
├── README.md
└── inAppPurchase/          # 应用内购模块
    ├── InAppPurchaseManager.swift
    └── PurchaseView.swift
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

## 未来规划

- [ ] 添加更多实用模块
- [ ] 完善文档和使用示例
- [ ] 支持更多平台
- [ ] 增加单元测试

## 贡献

欢迎提交Issue和Pull Request来帮助改进这个项目！

## 许可证

MIT License

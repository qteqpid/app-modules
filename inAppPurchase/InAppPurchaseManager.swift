import Foundation
import StoreKit


enum LimitPolicy {
    case dayLimit
    case useLimit
}

@MainActor
class InAppPurchaseManager: ObservableObject {
    static let shared = InAppPurchaseManager()
    
    @Published var isPremium = false
    @Published var products: [Product] = []
    @Published var isPurchasing = false
    @Published var errorMessage: String?
    
    private let productID = "com.qteqpid.good_idea.premium" // TODO: 创建APP内购买项目时填写的产品ID
    private let KEY_IS_PREMIUM = "isPremium"
    private let userDefaults = UserDefaults.standard
    
    // 限制策略相关
    private let KEY_FIRST_LAUNCH_DATE = "purchaseFirstLaunchDate"
    private let KEY_USE_TIMES = "purchaseUseTimes"
    private let MAX_FREE_DAYS = 7
    private let MAX_USE_TIMES = 50
    private let limitPolicy = LimitPolicy.useLimit  // 使用哪种限制策略
    
    init() {
        loadPremiumStatus()
        initKeysAtFirstLaunch()
    }
    
    // 加载高级版状态
    private func loadPremiumStatus() {
        isPremium = userDefaults.bool(forKey: KEY_IS_PREMIUM)
    }
    
    // 设置高级版状态
    private func setPremiumStatus(_ premium: Bool) {
        isPremium = premium
        userDefaults.set(premium, forKey: KEY_IS_PREMIUM)
    }
    
    // 首次启动时初始化keys
    private func initKeysAtFirstLaunch() {
        if userDefaults.object(forKey: KEY_FIRST_LAUNCH_DATE) == nil {
            userDefaults.set(Date(), forKey: KEY_FIRST_LAUNCH_DATE)
        }
        if userDefaults.object(forKey: KEY_USE_TIMES) == nil {
            userDefaults.set(0, forKey: KEY_USE_TIMES)
        }
    }
    
    // MARK: - StoreKit 相关方法
    
    // 使用次数加一
    func increaseUseTimes() {
        if let useTimes = userDefaults.integer(forKey: KEY_USE_TIMES) as Int? {
            userDefaults.set(useTimes+1, forKey: KEY_USE_TIMES)
        }
    }
    
    // 公共方法：设置会员状态
    func activatePremium() {
        setPremiumStatus(true)
    }
    
    // 检查是否需要显示购买提示
    func shouldShowPurchaseAlert() -> Bool {
        if isPremium {
            return false
        }
        
        // 检查限制
        switch limitPolicy {
        case .dayLimit:
            if let firstLaunchDate = userDefaults.object(forKey: KEY_FIRST_LAUNCH_DATE) as? Date {
                let daysSinceFirstLaunch = Calendar.current.dateComponents([.day], from: firstLaunchDate, to: Date()).day ?? 0
                if daysSinceFirstLaunch >= MAX_FREE_DAYS {
                    return true
                }
            }
        case .useLimit:
            if let useTimes = userDefaults.integer(forKey: KEY_USE_TIMES) as Int? {
                if useTimes >= MAX_USE_TIMES {
                    //print("超出次数限制")
                    return true
                } else {
                    //print("未超出次数限制")
                }
            }
        }
        
        return false
    }
    
    // 加载产品信息
    func loadProducts() async {
        //print("开始加载产品信息...")
        do {
            let productIdentifiers = Set([productID])
            products = try await Product.products(for: productIdentifiers)
            // print("✅ 成功加载产品: \(products.map { $0.id })")
            for product in products {
                // print("   - 产品ID: \(product.id)")
                // print("   - 显示价格: \(product.displayPrice)")
                // print("   - 本地化标题: \(product.displayName)")
                // print("   - 本地化描述: \(product.description)")
            }
        } catch {
            // print("❌ 加载产品失败: \(error)")
            errorMessage = "加载产品信息失败, 请稍后再试"
        }
    }
    
    // 购买产品
    func purchase() async throws {
        // print("开始购买产品: \(product.id)")
        guard let product = products.first else {
            throw StoreError.loadingError
        }
        isPurchasing = true
        do {
            let result = try await product.purchase()
            // print("收到购买结果: \(result)")
            
            switch result {
            case .success(let verification):
                // print("购买验证结果: \(verification)")
                if case .verified(let transaction) = verification {
                    // 购买成功，更新状态
                    await transaction.finish()
                    
                    // 设置高级版状态
                    setPremiumStatus(true)
                    
                    // print("✅ 购买成功: \(transaction.productID)")
                    // print("   - 交易ID: \(transaction.id)")
                    // print("   - 产品ID: \(transaction.productID)")
                    // print("   - 购买日期: \(transaction.purchaseDate)")
                } else {
                    // print("❌ 购买验证失败")
                    isPurchasing = false
                    throw StoreError.failedVerification
                }
                
            case .userCancelled:
                // print("用户取消购买")
                isPurchasing = false
                throw StoreError.userCancelled
                
            case .pending:
                // print("购买待处理")
                isPurchasing = false
                throw StoreError.pending
                
            @unknown default:
                // print("未知购买结果")
                isPurchasing = false
                throw StoreError.unknown
            }
        } catch {
            // print("❌ 购买失败: \(error)")
            isPurchasing = false
            throw error
        }
    }
    
    // 恢复购买
    func restorePurchases() async throws {
        // print("开始恢复购买...")
        do {
            try await AppStore.sync()
            for await result in Transaction.currentEntitlements {
                // print("检查交易: \(result)")
                if case .verified(let transaction) = result {
                    if transaction.productID == productID {
                        setPremiumStatus(true)
                    }
                    // print("✅ 找到已购买产品: \(transaction.productID)")
                } else {
                    // print("❌ 交易验证失败")
                }
            }
            if !isPremium {
                throw StoreError.noPurchaseRecord
            }
            
        } catch {
            // print("❌ 恢复购买失败: \(error)")
            throw error
        }
    }
    
}

// 错误类型
enum StoreError: LocalizedError {
    case failedVerification
    case userCancelled
    case loadingError
    case noPurchaseRecord
    case pending
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "购买验证失败"
        case .userCancelled:
            return "用户已取消购买"
        case .loadingError:
            return "产品加载失败，请稍后再试"
        case .noPurchaseRecord:
            return "没有找到购买记录，请稍后再试"
        case .pending:
            return "购买待处理"
        case .unknown:
            return "未知错误"
        }
    }
}

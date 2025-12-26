import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isInstructionExpanded = false
    
    var body: some View {
        ZStack {
            // 背景色
            AppConfigs.backgroundColor.edgesIgnoringSafeArea(.all)
            
            // 主内容
            VStack {
                // 设置列表
                List {
                    // 系统设置分组
                    Section(header: Text("系统设置").foregroundColor(.white).font(.title2)) {
                        
                        SettingsRowWithTextAndArrow(
                            iconName: "book.closed",
                            title: "使用说明",
                            rightText: "",
                            arrowIconName: isInstructionExpanded ? "chevron.up" : "chevron.down",
                            isLast: false,
                            action: {
                                withAnimation(.easeInOut) {
                                    isInstructionExpanded.toggle()
                                }
                            }
                        )
                        
                        // 条件显示的使用说明
                        if isInstructionExpanded {
                            // 显示使用说明
                            HelpContent()
                        }
                        
                        
                        SimpleSettingsRow(
                            iconName: "iphone",
                            title: "Qteqpid的更多宝藏作品",
                            isLast: false,
                            destination: AnyView(AppListView(backgroundColor: AppConfigs.backgroundColor))
                        )
                        
                    }
                    
                    // 联系我们分组
                    Section(header: Text("联系我们").foregroundColor(.white).font(.title2)) {
                        // 自定义组件用于打开小红书App
                        SettingsRow(iconName: "rednote_icon.png", title: "@Qteqpid", isLast: false) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            // 小红书App的URL Scheme
                            AppConfigs.openUrl(url: "https://xhslink.com/m/6ooRgc36BTt")
                        }
                        SettingsRow(iconName: "email_icon.png", title: "glloveyp@163.com", isLast: true) {
                            EmptyView()
                        }
                        
                    }
                    
                    // 其他分组
                    Section(header: Text("其他").foregroundColor(.white).font(.title2)) {
                        SimpleSettingsRow(iconName: "star", title: "给我们评分", isLast: false)
                            .onTapGesture {
                                // app store评分界面
                                AppConfigs.openUrl(url: "itms-apps://itunes.apple.com/app/id6748935753?action=write-review")
                            }

                        SettingsRowWithBadgeAndArrow(iconName: "info.circle", title: String.localizedStringWithFormat(NSLocalizedString("版本号 %@", comment: "版本号显示"), AppConfigs.appVersion), badgeText: "检查更新", badgeColor: Color.purple, isLast: true)
                            .onTapGesture {
                                AppConfigs.openUrl(url: AppConfigs.getAppStoreUrl(appId: "6748935753"))
                            }
                    }
                }
                .background(AppConfigs.backgroundColor)
                .scrollContentBackground(.hidden)
                .foregroundColor(.white)
                .listSectionSpacing(5)
            }
        }
        .whiteNavigationBarStyle("设置")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    }
                }
            }
        }
    }
    
}



// 使用说明内容组件
struct HelpContent: View {
    let helpItems: [String] = [
        "双击课程表中的任意单元格可编辑内容。",
        "长按任意行可插入或删除行。",
        "双击课程表标题或底部标语可进行修改。",
        "课程管理可添加或删除课程。",
        "课程表管理支持创建多个课程表，可在首页左右滑动切换。",
        "支持更改课程表背景色。",
        "点击主页导出按钮会将当前课程表保存为图片到相册，方便打印或分享。"
    ]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(helpItems, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 7, height: 7)
                        .padding(.top, 6)
                    Text(LocalizedStringKey(item))
                        .font(.system(size: 16))
                        .foregroundColor(Color.black)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color(.black).opacity(0.07), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 24)
    }
}

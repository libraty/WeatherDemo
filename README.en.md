# 项目名称
这是一个用于查看城市天气的项目。

## 功能介绍
- 实现了通过输入城市名称当时城市天气的功能
- 支持支持模糊搜索，即用户可以只输入城市名称一部分进行搜索，最少一个汉字或2个字符
## 环境依赖
- http: ^0.13.5
    用于发起网络 HTTP 请求，很可能是用来调用天气 API。
- provider: ^6.0.5
    一个流行的状态管理 (State Management) 解决方案，用于在应用的不同部分之间管理和共享数据（例如天气数据）。
- shared_preferences: ^2.0.15
    用于在设备上持久化存储简单的键值对数据，可能用于保存用户的设置（如默认城市、温度单位）或缓存的天气数据。
- fluttertoast: ^8.2.1
    用于在 Android 和 iOS 上显示 Toast 提示消息，可能用于显示网络请求成功或失败的提示。
- cached_network_image: ^3.2.3
    用于加载并缓存网络图片，很可能用于显示天气状况对应的图标。
- flutter_dotenv: ^5.1.0
    用于从 .env 文件加载环境变量。项目配置中包含了 assets: - .env，说明它会将 .env 文件作为资源加载，通常用于安全地存储 API 密钥等敏感信息。
## 技术栈
类别	        技术 / 依赖库	        说明
框架	        Flutter	                跨平台 UI 开发框架
状态管理	    provider	            管理全局 / 页面状态，实现 UI 响应
网络请求		http                    处理 HTTP 请求，封装接口调用
本地缓存	    shared_preferences	    存储天气数据缓存，减少重复请求
环境配置	    flutter_dotenv	        管理 API 密钥、基础 URL 等环境变量
## 项目结构
plaintext
lib/
├── main.dart                # 应用入口：初始化环境、配置状态管理、设置根Widget
├── core/                    # 核心工具与配置（支撑全局功能）
│   ├── constants.dart       # 全局常量：API路径、缓存键、超时时间等
│   ├── network/             # 网络模块
│   │   ├── api_client.dart  # 封装HTTP请求（GET）、响应处理、异常捕获
│   │   └── api_exception.dart # 自定义网络异常类（错误信息、状态码）
│   └── utils/               # 工具类
│       └── cache_manager.dart # 缓存管理：存储/读取/清理本地缓存
├── model/                   # 数据模型
│   └── weather_model.dart   # 天气数据结构定义（城市名、温度、天气状态等），含JSON解析方法
├── repository/              # 数据仓库（统一数据入口）
│   └── weather_repository.dart # 协调数据来源：优先读缓存，缓存失效则请求网络，返回标准化Model
├── viewmodel/               # 视图模型（业务逻辑层）
│   └── weather_viewmodel.dart # 管理UI状态（加载中/错误/成功）、调用仓库获取数据、通知UI更新
└── view/                    # 视图层（UI展示）
    ├── weather_screen.dart  # 主页面：含搜索栏、天气内容展示区
    └── widgets/             # 可复用UI组件
        ├── loading_indicator.dart # 加载指示器（动画+文字提示）
        └── weather_card.dart # 天气详情卡片：接收WeatherModel，展示温度、图标、湿度等信息
## 架构设计：MVVM
本项目采用 MVVM（Model-View-ViewModel） 架构，各层职责清晰，降低耦合：

层级	    组件 / 类	                    核心职责
Model	    WeatherModel	                定义数据结构，处理数据的序列化 / 反序列化
View	    WeatherScreen + Widgets	        仅负责 UI 渲染，通过Consumer监听 ViewModel 状态变化
ViewModel	WeatherViewModel	            隔离 View 与数据层：处理业务逻辑（如触发查询）、管理加载 / 错误状态、通知 UI 更新
Repository	WeatherRepository	            统一数据获取入口：屏蔽缓存 / 网络的实现细节，给 ViewModel 提供干净的数据接口
## 快速启动
- 克隆仓库
    bash
    git clone https://github.com/libraty/weatherdemo.git
    cd weather-app

- 安装依赖
    bash
    flutter pub get

- 配置环境变量
在项目根目录创建 .env 文件，配置天气 API 相关参数（示例）：
    env
    WEATHER_API_BASE_URL=https://api.example.com
    WEATHER_API_KEY=your_api_key_here
    CITY_LOOKUP_PATH=/v3/location/query
    WEATHER_NOW_PATH=/v3/weather/now

- 运行项目
    bash
    flutter run
- 导出apk
    bash
    flutter build apk
    文件在build\app\outputs\flutter-apk\app-release.apk
## 核心功能
城市天气查询：输入城市名，获取对应实时天气数据
多维度天气展示：温度、天气状态（图标）、湿度、风速、气压等
本地缓存优化：缓存有效期内优先使用本地数据，减少网络请求
状态可视化：加载中动画、错误提示（如网络异常、城市不存在）、空数据提示
## 备注
天气数据依赖第三方 API（如和风天气、高德天气等），需替换 .env 中的 WEATHER_API_BASE_URL、WEATHER_API_KEY 为有效配置
缓存默认有效期为 30 分钟，可在 core/constants.dart 中调整 CACHE_EXPIRY_MINUTES 常量
## 已知问题与改进方向
缓存没办法主动清空项目缓存，app的功能较为单一，显示信息较少，优化较差用起来比较卡顿，未来可以多做一些功能，跟进一下优化
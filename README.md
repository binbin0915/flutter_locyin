## 简介

Flutter 目前没有官方推荐的项目结构，为了易于维护，易于扩展， 提高开发速度，通过 Flutter 持续交付的最佳实践，所以我们必须在开发所有功能模块之前，发现这些模块开发过程中的共同点，将相似的代码归类，将差异较大的代码剥离，提高抽象的能力，笔者认为这就是 Flutter 项目的工程化。

![run_perform](https://img-blog.csdnimg.cn/20210718131658420.gif#pic_center)
![login_perform](https://img-blog.csdnimg.cn/20210718131711834.gif#pic_center)
![GetX](https://img-blog.csdnimg.cn/20210718131905654.gif#pic_center)

## 服务器端
- [码云](https://gitee.com/geekadpt/laravel_locyin)
- [GitHub](https://github.com/geekadpt/laravel_locyin)

## 特性
* 全面支持空安全
* 健全的日志系统
* 合理规范的开发流程，从零到一，由浅入深
* 使用饱受好评的第三方插件库
* 不以解决实际问题为最终目的的编程都是耍流氓

## 适宜人群

* 缺乏大型 Flutter 项目经验的开发人员
* 独立完成项目或毕设的大学生

## 项目结构

Flutter 作为最近很火的一个跨平台技术，以其高性能、跨平台的一系列优秀特性成功吸引了很多开发者和组织的青睐，真正实现了一次编码处处运行。但是由于其不同于传统 Android 或 iOS 开发的 Widget 机制，使得视图的代码往往冗长、不够简洁，解决这种困境的方法就是在开发中合理地运用合适的架构模式，使得程序的视图与数据分离，这样视图层的代码只用专心进行视图的描述和操作即可，不涉及过多复杂的数据操作，这样就可以使视图层的代码达到简洁。
Flutter 新项目主要包含以下几个目录：
* **android** –生成Android应用。任何关于Android的实现都将放在此文件夹中。

* **ios** -生成的iOS应用。任何关于iOS的实现都将放在此文件夹中。

* **web** -生成的Web应用。任何关于Web的实现都将放在此文件夹中。

* **lib**\-主要代码文件都在这里创建，main.dart -主文件

* **test**–用于单元测试

笔者参考了很多 Github 上面开源的 WanAndroid 项目，最终总结设计了一套我个人比较青睐的工程结构，从而大大提高生产力。
```
|---flutter_locyin
|     |---android  
|     |---assets  
|     |     |---fonts // 字体资源  
|     |     |---icon // 图标资源  
|     |     |---images // 图片资源  
|     |     |---json // 本地模拟JSON  
|     |---ios  
|     |---lib  
|     |     |---data  
|     |     |     |---api // http 接口和服务类  
|     |     |     |---model // 数据模型  
|     |     |---common
|     |     |     |---lang  // 语言目录
|     |     |          └──en_US // 英文语言包
|     |     |          └──zh_Hans // 中文语言包
|     |     |          └──translation_service // 翻译服务类
|     |     |---init // 启动目录
|     |     |     └── app_init.dart // 捕获异常 
|     |     |     └── default_app.dart // 默认 App 启动
|     |     |---page  
|     |     |     └── index.dart // 主要用于底部导航、状态保持  
|     |     |     └── xxx.dart // 所有页面布局，不再一一列出  
|     |     |---route // 路由目录
|     |     |     └── route_map.dart  // Getx 路由表  
|     |     |     └── route.dart // 二次封装 Getx
|     |     |---utils // 二次封装第三方库目录  
|     |     |     └── provider.dart // APP 状态管理  
|     |     |     └── sputils.dart // 数据持久化存储  
|     |     |     └── dio_manager.dart // 二次封装 Dio，配置信息、请求日志、自动处理错误等  
|     |     |---widgets // 封装的小部件目录  
|     |     └── main.dart // APP 入口文件  
|     |---test
|     |---web
|     └── pubspec.yaml //依赖配置管理  
```

## 配套文档
《Flutter 项目工程化》前四章将会一步步完成这个工程结构，依次对新增目录、文件和相应的插件的使用做详细说明。
- [看云](https://www.kancloud.cn/tiaohuaren/luoxun)
- [CSDN专栏](https://blog.csdn.net/geeksoarsky/category_11219095.html)




<div align=center>

![Logo](https://images.gitee.com/uploads/images/2021/0911/143905_6de74fd0_2215545.png "logo_128x128.png")

</div>


<div align=center>

[![Flutter][1]][2]  [![Dart][3]][4]  [![GitHub license][5]][6]  [![Github][7]][8]  [![CSDN][9]][10]  [![码云][11]][12]

[1]:https://img.shields.io/badge/Flutter-2.2.3-yellow.svg
[2]:https://flutter.dev

[3]:https://img.shields.io/badge/Dart-2.13.4-blueviolet.svg
[4]:https://dart.dev

[5]:https://img.shields.io/badge/License-Apache%202-critical.svg
[6]:https://github.com/geekadpt/luoxun_flutter/blob/main/LICENSE


[7]:https://img.shields.io/badge/GitHub-geekadpt-blue.svg
[8]:https://github.com/geekadpt

[9]:https://img.shields.io/badge/CSDN-geekadpt-green.svg
[10]:https://blog.csdn.net/geeksoarsky

[11]:https://img.shields.io/badge/Gitee-geekadpt-red.svg
[12]:https://gitee.com/geekadpt

</div>
一款基于 Flutter 的地图导游手机 APP，集地图导游和UGC于一体的 AI 游记产品。通过 5G+AI 的结合，从多方面搜集资料，为游客提供个性化的旅游服务。所有的数据和记录都由系统自动采集和整理，方便景区声誉的传播和更多有兴趣的游客去旅游、探险、挖掘。

## Demo
<div align=center>

##### 创建聊天会话 | 已读回执

![create_window_read_callback](https://img-blog.csdnimg.cn/b5f396abfbda49d2bd76e6306bd2bcee.gif#pic_center)

</div>



<div align=center>

##### 媒体资源

![send_assets](https://img-blog.csdnimg.cn/321746001b234868b903e6fe3b56f436.gif#pic_center)

</div>

<div align=center>

##### 语音消息 | 表情

![send_speech_emoji](https://img-blog.csdnimg.cn/2c77070dd3c545d7ade17174758ef81e.gif#pic_center)

</div>



<div align=center>

##### 视频通话

![video_call](https://img-blog.csdnimg.cn/ee77d4f1cabc4499b7da524d3cdb19d2.gif#pic_center)

</div>



<div align=center>

##### 深色模式 | 切换状态 | 保存草稿 | 侧滑删除置顶

![darkmode_status_draft_slidable](https://img-blog.csdnimg.cn/d76e0ec551f4471d801f152a90ffd275.gif#pic_center)

</div>



## 服务器端

- [GitHub](https://github.com/geekadpt/laravel_locyin)
- [码云](https://gitee.com/geekadpt/laravel_locyin)


我已经将 Laravel 服务器端部署到了云服务器上，基本接口地址为：`https://api.locyin.com/api/v1/`，应用程序的其他配置信息可以在'lib/common/config.dart'文件中修改

## 特性

* 全面支持空安全
* 健全的日志系统
* 合理规范的开发流程，从零到一，由浅入深
* 使用饱受好评的第三方插件库
* 集成高德地图
* 微信风格的即时通讯系统设计与实现

## 项目结构

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
|     |     |     └──config.dart // 全局设置类
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

## 文档
- [看云](https://www.kancloud.cn/tiaohuaren/luoxun)
- [CSDN(推荐)](https://blog.csdn.net/geeksoarsky/category_11219095.html)

## License
The flutter_locyin is open-sourced software licensed under the [Apache License, Version 2.0.](https://gitee.com/geekadpt/flutter_locyin/blob/master/LICENSE)


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
A map tour guide mobile app based on Flutter, an AI travel notes product integrating map tour guide and UGC. Through the combination of 5g + AI, collect data from many aspects to provide tourists with personalized tourism services. All data and records are automatically collected and sorted by the system to facilitate the dissemination of the reputation of the scenic spot and more interested tourists to travel, explore and mine.

## Demo
<div align=center>

##### Create Chat Window | Read Callback

![create_window_read_callback](https://img-blog.csdnimg.cn/b5f396abfbda49d2bd76e6306bd2bcee.gif#pic_center)

</div>



<div align=center>

##### Media Assets

![send_assets](https://img-blog.csdnimg.cn/321746001b234868b903e6fe3b56f436.gif#pic_center)

</div>

<div align=center>

##### Speech | Emoji

![send_speech_emoji](https://img-blog.csdnimg.cn/2c77070dd3c545d7ade17174758ef81e.gif#pic_center)

</div>



<div align=center>

##### Video Call

![video_call](https://img-blog.csdnimg.cn/ee77d4f1cabc4499b7da524d3cdb19d2.gif#pic_center)

</div>



<div align=center>

##### Dark Mode | Change Status | Save Draft | Slidable

![darkmode_status_draft_slidable](https://img-blog.csdnimg.cn/d76e0ec551f4471d801f152a90ffd275.gif#pic_center)

</div>



## Server Side

- [GitHub](https://github.com/geekadpt/laravel_locyin)
- [Gitee](https://gitee.com/geekadpt/laravel_locyin)


I have deployed the laravel server to the ECS. The basic interface address is:
`https://api.locyin.com/api/v1/`,Other configuration information of the app can be modified in the `lib/common/config.dart` file.

## Features

* Fully support null-safety

* Sound log system

* Reasonable and standardized development process, from zero to one, from shallow to deep

* Use the critically acclaimed third-party plug-in library

* Integrated Amap

* Design and implementation of instant messaging system in wechat style



## Suitable For

* Developers lacking experience in large-scale flutter projects
* College students who want to complete projects or graduate programs independently

## Project Structure

```
|---flutter_locyin
|     |---android  
|     |---assets  
|     |     |---fonts 
|     |     |---icon 
|     |     |---images 
|     |     |---json 
|     |---ios  
|     |---lib  
|     |     |---data  
|     |     |     |---api 
|     |     |     |---model 
|     |     |---common
|     |     |     |---lang  
|     |     |          └──en_US 
|     |     |          └──zh_Hans 
|     |     |          └──translation_service 
|     |     |     └──config.dart 
|     |     |---init 
|     |     |     └── app_init.dart 
|     |     |     └── default_app.dart 
|     |     |---page  
|     |     |     └── index.dart 
|     |     |     └── xxx.dart 
|     |     |---route 
|     |     |     └── route_map.dart  
|     |     |     └── route.dart 
|     |     |---utils 
|     |     |     └── getx.dart 
|     |     |     └── dio_manager.dart
|     |     |     └── xxx.dart 
|     |     |---widgets
|     |     └── main.dart
|     |---test
|     |---web
|     └── pubspec.yaml 
```

## Document 
- [Kancloud](https://www.kancloud.cn/tiaohuaren/luoxun)
- [CSDN(recommend)](https://blog.csdn.net/geeksoarsky/category_11219095.html)

## License
The flutter_locyin is open-sourced software licensed under the [Apache License, Version 2.0.](https://gitee.com/geekadpt/flutter_locyin/blob/master/LICENSE)
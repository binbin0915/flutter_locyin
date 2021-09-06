class Apis {

  /// 手机号获取短信验证码
  static const String LOGIN_CODES =  "loginCodes";

  /// 手机号登录
  static const String LOGIN_PHONE =  "loginByCode";

  /// 退出登录
  static const String USER_LOGOUT =  "users/logout";

  /// 用户个人信息
  static const String USER_INFO =  "users";

  /// 上传头像
  static const String UPLOAD_AVATAR =  "avatars";

  /// 游记列表
  static const String DYNAMIC ="dynamics";

  /// 点赞动态
  static const String THUMB_DYNAMIC = "dynamics/thumb";

  /// 收藏动态
  static const String COLLECT_DYNAMIC = "dynamics/collect";

  /// 游记列表
  static const String DYNAMIC_COMMENT ="dcomments";

  /// 评论模型
  static const String COMMENT =  "comments";


  /// 发布动态
  static const String PUBLISH_DYNAMIC =  "dynamics/publish";

  /// 上传图片
  static const String UPLOAD_IMAGE = "images";

  /// 初始化聊天室
  static const String INIT_MESSAGE = "messages/init";

  /// 聊天室列表
  static const String MESSAGE_LIST = "messages/list";

  /// 发送消息
  static const String SEND_MESSAGE = "messages/send";

  /// 上传文件
  static const String UPLOAD_FILES = "files";

  /// 聊天记录
  static const String MESSAGE_RECORD = "messages/record";

  /// 聊天状态
  static const String MESSAGE_STATUS = "messages/status";

  /// 已读消息
  static const String MESSAGE_READ = "messages/read";

  /// 创建窗口
  static const String MESSAGE_CREATE_WINDOW = "messages/window";

  /// 发起视频聊天请求
  static const String MESSAGE_VIDEO_CALL = "messages/video";

  /// 重置用户忙线状态(已废弃)
  static const String MESSAGE_RESET_BUSY = "messages/resetBusy";

  /// 视频通话回调
  static const String MESSAGE_VIDEO_CALLBACK = "messages/videoCallback";

  /// 已读消息回调
  static const String MESSAGE_READ_CALLBACK = "messages/readCallback";
}

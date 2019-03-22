# flutter_wananzhuo

1. [参考app](https://github.com/hurshi/wanandroid)
2. -[玩安卓网站](https://www.wanandroid.com/index)
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

#### 已知问题
  1. 登陆后没有刷新首页 不知道是否收藏
  2. 登陆后 重新启动app 不知此时http发送请求为何不携带cookie进行请求 导致首页不能及时显示是否收藏 
     只有下拉刷新一次才能判断时候进行了收藏
  3. 在主页面中的首页能滑动到项目页面，在项目页面中继续滑动，是切换tabBar,滑到最后一个时继续滑动，不能切换到公众      号界面


#### 使用到的组建
  1. [dio网络请求框架](https://github.com/flutterchina/dio) 
  2. [pull_to_refresh下拉刷新以及加载更多](https://github.com/peng8350/flutter_pulltorefresh) 
  3. [banner_view轮播图](https://github.com/yangxiaoweihn/BannerView) 
  4. [flutter_screenutil屏幕适配](https://github.com/OpenFlutter/flutter_ScreenUtil) 
  5. [flushbar像Snackbar一样弹出各式各样的弹窗](https://github.com/AndreHaueisen/flushbar) 
  6. [cached_network_image图片加载框架](https://github.com/renefloor/flutter_cached_network_image) 
  7. ...

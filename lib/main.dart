import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sixteenhome/utils/application.dart';
import 'package:flutter_sixteenhome/utils/translations.dart';
import 'package:flutter_sixteenhome/view/fragments/main_fragment.dart';
import 'package:flutter_sixteenhome/view/fragments/project_fragment.dart';
import 'package:flutter_sixteenhome/view/fragments/project_sort_fragment.dart';
import 'package:flutter_sixteenhome/view/fragments/wechat_subscription.dart';
import 'package:flutter_sixteenhome/view/login.dart';
import 'package:flutter_sixteenhome/view/search_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SpecificLocalizationDelegate _localeOverrideDelegate;

  @override
  void initState() {
    super.initState();
    _localeOverrideDelegate = new SpecificLocalizationDelegate(null);
    applic.onLocaleChanged = onLocaleChange;
  }

  onLocaleChange(Locale locale) {
    setState(() {
      _localeOverrideDelegate = new SpecificLocalizationDelegate(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        _localeOverrideDelegate, // 注册一个新的delegate
        TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: applic.supportedLocales(),
      initialRoute: "/",
      routes: {
        "/": (context) => MainAppPage(),
        "/login": (context) => LoginPageView(),
        "/search": (context) => SearchView(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: MainAppPage(),
    );
  }
}
/*

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: applic.supportedLocales(),
      initialRoute: "/",
      routes: {
        "/": (context) => MainAppPage(),
        "/login": (context) => LoginPageView(),
        "/search": (context) => SearchView(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: MainAppPage(),
    );
  }
}
*/

class MainAppPage extends StatefulWidget {
  @override
  _MainAppPageState createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Widget> myTabs = [];
  List tabData = [
    {'text': '首页', 'icon': new Icon(Icons.language)},
    {'text': '项目', 'icon': new Icon(Icons.extension)},
    {'text': '公众号', 'icon': new Icon(Icons.import_contacts)},
    {'text': '我的', 'icon': new Icon(Icons.person)}
  ];

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, vsync: this, length: 6);

    for (var item in tabData) {
      myTabs.add(Tab(
        text: item["text"],
        icon: item["icon"],
      ));
    }
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _onTabChange();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          MainFragment(), //首页
          ProjectFragment(), //项目
          WeChatSubscription(), //公众号
          ProjectSortFragment(), //我的
        ],
      ),
      bottomNavigationBar: Material(
        color: Color(0xFFF0EEEF), //底部导航栏主题颜色
        child: SafeArea(
          child: Container(
            height: 65.0,
            child: TabBar(
              controller: _tabController,
              tabs: myTabs,
              indicatorWeight: 3.0,
              labelColor: Colors.blue,
              indicatorColor: Colors.transparent,
              unselectedLabelColor: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  void _onTabChange() {
    if (this.mounted) {
      this.setState(() {});
    }
  }
}

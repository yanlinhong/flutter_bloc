import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/ui/page/page_index.dart';
import 'common/component_index.dart';
import 'data/net/dio_util.dart';

void main() => runApp(BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: BlocProvider(child: MyApp(), bloc: MainBloc()),
    ));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Locale _locale;
  Color _themeColor = Colours.app_main;

  @override
  void initState() {
    super.initState();
    setLocalizedValues(localizedValues);
    _init();
    _initAsync();
    _initListener();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
     /* routes: {
        '/MainPage': (ctx) => MainPage(),
      },*/
      home: new MainPage(),
      theme: ThemeData.light().copyWith(
        primaryColor: _themeColor,
        accentColor: _themeColor,
        indicatorColor: Colors.white,
      ),
      locale: _locale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        CustomLocalizations.delegate
      ],
      supportedLocales: CustomLocalizations.supportedLocales,
    );
  }

  void _init() {
    DioUtil.openDebug();
    Options options = DioUtil.getDefOptions();
    options.baseUrl = Constant.server_address;
    HttpConfig config = new HttpConfig(options: options);
    DioUtil().setConfig(config);
  }

  void _initAsync() async {
    await SpUtil.getInstance();
    if (!mounted) {
      return;
    }
    _loadLocale();
  }

  void _initListener() {
    final ApplicationBloc bloc = BlocProvider.of<ApplicationBloc>(context);
    bloc.appEventStream.listen((value) {
      _loadLocale();
    });
  }

  void _loadLocale() {
    setState(() {
      LanguageModel model =
          SpHelper.getObject<LanguageModel>(Constant.keyLanguage);
      if (model != null) {
        _locale = new Locale(model.languageCode, model.countryCode);
      } else {
        _locale = null;
      }
      String _colorKey = SpHelper.getThemeColor();
      if (themeColorMap[_colorKey] != null) {
        _themeColor = themeColorMap[_colorKey];
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

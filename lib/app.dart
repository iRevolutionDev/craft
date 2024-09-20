import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:craft/app/cubit/theme_cubit/theme_cubit.dart';
import 'package:craft/i18n/translations.g.dart';
import 'package:craft/routes/router.dart';
import 'package:craft/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => ThemeCubit()),
    ], child: const _App());
  }
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = LocaleSettings.currentLocale.languageTag;

    return TranslationProvider(
      child: RepositoryProvider(
        create: (_) => null,
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, theme) {
            return MaterialApp.router(
              title: "Ocet Design",
              theme: Themes.light,
              darkTheme: Themes.dark,
              themeMode: theme,
              locale: TranslationProvider.of(context).flutterLocale,
              supportedLocales: AppLocaleUtils.supportedLocales,
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter,
            );
          },
        ),
      ),
    );
  }
}

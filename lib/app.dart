import 'package:craft/app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:craft/app/bloc/connection_bloc/connection_bloc.dart';
import 'package:craft/app/cubit/theme_cubit/theme_cubit.dart';
import 'package:craft/di/di.dart';
import 'package:craft/i18n/translations.g.dart';
import 'package:craft/routes/router.dart';
import 'package:craft/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => ThemeCubit()),
      BlocProvider(create: (_) => getIt<ConnectionBloc>()),
      BlocProvider(create: (_) => getIt<AuthenticationBloc>()),
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
              title: "Craft",
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

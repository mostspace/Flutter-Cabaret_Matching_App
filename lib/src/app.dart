import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:datingapp/src/routing/app_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DatingApp extends ConsumerWidget {
  const DatingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(1125, 2436),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final goRouter = ref.watch(goRouterProvider);
        return MaterialApp.router(
          routerConfig: goRouter,
          debugShowCheckedModeBanner: false,
          title: 'DatingApp',
          // theme: ThemeData(
          //     pageTransitionsTheme: const PageTransitionsTheme(builders: {
          //   TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          //   TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          // })),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}

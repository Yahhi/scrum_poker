import 'package:flutter/material.dart';

import 'main_route_path.dart';

class MainRouteInformationParser extends RouteInformationParser<MainRoutePath> {
  @override
  Future<MainRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    if (routeInformation.location == null) {
      return MainRoutePath.unknown();
    }

    final uri = Uri.parse(routeInformation.location!);
    final routeParts = uri.pathSegments;

    // Handle '/'
    if (routeParts.isEmpty) {
      return MainRoutePath.splash();
    }

    final pageData = <PageData>[];
    while (routeParts.isNotEmpty) {
      final pageType = PageData.findType(routeParts.first);
      if (pageType == null) {
        pageData.add(const PageData(PageType.page404));
        break;
      }
      routeParts.removeAt(0);
      String? param;
      if (routeParts.isNotEmpty && PageData.canHaveParam(pageType)) {
        final nextPageType = PageData.findType(routeParts.first);
        if (nextPageType == null) {
          param = routeParts[1];
          routeParts.removeAt(0);
        }
      }
      pageData.add(PageData(pageType, param: param));
    }
    return MainRoutePath(pageData);
  }

  @override
  RouteInformation? restoreRouteInformation(MainRoutePath configuration) {
    final stringBuilder = StringBuffer();
    for (var pageInfo in configuration.pages) {
      stringBuilder.write(pageInfo.pageType.pathWord);
      if (pageInfo.param != null) {
        stringBuilder.write('/${pageInfo.param}');
      }
    }
    return RouteInformation(location: stringBuilder.toString());
  }
}

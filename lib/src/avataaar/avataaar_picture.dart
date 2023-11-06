import 'dart:convert';

import 'package:flutter_avataaar/src/avataaar/avataaar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avataaar/src/helpers/hex_color.dart';
import 'package:flutter_svg/svg.dart';

import 'package:http/http.dart' as http;
import '../helpers/avataaar_api.dart';

///Easiest way to render the Avataaar using the [SvgPicture] package. Builder could be customized.
class AvataaarPicture extends StatelessWidget {
  final Widget Function(BuildContext context, Avataaar avataaar)? customBuilder;
  final Avataaar avatar;
  final Widget? placeholder;
  final Widget? errorWidget;
  final void Function(Exception exception)? onError;

  AvataaarPicture.builder({
    Key? key,
    this.customBuilder,
    this.placeholder,
    this.errorWidget,
    this.onError,
    required this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return customBuilder?.call(context, avatar) ??
        FutureBuilder<String>(
          future: fetchSvg(avatar.toUrl()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var string = snapshot.data!;

              // FROM API TO CHANGE BACKGROUND COLOR
              if (avatar.backgroundColor != AvataaarsApi.baseBackgroundColor) {
                string = BackgroundColorHelper.getSvgWithBackground(
                    string, avatar.backgroundColor);
              }
              return SvgPicture.string(
                string,
                placeholderBuilder: (context) =>
                    placeholder ?? CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return errorWidget ??
                  Icon(
                    Icons.error,
                    size: 200.0,
                  );
            } else {
              return Center(
                child: placeholder ?? CircularProgressIndicator(),
              );
            }
          },
        );
  }

  ///Easiest way to fetch the SVG doing HTTP request
  Future<String> fetchSvg(String url) async {
    try {
      if (Avataaar.cachedUrls.containsKey(avatar.toUrl())) {
        return Avataaar.cachedUrls[avatar.toUrl()]!;
      }
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then save it and parse the JSON.
        Avataaar.cachedUrls.putIfAbsent(avatar.toUrl(), () => response.body);
        return response.body;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        onError?.call(Exception('Failed to load SVG'));
        throw Exception('Failed to load SVG');
      }
    } on Exception catch (e) {
      onError?.call(e);
      rethrow;
    }
  }
}

class AvatarPicture extends StatelessWidget {
  final Widget Function(BuildContext context, String avataaar)? customBuilder;
  final String url;
  final Widget? placeholder;
  final Widget? errorWidget;
  final void Function(Exception exception)? onError;
  final String? proxyUrl;

  const AvatarPicture.builder({
    Key? key,
    this.customBuilder,
    this.placeholder,
    this.errorWidget,
    this.onError,
    this.proxyUrl,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finalUrl =
        proxyUrl != null ? '$proxyUrl${base64Encode(utf8.encode(url))}' : url;
    return customBuilder?.call(context, finalUrl) ??
        FutureBuilder<String>(
          future: fetchSvg(finalUrl),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var string = snapshot.data!;

              return SvgPicture.string(
                string,
                placeholderBuilder: (context) =>
                    placeholder ?? const CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return errorWidget ??
                  const Icon(
                    Icons.error,
                  );
            } else {
              return Center(
                child: placeholder ?? const CircularProgressIndicator(),
              );
            }
          },
        );
  }

  ///Easiest way to fetch the SVG doing HTTP request
  Future<String> fetchSvg(String url) async {
    try {
      if (Avataaar.cachedUrls.containsKey(url)) {
        return Avataaar.cachedUrls[url]!;
      }
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then save it and parse the JSON.
        Avataaar.cachedUrls.putIfAbsent(url, () => response.body);
        return response.body;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        onError?.call(Exception('Failed to load SVG'));
        throw Exception('Failed to load SVG');
      }
    } on Exception catch (e) {
      onError?.call(e);
      rethrow;
    }
  }
}

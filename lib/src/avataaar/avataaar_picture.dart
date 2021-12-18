import 'package:flutter_avataaar/src/avataaar/avataaar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_avataaar/src/helpers/hex_color.dart';
import 'package:flutter_svg/svg.dart';

import 'package:http/http.dart' as http;
import '../helpers/avataaar_api.dart';

class AvataaarPicture extends StatelessWidget {
  final String baseUrl;
  final Widget Function(BuildContext context, Avataaar avataaar)? customBuilder;
  final Avataaar avatar;
  final Widget? placeholder;
  final Widget? errorWidget;

  AvataaarPicture.builder({
    Key? key,
    this.customBuilder,
    this.baseUrl = AvataaarsApi.baseUrl,
    this.placeholder,
    this.errorWidget,
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

              /// FROM API TO CHANGE BACKGROUND COLOR
              if (avatar.backgroundColor != null) {
                string = snapshot.data!.replaceFirst(
                  '#65C9FF',
                  avatar.backgroundColor!.toHex(),
                  snapshot.data!.indexOf('Color/Palette/Blue-01'),
                );
              }
              return SvgPicture.string(
                string,
                placeholderBuilder:
                    placeholder != null ? (context) => placeholder! : (context) => CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return errorWidget ??
                  Icon(
                    Icons.error,
                    size: 200.0,
                  );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
  }
}

Future<String> fetchSvg(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load SVG');
  }
}
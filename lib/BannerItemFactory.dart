import 'package:flutter/material.dart';

import 'package:flutter_sixteenhome/Pair.dart';

/// Crated by yangxiaowei
class BannerItemFactory {
  static List<Widget> banners(List<Pair<String, Color>> param) {
    List<Widget> _renderBannerItem(List<Pair<String, Color>> param) {
      return param.map((item) {
        final text = item.first;
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            width: 50,
            child: Image.network(
              text,
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList();
    }

    return _renderBannerItem(param);
  }
}

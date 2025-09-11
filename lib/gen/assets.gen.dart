// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/login.png
  AssetGenImage get login => const AssetGenImage('assets/images/login.png');

  /// File path: assets/images/splash.png
  AssetGenImage get splash => const AssetGenImage('assets/images/splash.png');

  /// File path: assets/images/title.png
  AssetGenImage get title => const AssetGenImage('assets/images/title.png');

  /// List of all assets
  List<AssetGenImage> get values => [login, splash, title];
}

class $AssetsVectorsGen {
  const $AssetsVectorsGen();

  /// File path: assets/vectors/activities.svg
  SvgGenImage get activities =>
      const SvgGenImage('assets/vectors/activities.svg');

  /// File path: assets/vectors/activities_active.svg
  SvgGenImage get activitiesActive =>
      const SvgGenImage('assets/vectors/activities_active.svg');

  /// File path: assets/vectors/calendar.svg
  SvgGenImage get calendar => const SvgGenImage('assets/vectors/calendar.svg');

  /// File path: assets/vectors/calendar_active.svg
  SvgGenImage get calendarActive =>
      const SvgGenImage('assets/vectors/calendar_active.svg');

  /// File path: assets/vectors/hide.svg
  SvgGenImage get hide => const SvgGenImage('assets/vectors/hide.svg');

  /// File path: assets/vectors/home.svg
  SvgGenImage get home => const SvgGenImage('assets/vectors/home.svg');

  /// File path: assets/vectors/home_active.svg
  SvgGenImage get homeActive =>
      const SvgGenImage('assets/vectors/home_active.svg');

  /// File path: assets/vectors/kpi.svg
  SvgGenImage get kpi => const SvgGenImage('assets/vectors/kpi.svg');

  /// File path: assets/vectors/kpi_active.svg
  SvgGenImage get kpiActive =>
      const SvgGenImage('assets/vectors/kpi_active.svg');

  /// File path: assets/vectors/notification.svg
  SvgGenImage get notification =>
      const SvgGenImage('assets/vectors/notification.svg');

  /// File path: assets/vectors/setting.svg
  SvgGenImage get setting => const SvgGenImage('assets/vectors/setting.svg');

  /// File path: assets/vectors/show.svg
  SvgGenImage get show => const SvgGenImage('assets/vectors/show.svg');

  /// File path: assets/vectors/tasks.svg
  SvgGenImage get tasks => const SvgGenImage('assets/vectors/tasks.svg');

  /// File path: assets/vectors/tasks_active.svg
  SvgGenImage get tasksActive =>
      const SvgGenImage('assets/vectors/tasks_active.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    activities,
    activitiesActive,
    calendar,
    calendarActive,
    hide,
    home,
    homeActive,
    kpi,
    kpiActive,
    notification,
    setting,
    show,
    tasks,
    tasksActive,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsVectorsGen vectors = $AssetsVectorsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

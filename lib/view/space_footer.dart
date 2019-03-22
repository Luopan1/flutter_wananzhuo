import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/math/mat2d.dart';
import "package:flare_flutter/flare_actor.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';


class SpaceFooter extends RefreshFooter {
  SpaceFooter({
    @required GlobalKey<RefreshFooterState> key,
    double loadHeight = 180.0,
  }) : super(
    key: key ?? new GlobalKey<RefreshFooterState>(),
    loadHeight: loadHeight,
  );

  @override
  SpaceFooterState createState() => SpaceFooterState();
}

class SpaceFooterState extends RefreshFooterState<SpaceFooter>
    implements FlareController {
  ActorAnimation _loadingAnimation;
  ActorAnimation _successAnimation;
  ActorAnimation _pullAnimation;
  ActorAnimation _cometAnimation;

  double _pulledExtent;
  double _refreshTriggerPullDistance;
  double _successTime = 0.0;
  double _loadingTime = 0.0;
  double _cometTime = 0.0;

  // 是否环绕
  bool _isSurround;

  // 初始化
  @override
  void initState() {
    super.initState();
    _pulledExtent = 0.0;
    _refreshTriggerPullDistance = widget.loadHeight;
    _isSurround = false;
  }

  void initialize(FlutterActorArtboard actor) {
    _pullAnimation = actor.getAnimation("pull");
    _successAnimation = actor.getAnimation("success");
    _loadingAnimation = actor.getAnimation("loading");
    _cometAnimation = actor.getAnimation("idle comet");
  }

  void setViewTransform(Mat2D viewTransform) {}

  bool advance(FlutterActorArtboard artboard, double elapsed) {
    double animationPosition = _pulledExtent / _refreshTriggerPullDistance;
    animationPosition *= animationPosition;
    _cometTime += elapsed;
    _cometAnimation.apply(_cometTime % _cometAnimation.duration, artboard, 1.0);
    _pullAnimation.apply(
        _pullAnimation.duration * animationPosition, artboard, 1.0);
    if (_isSurround) {
      _successTime += elapsed;
      if (_successTime >= _successAnimation.duration) {
        _loadingTime += elapsed;
      }
    } else {
      _successTime = _loadingTime = 0.0;
    }
    if (_successTime >= _successAnimation.duration) {
      _loadingAnimation.apply(
          _loadingTime % _loadingAnimation.duration, artboard, 1.0);
    } else if (_successTime > 0.0) {
      _successAnimation.apply(_successTime, artboard, 1.0);
    }
    return true;
  }

  // 开始刷新
  @override
  void onLoadStart() {
    _successTime = _loadingTime = _cometTime = 0.0;
    super.onLoadStart();
  }

  // 正在刷新
  @override
  void onLoading() {
    _isSurround = true;
    super.onLoading();
  }

  // 刷新结束
  @override
  void onLoadEnd() {
    _isSurround = false;
    super.onLoadEnd();
  }

  // 高度更新
  @override
  void updateHeight(double newHeight) {
    _pulledExtent = newHeight;
    _refreshTriggerPullDistance = widget.loadHeight;
    super.updateHeight(newHeight);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      child: height > 0.0
          ? FlareActor("assets/flare/Space Demo.flr",
          alignment: Alignment.center,
          animation: "idle",
          fit: BoxFit.cover,
          controller: this)
          : Container(),
    );
  }
}
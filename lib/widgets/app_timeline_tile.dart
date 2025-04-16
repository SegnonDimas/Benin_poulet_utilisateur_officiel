import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AppTimelineTile extends StatefulWidget {
  TimelineAlign? alignment;
  TimelineAxis? axis;
  IconData? icon;
  Color? iconColor;
  Color? color;
  Color? beforeLineColor;
  Color? afterLineColor;
  double? beforeLineWeight;
  double? afterLineWeight;
  double? iconSize;
  double? width;
  double? height;
  double? indicatorXY;
  double? lineXY;
  int? flex;
  int? index;
  bool? drawGap;
  bool? hasIndicator;
  bool? isFirst;
  bool? isLast;
  Widget? indicator;
  Widget? startChild;
  Widget? endChild;
  Function()? onTap;

  AppTimelineTile({
    super.key,
    this.alignment = TimelineAlign.start,
    this.axis = TimelineAxis.vertical,
    this.icon = Icons.done,
    this.iconColor = Colors.white,
    this.color = Colors.grey,
    this.beforeLineColor = Colors.grey,
    this.afterLineColor = Colors.grey,
    this.beforeLineWeight = 4,
    this.afterLineWeight = 4,
    this.iconSize,
    this.width = 20,
    this.height = 20,
    this.indicatorXY = 0.5,
    this.flex = 1,
    this.index,
    this.drawGap = false,
    this.indicator,
    this.startChild,
    this.endChild,
    this.lineXY,
    this.hasIndicator = true,
    this.isFirst = false,
    this.isLast = false,
    this.onTap,
  });

  @override
  State<AppTimelineTile> createState() => _AppTimelineTileState();
}

class _AppTimelineTileState extends State<AppTimelineTile> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: GestureDetector(
        onTap: widget.onTap,
        child: TimelineTile(
          alignment: widget.alignment!,
          axis: widget.axis!,
          indicatorStyle: IndicatorStyle(
            iconStyle: IconStyle(
              iconData: widget.icon!,
              color: widget.iconColor!,
              fontSize: widget.iconSize,
            ),
            color: widget.color!,
            width: widget.width!,
            height: widget.height!,
            indicator: widget.indicator,
            indicatorXY: widget.indicatorXY!,
            drawGap: widget.drawGap!,
          ),
          beforeLineStyle: LineStyle(
              color: widget.beforeLineColor!,
              thickness: widget.beforeLineWeight!),
          afterLineStyle: LineStyle(
              color: widget.afterLineColor!,
              thickness: widget.afterLineWeight!),
          lineXY: widget.lineXY,
          isLast: widget.isLast!,
          isFirst: widget.isFirst!,
          hasIndicator: widget.hasIndicator!,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/widgets/category/item_selector.dart';
import 'package:artivation/ui/widgets/category/menu_controller.dart';
import 'package:artivation/ui/zoom_scafford.dart';
import 'package:artivation/utils/enum.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';

final menuScreenKey = new GlobalKey(debugLabel: 'Artivation');

class MenuScreen extends StatefulWidget {
  final MainModel model;

  MenuScreen({
    this.model,
  }) : super(key: menuScreenKey);

  @override
  _MenuScreenState createState() => new _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  AnimationController titleAnimationController;
  double selectorYTop;
  double selectorYBottom;

  setSelectedRenderBox(RenderBox newRenderBox) async {
    final newYTop = newRenderBox.localToGlobal(const Offset(0.0, 0.0)).dy;
    final newYBottom = newYTop + newRenderBox.size.height;
    if (newYTop != selectorYTop) {
      setState(() {
        selectorYTop = newYTop;
        selectorYBottom = newYBottom;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    titleAnimationController = new AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    titleAnimationController.dispose();
    super.dispose();
  }

  createMenuTitle(MenuController menuController) {
    switch (menuController.state) {
      case MenuState.open:
      case MenuState.opening:
        titleAnimationController.forward();
        break;
      case MenuState.closed:
      case MenuState.closing:
        titleAnimationController.reverse();
        break;
    }

    return new AnimatedBuilder(
        animation: titleAnimationController,
        child: new OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.topLeft,
          child: new Padding(
            padding: const EdgeInsets.all(30.0),
            child: new Text(
              '',
              style: new TextStyle(
                color: const Color(0x88444444),
                fontSize: 240.0,
                fontFamily: 'mermaid',
              ),
              textAlign: TextAlign.left,
              softWrap: false,
            ),
          ),
        ),
        builder: (BuildContext context, Widget child) {
          return new Transform(
            transform: new Matrix4.translationValues(
              250.0 * (1.0 - titleAnimationController.value) - 100.0,
              0.0,
              0.0,
            ),
            child: child,
          );
        });
  }

  createMenuItems(MenuController menuController) {
    return ListView(
      padding: EdgeInsets.only(top:100),
        children: Category.values
            .map((Category category) => GestureDetector(
                onTap: () {
                  widget.model.setCategory(category).then((value) {
                    menuController.close();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 50.0, top: 15.0, bottom: 15.0),
                  child: new Text(
                    category
                        .toString()
                        .replaceAll('Category.', '')
                        .toUpperCase(),
                    style: new TextStyle(
                      color: widget.model.selectedCategory == category
                          ? UIData.primaryColor
                          : Colors.white,
                      fontSize: 25.0,
                      fontFamily: 'bebas-neue',
                      letterSpacing: 2.0,
                    ),
                  ),
                )))
            .toList(),
      );
  }

  @override
  Widget build(BuildContext context) {
    return new ZoomScaffoldMenuController(
        builder: (BuildContext context, MenuController menuController) {
      var shouldRenderSelector = true;
      var actualSelectorYTop = selectorYTop;
      var actualSelectorYBottom = selectorYBottom;
      var selectorOpacity = 1.0;

      if (menuController.state == MenuState.closed ||
          menuController.state == MenuState.closing ||
          selectorYTop == null) {
        final RenderBox menuScreenRenderBox =
            context.findRenderObject() as RenderBox;

        if (menuScreenRenderBox != null) {
          final menuScreenHeight = menuScreenRenderBox.size.height;
          actualSelectorYTop = menuScreenHeight - 50.0;
          actualSelectorYBottom = menuScreenHeight;
          selectorOpacity = 0.0;
        } else {
          shouldRenderSelector = false;
        }
      }

      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/dark_grunge_bk.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: new Material(
          color: Colors.transparent,
          child: new Stack(
            children: [
              createMenuTitle(menuController),
              createMenuItems(menuController),
              shouldRenderSelector
                  ? new ItemSelector(
                      topY: actualSelectorYTop,
                      bottomY: actualSelectorYBottom,
                      opacity: selectorOpacity,
                    )
                  : new Container(),
            ],
          ),
        ),
      );
    });
  }
}



class AnimatedMenuListItem extends ImplicitlyAnimatedWidget {
  final _MenuListItem menuListItem;
  final MenuState menuState;
  final bool isSelected;
  final Duration duration;

  AnimatedMenuListItem({
    this.menuListItem,
    this.menuState,
    this.isSelected,
    this.duration,
    curve,
  }) : super(duration: duration, curve: curve);

  @override
  _AnimatedMenuListItemState createState() => new _AnimatedMenuListItemState();
}

class _AnimatedMenuListItemState
    extends AnimatedWidgetBaseState<AnimatedMenuListItem> {
  final double closedSlidePosition = 200.0;
  final double openSlidePosition = 0.0;

  Tween<double> _translation;
  Tween<double> _opacity;

  updateSelectedRenderBox() {
    final renderBox = context.findRenderObject() as RenderBox;
    if (renderBox != null && widget.isSelected) {
      (menuScreenKey.currentState as _MenuScreenState)
          .setSelectedRenderBox(renderBox);
    }
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    var slide, opacity;

    switch (widget.menuState) {
      case MenuState.closed:
      case MenuState.closing:
        slide = closedSlidePosition;
        opacity = 0.0;
        break;
      case MenuState.open:
      case MenuState.opening:
        slide = openSlidePosition;
        opacity = 1.0;
        break;
    }

    _translation = visitor(
      _translation,
      slide,
      (dynamic value) => new Tween<double>(begin: value),
    );

    _opacity = visitor(
      _opacity,
      opacity,
      (dynamic value) => new Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    updateSelectedRenderBox();

    return new Opacity(
      opacity: _opacity.evaluate(animation),
      child: new Transform(
        transform: new Matrix4.translationValues(
          0.0,
          _translation.evaluate(animation),
          0.0,
        ),
        child: widget.menuListItem,
      ),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function() onTap;

  _MenuListItem({
    this.title,
    this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      splashColor: const Color(0x44000000),
      onTap: isSelected ? null : onTap,
      child: Container(
        width: double.infinity,
        child: new Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
          child: new Text(
            title,
            style: new TextStyle(
              color: isSelected ? UIData.primaryColor : Colors.white,
              fontSize: 25.0,
              fontFamily: 'bebas-neue',
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

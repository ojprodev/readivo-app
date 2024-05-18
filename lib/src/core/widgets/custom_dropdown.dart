import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/constants/colors.dart';

class CustomDropDown<T> extends StatefulWidget {
  final List<CustomDropdownMenuItem<T>> items;
  final Function(T) onChanged;
  final String hintText;
  final double borderRadius;
  final double maxListHeight;
  final double borderWidth;
  final int defaultSelectedIndex;
  final bool enabled;
  final double width;
  final Color borderColor;
  final Color backgroundColor;
  final double elevation;
  final Widget icon;
  final Color? buttonBackground;
  final Color? iconBackground;
  final Color? dropdownBackground;

  const CustomDropDown({
    required this.items,
    required this.onChanged,
    this.hintText = "",
    this.borderRadius = 14,
    this.borderWidth = 1,
    this.maxListHeight = 200,
    this.defaultSelectedIndex = -1,
    this.enabled = true,
    this.width = 200,
    this.borderColor = AppColors.lightGrey,
    this.backgroundColor = Colors.white,
    this.elevation = 0,
    this.icon = const Icon(Icons.arrow_drop_down),
    this.buttonBackground = Colors.transparent,
    this.iconBackground = Colors.transparent,
    this.dropdownBackground = Colors.white,
    super.key,
  });

  @override
  _CustomDropDownState<T> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>>
    with WidgetsBindingObserver {
  bool _isOpen = false;
  bool _isAnyItemSelected = false;
  late OverlayEntry _overlayEntry;
  Widget? _itemSelected;
  late Offset dropDownOffset;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        dropDownOffset = _getOffset();
        if (widget.defaultSelectedIndex > -1 &&
            widget.defaultSelectedIndex < widget.items.length) {
          setState(() {
            _isAnyItemSelected = true;
            _itemSelected = widget.items[widget.defaultSelectedIndex].child;
            widget.onChanged(widget.items[widget.defaultSelectedIndex].value);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _toggleOverlay() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _addOverlay();
    }
  }

  void _addOverlay() {
    setState(() {
      _isOpen = true;
    });
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
  }

  void _removeOverlay() {
    setState(() {
      _isOpen = false;
    });
    _overlayEntry.remove();
  }

  OverlayEntry _createOverlayEntry() {

    return OverlayEntry(
      maintainState: false,
      builder: (context) => Positioned(
        width: widget.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: dropDownOffset,
          child: Material(
            elevation: widget.elevation,
            shadowColor: Colors.black,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Container(
              decoration: _getDropdownDecoration(),
              constraints: BoxConstraints(
                maxHeight: widget.maxListHeight,
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAnyItemSelected = true;
                        _itemSelected = widget.items[index].child;
                        _removeOverlay();
                        widget.onChanged(widget.items[index].value);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: widget.dropdownBackground,
                      ),
                      child: widget.items[index].child,
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 1,
                    width: widget.width,
                    color: Colors.grey[100],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Offset _getOffset() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    double y = renderBox.localToGlobal(Offset.zero).dy;
    double spaceAvailable =
        MediaQuery.of(context).size.height - y - renderBox.size.height;
    if (spaceAvailable > widget.maxListHeight) {
      return Offset(0, renderBox.size.height);
    } else {
      return Offset(0, -widget.maxListHeight);
    }
  }

  BoxDecoration _getDropdownDecoration() {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      boxShadow: const [
        BoxShadow(
          color: AppColors.lightGrey,
          blurRadius: 4,
          spreadRadius: 1,
          offset: Offset(0, 1),
        ),
      ],
    );
  }

  BoxDecoration _getContainerDecoration() {
    return BoxDecoration(
      color: widget.backgroundColor,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      border: Border.all(color: widget.borderColor, width: widget.borderWidth),
      boxShadow: _isOpen
          ? [
              const BoxShadow(
                color: AppColors.lightGrey,
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(0, 1),
              ),
            ]
          : [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.enabled ? _toggleOverlay : null,
        child: Container(
          width: widget.width,
          decoration: _getContainerDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  color: widget.buttonBackground,
                  padding: const EdgeInsets.all(10.0),
                  child: _isAnyItemSelected
                      ? _itemSelected!
                      : Text(
                          widget.hintText,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                color: widget.iconBackground,
                child: widget.icon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDropdownMenuItem<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const CustomDropdownMenuItem({
    super.key,
    required this.value,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  List<RadioModel> data = [];
  final Function(int) onChanged;

  CustomRadio({required this.data, required this.onChanged});
  @override
  createState() {
    return CustomRadioState();
  }
}

class CustomRadioState extends State<CustomRadio> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: widget.data.length * 50,
      padding: EdgeInsets.symmetric(
        vertical: 5,
      ),
      alignment: Alignment.centerRight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.data.length,
        itemBuilder: (BuildContext context, int index) {
          return FittedBox(
            child: IconButton(
              onPressed: () {
                setState(() {
                  widget.data.forEach((element) => element.isSelected = false);
                  widget.data[index].isSelected = true;
                  widget.onChanged(index);
                });
              },
              icon: Icon(
                widget.data[index].icon,
                size: widget.data[index].iconSize == 0
                    ? 30.0
                    : widget.data[index].iconSize,
              ),
              iconSize: 30.0,
              color: widget.data[index].isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primaryContainer,
            ),
          );
        },
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(_item.icon),
            iconSize: _item.iconSize == 0 ? 30.0 : _item.iconSize,
            color: _item.isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final IconData icon;
  final double iconSize;

  RadioModel(
      {required this.isSelected,
      required this.buttonText,
      required this.icon,
      this.iconSize = 0});
}

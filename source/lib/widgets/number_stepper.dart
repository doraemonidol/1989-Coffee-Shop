import 'package:flutter/material.dart';

class NumberStepper extends StatefulWidget {
  final int initialValue;
  final int min;
  final int max;
  final int step;

  final Function(int) onChanged;

  const NumberStepper(
      {super.key,
      required this.initialValue,
      required this.min,
      required this.max,
      required this.step,
      required this.onChanged});

  @override
  State<NumberStepper> createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper> {
  int _currentValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
                constraints: BoxConstraints(
                  minWidth: 21,
                  minHeight: 21,
                ),
                iconSize: 25,
                padding: EdgeInsets.all(1),
                onPressed: () {
                  setState(() {
                    if (_currentValue > widget.min) {
                      _currentValue -= widget.step;
                    }
                    widget.onChanged(_currentValue);
                  });
                },
                icon: Icon(
                  Icons.remove,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                )),
          ),
          Expanded(
            child: Center(
              child: Text(
                _currentValue.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
              splashRadius: 5,
              onPressed: () {
                setState(() {
                  if (_currentValue < widget.max) {
                    _currentValue += widget.step;
                  }
                  widget.onChanged(_currentValue);
                });
              },
              icon: Icon(
                Icons.add,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

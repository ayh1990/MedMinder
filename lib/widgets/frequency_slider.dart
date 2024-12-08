import 'package:flutter/material.dart';

class FrequencySlider extends StatefulWidget {
  final Function(int) onFrequencyChanged;

  FrequencySlider({required this.onFrequencyChanged});

  @override
  FrequencySliderState createState() => FrequencySliderState();
}

class FrequencySliderState extends State<FrequencySlider> {
  String _unit = 'hours';
  int _value = 1;

  void _updateFrequency() {
    int frequency;
    switch (_unit) {
      case 'minutes':
        frequency = _value;
        break;
      case 'hours':
        frequency = _value * 60;
        break;
      case 'days':
        frequency = _value * 60 * 24;
        break;
      case 'weeks':
        frequency = _value * 60 * 24 * 7;
        break;
      default:
        frequency = _value * 60;
    }
    widget.onFrequencyChanged(frequency);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Frequency: $_value $_unit'),
        Slider(
          value: _value.toDouble(),
          min: 1,
          max: _unit == 'minutes' ? 60 : _unit == 'hours' ? 24 : _unit == 'days' ? 7 : 4,
          divisions: _unit == 'minutes' ? 60 : _unit == 'hours' ? 24 : _unit == 'days' ? 7 : 4,
          label: '$_value $_unit',
          onChanged: (double newValue) {
            setState(() {
              _value = newValue.toInt();
              _updateFrequency();
            });
          },
        ),
        DropdownButton<String>(
          value: _unit,
          items: <String>['minutes', 'hours', 'days', 'weeks'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _unit = newValue!;
              _value = 1;
              _updateFrequency();
            });
          },
        ),
      ],
    );
  }
}
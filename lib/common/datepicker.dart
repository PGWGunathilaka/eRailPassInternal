import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {

  final Function onChange;
  late final DateTime initialDate;

  DatePicker({super.key, required this.onChange, initialDate}) {
    this.initialDate = initialDate ?? DateTime.now();
  }

  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != widget.initialDate) {
      widget.onChange(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xfff6c5d3)),
              onPressed: () => _selectDate(context),
              child: Text(
                '${widget.initialDate.year}-${widget.initialDate.month}-${widget.initialDate.day}',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

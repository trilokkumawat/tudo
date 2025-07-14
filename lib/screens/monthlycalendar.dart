import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/utils/methodhelper.dart';

class MonthlyCalendar extends StatefulWidget {
  final Function(DateTime selectedDate)? onDateSelected;
  final DateTime? alreadyselectdate;

  const MonthlyCalendar({Key? key, this.onDateSelected, this.alreadyselectdate})
    : super(key: key);

  @override
  _MonthlyCalendarState createState() => _MonthlyCalendarState();
}

class _MonthlyCalendarState extends State<MonthlyCalendar> {
  DateTime currentDate = DateTime.now();
  int? _selectedDay;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final totalDaysInMonth = DateTime(
      currentDate.year,
      currentDate.month + 1,
      0,
    ).day;
    final startingWeekday = firstDayOfMonth.weekday % 7;
    final leadingEmptyCells = startingWeekday;
    final totalCells = leadingEmptyCells + totalDaysInMonth;

    // Helper: is this day the already selected date?
    bool isAlreadySelectedDate(int day) {
      if (widget.alreadyselectdate == null) return false;
      return widget.alreadyselectdate!.year == currentDate.year &&
          widget.alreadyselectdate!.month == currentDate.month &&
          widget.alreadyselectdate!.day == day;
    }

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16),
        color: Color(0xFFF9F9F9),
        child: Column(
          children: [
            // Month header with button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    safeSetState(this, () {
                      currentDate = DateTime(
                        currentDate.year,
                        currentDate.month - 1,
                        1,
                      );
                      _selectedDay = null;
                    });
                  },
                  child: Icon(Icons.arrow_back_ios, color: Color(0xFF12272F)),
                ),

                Text(
                  DateFormat('MMMM yyyy').format(currentDate),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF12272F),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    safeSetState(this, () {
                      currentDate = DateTime(
                        currentDate.year,
                        currentDate.month + 1,
                        1,
                      );
                      _selectedDay = null;
                    });
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF12272F),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Weekday labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF12272F),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 8),
            // Grid for days
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: totalCells,
              itemBuilder: (context, index) {
                if (index < leadingEmptyCells) {
                  return Container();
                } else {
                  final dayNumber = index - leadingEmptyCells + 1;
                  final isToday =
                      dayNumber == DateTime.now().day &&
                      currentDate.month == DateTime.now().month &&
                      currentDate.year == DateTime.now().year;
                  final isSelected = _selectedDay == dayNumber;
                  final isAlreadySelected = isAlreadySelectedDate(dayNumber);

                  Color cellColor;
                  if (isToday) {
                    cellColor = Color(0xFF12272F);
                  } else if (isSelected) {
                    cellColor = Colors.blue;
                  } else if (isAlreadySelected) {
                    cellColor = Colors.blue;
                  } else {
                    cellColor = Colors.white;
                  }

                  Color textColor = (isToday || isSelected || isAlreadySelected)
                      ? Colors.white
                      : Colors.black;

                  return GestureDetector(
                    onTap: () {
                      safeSetState(this, () {
                        _selectedDay = dayNumber;
                        if (widget.onDateSelected != null) {
                          widget.onDateSelected!(
                            DateTime(
                              currentDate.year,
                              currentDate.month,
                              _selectedDay!,
                            ),
                          );
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: cellColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(
                          '$dayNumber',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

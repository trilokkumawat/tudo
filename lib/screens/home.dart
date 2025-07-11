import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/backend/firebaes/firebase_service.dart';
import 'package:todo/screens/taskadd.dart';
import 'package:todo/utils/datetime_helper.dart';
import 'package:todo/utils/methodhelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestore = FirestoreService();

  final tabs = ['All', 'Complete', 'Active'];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/background2.png',
            ), // Your image path
            fit: BoxFit.cover, // or BoxFit.fill, BoxFit.contain, etc.
          ),
        ),
        child: SafeArea(
          child: Column(
            spacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateTimeHelper.getFormattedTodayDate()),
                        Icon(Icons.more_horiz),
                      ],
                    ),
                    Text(
                      "ToDo List",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),

                color: const Color(0xFFF9F9F9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(7, (index) {
                    final date = DateTime.now().add(Duration(days: index));
                    // Get day name (Mon, Tue, etc.)
                    final today = DateTime.now();

                    final isToday =
                        date.day == today.day &&
                        date.month == today.month &&
                        date.year == today.year;
                    final dayName = [
                      'Sun',
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                    ][date.weekday % 7];

                    return Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,

                          decoration: BoxDecoration(
                            color: isToday
                                ? Color(0xFF12272F)
                                : Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${date.day}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isToday
                                      ? Color(0xFFFFFFFF)
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                dayName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isToday
                                      ? Color(0xFFFFFFFF)
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(tabs.length, (index) {
                    final isActive = selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        safeSetState(this, () {
                          selectedIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isActive
                                        ? Color(0xFF12272F)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                tabs[index],
                                style: TextStyle(
                                  color: isActive
                                      ? Color(0xFF12272F)
                                      : Color.fromARGB(255, 187, 187, 187),
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.getData('task'),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final allTasks = snapshot.data!.docs;
                  List filteredTasks;

                  if (selectedIndex == 1) {
                    // Complete
                    filteredTasks = allTasks
                        .where(
                          (doc) =>
                              (doc.data() as Map<String, dynamic>)['status'] ==
                              'complete',
                        )
                        .toList();
                  } else if (selectedIndex == 2) {
                    // Active
                    filteredTasks = allTasks
                        .where(
                          (doc) =>
                              (doc.data() as Map<String, dynamic>)['status'] ==
                              'active',
                        )
                        .toList();
                  } else {
                    // All
                    filteredTasks = allTasks;
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      final data = task.data() as Map<String, dynamic>?;
                      final docId = task.id; // ✅ get document ID

                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 10, // Added left padding
                          right: 10, // Added right padding
                          bottom: 10,
                        ), // space between items
                        child: Container(
                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.grey.withOpacity(
                                  0.5,
                                ), // Shadow color
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Left side: Icon and task info
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (task["status"] == "active") {
                                            await _firestore.updateData(
                                              "task",
                                              docId,
                                              {"status": "complete"},
                                            );
                                          } else {
                                            await _firestore.updateData(
                                              "task",
                                              docId,
                                              {"status": "active"},
                                            );
                                          }
                                        },
                                        child: Icon(
                                          data != null &&
                                                  data.containsKey('status') &&
                                                  data['status'] != null &&
                                                  data['status']
                                                      .toString()
                                                      .isNotEmpty &&
                                                  data['status'] == "complete"
                                              ? Icons
                                                    .radio_button_checked_outlined
                                              : Icons.radio_button_unchecked,
                                          color: Color(0xFF12272F),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (data != null &&
                                              data.containsKey('time') &&
                                              data['time'] != null &&
                                              data['time']
                                                  .toString()
                                                  .isNotEmpty)
                                            Text(
                                              data['time'],
                                              style: TextStyle(
                                                color: Color(0xFF12272F),
                                              ),
                                            ),
                                          Text(
                                            data?["task"] ?? "",
                                            style: TextStyle(
                                              color: Color(0xFF12272F),
                                            ),
                                          ),
                                          Text(
                                            data?["notes"] ?? "",
                                            style: TextStyle(
                                              color: Color(0xFF12272F),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Right side: Edit and alarm
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Visibility(
                                        visible: data!["status"] != "complete",
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TaskAddScreen(
                                                      taskedit: data,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                              color: Color(0xFF12272F),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (data != null &&
                                          data.containsKey('alarm') &&
                                          data['alarm'] != null &&
                                          data['alarm'].toString().isNotEmpty)
                                        Icon(
                                          Icons.alarm_add_outlined,
                                          color: Color(0xFF12272F),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  DateTimeHelper.formatDate(task["created_at"]),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              // SizedBox(
              //   height: MediaQuery.of(context).size.height / 1.9,
              //   child: Padding(
              //     padding: const EdgeInsets.only(right: 16, left: 16),
              //     child:
              //     ListView.builder(
              //       shrinkWrap: true,
              //       physics: BouncingScrollPhysics(),
              //       itemCount: 10,
              //       itemBuilder: (context, index) {
              //         return
              //         Padding(
              //           padding: const EdgeInsets.only(
              //             top: 10,
              //             left: 10, // Added left padding
              //             right: 10, // Added right padding
              //             bottom: 10,
              //           ), // space between items
              //           child: Container(
              //             padding: const EdgeInsets.all(16),

              //             decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.only(
              //                 bottomRight: Radius.circular(20),
              //                 topLeft: Radius.circular(20),
              //               ),
              //               boxShadow: [
              //                 BoxShadow(
              //                   // ignore: deprecated_member_use
              //                   color: Colors.grey.withOpacity(
              //                     0.5,
              //                   ), // Shadow color
              //                   spreadRadius: 2,
              //                   blurRadius: 5,
              //                   offset: Offset(0, 3),
              //                 ),
              //               ],
              //             ),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Row(
              //                   children: [
              //                     Icon(
              //                       Icons.radio_button_unchecked,
              //                       color: Colors.pink.shade100,
              //                     ),
              //                     SizedBox(width: 20),
              //                     Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         Text(
              //                           "3:00 PM",
              //                           style: TextStyle(
              //                             color: Color(0xFF12272F),
              //                           ),
              //                         ),
              //                         Text(
              //                           "Meeting: UX Case",
              //                           style: TextStyle(
              //                             color: Color(0xFF12272F),
              //                           ),
              //                         ),
              //                         Text(
              //                           "Discuss Milton website",
              //                           style: TextStyle(
              //                             color: Color(0xFF12272F),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                     Expanded(
              //                       child: Column(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.spaceAround,
              //                         children: [
              //                           Text(
              //                             "Edit",
              //                             style: TextStyle(
              //                               color: Color(0xFF12272F),
              //                             ),
              //                           ),
              //                           Icon(
              //                             Icons.alarm_add_outlined,
              //                             color: Color(0xFF12272F),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskAddScreen()),
        ),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Color(0xFF12272F),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

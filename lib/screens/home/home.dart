import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/components/task_card.dart';
import 'package:todo/flutter_flow_model.dart';
import 'package:todo/screens/home/home_model.dart';
import 'package:todo/screens/taskmenu/taskmenu.dart';
import 'package:todo/utils/datetime_helper.dart';
import 'package:todo/utils/methodhelper.dart';
import 'package:todo/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeModel _model;

  @override
  void initState() {
    _model = createModel(context, () => HomeModel());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final userPhotoURL = authService.userPhotoURL;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFFFFFFF).withOpacity(0.70)),
        child: SafeArea(
          child: SingleChildScrollView(
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
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => context.go('/profile'),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFF12272F),
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child:
                                        userPhotoURL != null &&
                                            userPhotoURL.isNotEmpty
                                        ? Image.network(
                                            userPhotoURL,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    color: Color(0xFF12272F),
                                                    child: const Icon(
                                                      Icons.email,
                                                      color: Colors.white,
                                                    ),
                                                  );
                                                },
                                          )
                                        : Container(
                                            color: Color(0xFF12272F),
                                            child: const Icon(
                                              Icons.email,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                    children: List.generate(_model.tabs.length, (index) {
                      final isActive = _model.selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          safeSetState(this, () {
                            _model.selectedIndex = index;
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
                                  _model.tabs[index],
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
                  stream: _model.firestore.getData(_model.collectionpath),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    final allTasks = snapshot.data!.docs;
                    List filteredTasks;

                    if (_model.selectedIndex == 1) {
                      // Complete
                      filteredTasks = allTasks
                          .where(
                            (doc) =>
                                (doc.data()
                                    as Map<String, dynamic>)['status'] ==
                                'complete',
                          )
                          .toList();
                    } else if (_model.selectedIndex == 2) {
                      // Active
                      filteredTasks = allTasks
                          .where(
                            (doc) =>
                                (doc.data()
                                    as Map<String, dynamic>)['status'] ==
                                'active',
                          )
                          .toList();
                    } else {
                      // All
                      filteredTasks = allTasks;
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        final data = task.data() as Map<String, dynamic>?;
                        final docId = task.id;

                        if (data == null) return const SizedBox.shrink();

                        return TaskCard(
                          taskData: data,
                          docId: docId,
                          onStatusToggle: () async {
                            if (data["status"] == "active") {
                              _model.updatetask(docId, "complete");
                            } else {
                              _model.updatetask(docId, "active");
                            }
                          },

                          onEdit: () {
                            data["docId"] = docId;
                            context.go('/edit-task', extra: data);
                          },
                          onClose: () {
                            _model.deleteTask(docId);
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Color(0xFF12272F),
        iconTheme: IconThemeData(color: Colors.white),
        children: [
          SpeedDialChild(
            child: Icon(Icons.add, color: Color(0xFF12272F)),
            label: 'Add Task',
            onTap: () => context.go('/add-task'),
          ),
          SpeedDialChild(
            child: Icon(Icons.timer_rounded, color: Color(0xFF12272F)),
            label: 'Timer',
            onTap: () => context.go('/timer-task'),
          ),
          SpeedDialChild(
            child: Icon(Icons.check, color: Color(0xFF12272F)),
            label: 'Mark Complete',
            onTap: () {
              // Handle mark complete
            },
          ),
        ],
      ),
      // GestureDetector(
      //
      //   child: Container(
      //     height: 50,
      //     width: 50,
      //     decoration: BoxDecoration(
      //       color: Color(0xFF12272F),
      //       borderRadius: BorderRadius.circular(50),
      //     ),
      //     child: Icon(Icons.add, color: Colors.white),
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

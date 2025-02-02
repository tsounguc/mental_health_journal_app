import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/features/auth/data/models/user_model.dart';
import 'package:mental_health_journal_app/features/dashboard/providers/dashboard_controller.dart';
import 'package:mental_health_journal_app/features/dashboard/utils/dashboard_utils.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const id = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: DashboardUtils.userDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is UserModel) {
          context.userProvider.user = snapshot.data;
        }
        return Consumer<DashBoardController>(
          builder: (context, controller, child) {
            return Scaffold(
              // backgroundColor: Colours.backgroundColor,
              body: IndexedStack(
                index: controller.currentIndex,
                children: controller.screens,
              ),
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                  // color: Colours.backgroundColor,
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: BottomNavigationBar(
                  // backgroundColor: Colours.backgroundColor,
                  backgroundColor: Colors.white,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.book),
                      label: 'Journal',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.insights),
                      label: 'Insights',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                  currentIndex: controller.currentIndex,
                  onTap: controller.changeIndex,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

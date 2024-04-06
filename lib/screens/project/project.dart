import 'package:flutter/material.dart';
import 'package:web_duplicate_app/constants.dart';
import 'package:web_duplicate_app/screens/dashboard.dart';
import 'package:web_duplicate_app/screens/project/components/frames_list.dart';
import 'package:web_duplicate_app/screens/project/components/counters.dart';
import 'package:web_duplicate_app/screens/project/components/totalScript.dart';

class ProjectScreen extends StatelessWidget {
  final String projectID;
  const ProjectScreen({super.key, required this.projectID});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Film Planner',
      color: Colors.white,
      child: Scaffold(
        backgroundColor: colorDarKBlue,
        body: DashboardScreen(
          backActionEnabled: true,
          title: 'Project',
          children: [
            CountersCompoment(projectID: projectID),
            TotalScriptComponent(projectID: projectID),
            Expanded(child: FramesListComponent(projectID: projectID)),
          ],
        ),
      ),
    );
  }
}

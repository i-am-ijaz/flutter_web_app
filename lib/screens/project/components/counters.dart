import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_duplicate_app/components/custom_button.dart';
import 'package:web_duplicate_app/constants.dart';
import 'package:web_duplicate_app/models/counter.dart';

class CountersCompoment extends StatelessWidget {
  final String projectID;
  const CountersCompoment({super.key, required this.projectID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('projects')
          .doc(projectID)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Text('No Data');
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        final CounterModel counterModel = CounterModel(
          estTimeSpeak: data['counters']['estTimeSpeak'],
          wordsCount: data['counters']['wordsCount'],
          characters: data['counters']['characters'],
          framesCount: data['counters']['framesCount'],
        );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CounterButton(
                  icon: icFrame,
                  text: 'Frames',
                  count: counterModel.framesCount.toString(),
                ),
                const SizedBox(width: 10),
                CounterButton(
                  icon: icTime,
                  text: 'Est. Speak Time',
                  count: counterModel.estTimeSpeak,
                  iconSize: 20,
                ),
                const SizedBox(width: 10),
                CounterButton(
                  icon: icWord,
                  text: 'Words Count',
                  count: counterModel.wordsCount,
                ),
                const SizedBox(width: 10),
                CounterButton(
                  icon: icWord,
                  text: 'Characters',
                  count: counterModel.characters,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

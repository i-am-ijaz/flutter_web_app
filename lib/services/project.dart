// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_duplicate_app/models/counter.dart';
import 'package:web_duplicate_app/models/project_model.dart';
import 'package:web_duplicate_app/services/user.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  Future<String?> getTotalScript(String projectID) async {
    final doc = await _firestore.collection('projects').doc(projectID).get();
    if (doc.exists) {
      final data = doc.data();
      return data?['totalScript'] as String?;
    }
    return null;
  }

  Future<void> setTotalScript(String script, String projectID) async {
    await _firestore.collection('projects').doc(projectID).update({
      'totalScript': script,
    });
  }

  Future<void> inviteUser(String email, String projectID) async {
    final projectRef = _firestore.collection('projects').doc(projectID);

    await projectRef.update({
      'assignedTo': FieldValue.arrayUnion([email])
    });
  }

  Future<Map<String, dynamic>?> getWordsCounter(String projectID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('projects').doc(projectID).get();

      if (snapshot.exists) {
        return snapshot.data();
      } else {
        print('No se encontró ningún proyecto con el ID proporcionado.');
        return null;
      }
    } catch (error) {
      print('Error al obtener el contador de palabras: $error');
      return null;
    }
  }

  Future<void> updateWordsCounter(String projectID, String script) async {
    final words = script.trim().split(RegExp(r'\s+'));
    final wordsCount = words.length;
    final characters = script.length;

    // Calculating estimated speaking time
    final double minutes = wordsCount / 180; // 180 words per minute
    final int estTimeSpeakMinutes = minutes.floor();
    final int estTimeSpeakSeconds =
        ((minutes - estTimeSpeakMinutes) * 60).round();

    String estTimeSpeak;
    if (estTimeSpeakMinutes > 0) {
      estTimeSpeak =
          '$estTimeSpeakMinutes:${estTimeSpeakSeconds.toString().padLeft(2, '0')} min';
    } else {
      estTimeSpeak = '$estTimeSpeakSeconds s';
    }

    await _firestore.collection('projects').doc(projectID).update({
      'counters.estTimeSpeak': estTimeSpeak.toString(),
      'counters.wordsCount': wordsCount.toString(),
      'counters.characters': characters.toString(),
    });
  }

  Future<void> updateFrameCounter(String projectID, bool increment) async {
    await _firestore.collection('projects').doc(projectID).update({
      'counters.framesCount': FieldValue.increment(increment ? 1 : -1),
    });
  }

  Future<Project?> readProject(String projectID) async {
    final doc = await _firestore.collection('projects').doc(projectID).get();
    return doc.exists ? Project.fromJson(doc.data()!) : null;
  }

  Stream<Project?> readProjectsSnapshot() async* {
    final user = await _userService.getCurrentUser();

    final projectsSnapshot = _firestore
        .collection('projects')
        .where(
          'assignedTo',
          arrayContains:
              user.email == 'admin@programador123.com' ? null : user.email,
        )
        .snapshots();

    await for (final snapshot in projectsSnapshot) {
      final projects =
          snapshot.docs.map((doc) => Project.fromJson(doc.data())).toList();
      for (final project in projects) {
        yield project;
      }
    }
  }

  Future<void> createProject(Project project) async {
    // Admin can create without invitations
    // print(project.assignedTo);
    await _firestore.collection('projects').doc(project.id).set(
          project.toJson(),
          SetOptions(merge: true),
        );
  }

  Future<void> deleteProject(String projectID) async {
    await _firestore.collection('projects').doc(projectID).delete();
  }

  Future<void> updateProject(String projectID, Project project) async {
    await _firestore
        .collection('projects')
        .doc(projectID)
        .update(project.toJson());
  }

  Future<void> exampleUsage() async {
    // Create a sample project
    final newProject = Project(
      id: 'project',
      name: 'Example Project',
      description: 'This is an example project for demonstration.',
      createdAt: DateTime.now(),
      counters: CounterModel(
        framesCount: 4,
        estTimeSpeak: '0:02',
        wordsCount: '10',
        characters: '100',
      ),
      assignedTo: const [
        'admin@programador123.com',
        'no-admin@programador123.com'
      ],
    );

    // // Create the project
    await createProject(newProject);

    // Read the created project
    final readProjectx = await readProject(newProject.id);
    print('Read project: ${readProjectx!.toJson()}');

    // Update the project
    // final updatedProject = readProjectx.copyWith(
    //   projectName: 'Updated Project Name',
    // );
    // await updateProject(newProject.id, updatedProject);

    // Read projects snapshot
    await for (final project in readProjectsSnapshot()) {
      print('Project from snapshot: ${project!.toJson()}');
    }

    // Delete the project
    // await deleteProject(newProject.projectID);
  }
}

//TODO: Hacer methods service para frames
// ignore_for_file: avoid_print, unused_element

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:web_duplicate_app/models/deadline.dart';
import 'package:web_duplicate_app/models/frame.dart';
import 'package:web_duplicate_app/models/location.dart';
import 'package:web_duplicate_app/models/sceneInformation.dart';
import 'dart:typed_data';

import 'package:web_duplicate_app/services/project.dart';

class FrameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final ProjectService _projectService = ProjectService();

  Future<FrameModel> createFrame(
    String projectID,
    FrameModel frameData,
  ) async {
    DocumentReference docRef = _firestore
        .collection('projects')
        .doc(projectID)
        .collection('frames')
        .doc();
    frameData.id = docRef.id;
    await docRef.set(frameData.toJson());
    return frameData;
  }

  Future<FrameModel?> getLatestFrame(
    String projectID,
  ) async {
    try {
      final framesSnapshot = await _firestore
          .collection('projects')
          .doc(projectID)
          .collection('frames')
          .orderBy('storyOrder', descending: true)
          .limit(1)
          .get();

      if (framesSnapshot.docs.isNotEmpty) {
        final latestFrameData = framesSnapshot.docs.first.data();
        final latestFrame = FrameModel.fromJson(latestFrameData);
        return latestFrame;
      } else {
        return null; // No se encontraron frames en el proyecto
      }
    } catch (e) {
      print('Error getting latest frame: $e');
      return null;
    }
  }

  Stream<QuerySnapshot<FrameModel>> readFramesSnapshot(
    String projectID,
    int limit,
    bool storyMode,
  ) {
    return _firestore
        .collection('projects')
        .doc(projectID)
        .collection('frames')
        .orderBy(storyMode ? 'storyOrder' : 'shotOrder', descending: false)
        .limit(limit)
        .withConverter<FrameModel>(
            fromFirestore: (snapshot, _) =>
                FrameModel.fromJson(snapshot.data()!),
            toFirestore: (frame, _) => frame.toJson())
        .snapshots();
  }

  Future<void> updateFrame(
    String projectID,
    String frameID,
    FrameModel frameData,
  ) async {
    DocumentReference docRef = _firestore
        .collection('projects')
        .doc(projectID)
        .collection('frames')
        .doc(frameID);
    await docRef.update(frameData.toJson());
  }

  Future<void> _updateFrameData(
    String projectID,
    String frameID,
    Map<String, dynamic> dataToUpdate,
  ) async {
    await _firestore
        .collection('projects')
        .doc(projectID)
        .collection('frames')
        .doc(frameID)
        .update(dataToUpdate);
  }

  Future<void> updateStoryOrder(
    double value,
    String projectID,
    String frameID,
  ) async {
    await _updateFrameData(projectID, frameID, {'storyOrder': value});
  }

  Future<void> updateShotOrder(
    double value,
    String projectID,
    String frameID,
  ) async {
    await _updateFrameData(projectID, frameID, {'shotOrder': value});
  }

  Future<void> isCompleted(
    bool value,
    String projectID,
    String frameID,
  ) async {
    await _updateFrameData(projectID, frameID, {'completed': value});
  }

  Future<void> updateLocation(
    LocationModel locationModel,
    String projectID,
    String frameID,
  ) async {
    await _updateFrameData(projectID, frameID, {
      'location': {
        'date': locationModel.date,
        'locationAddress': locationModel.locationAddress,
        'appflowyID': locationModel.appflowyID,
      }
    });
  }

  Future<void> updateDeadline(
    DeadlineModel deadlineModel,
    String projectID,
    String frameID,
  ) async {
    List<Timestamp> remindersTimestamp =
        deadlineModel.reminders.map((dateTime) {
      return Timestamp.fromDate(dateTime);
    }).toList();

    await _updateFrameData(projectID, frameID, {
      'deadline': {
        'date': Timestamp.fromDate(deadlineModel.date),
        'reminders': remindersTimestamp,
      }
    });
  }

  Future<void> updateIdeasID(
    String ideasID,
    String projectID,
    String frameID,
  ) async {
    await _updateFrameData(projectID, frameID, {"ideasID": ideasID});
  }

  Future<void> updateObstaclesID(
    String obstaclesID,
    String projectID,
    String frameID,
  ) async {
    await _updateFrameData(projectID, frameID, {"obstaclesID": obstaclesID});
  }

  Future<void> updateSceneInformation(
    SceneInformationModel sceneInformationModel,
    String projectID,
    String frameID,
  ) async {
    await _updateFrameData(projectID, frameID, {
      'sceneInformation': sceneInformationModel.toJson(),
    });
  }

  Future<void> updateScriptID(
    String scriptID,
    String projectID,
    String frameID,
  ) async {
    await _updateFrameData(
        projectID, frameID, {'scriptInformation.scriptID': scriptID});
  }

  Future<void> updateVisualExplanationID(
    String visualExplanationID,
    String projectID,
    String frameID,
  ) async {
    await _updateFrameData(projectID, frameID,
        {'scriptInformation.visualExplanationID': visualExplanationID});
  }

  Future<void> updateScriptTime(
    String time,
    String projectID,
    String frameID,
  ) async {
    await _updateFrameData(
        projectID, frameID, {'scriptInformation.time': time});
  }

  Future<void> addNewImage(
    String projectID,
    String frameID, {
    Uint8List? image,
    XFile? file,
  }) async {
    try {
      // Upload the image to Firebase storage and get the URL
      String imageUrl = await uploadImageToFirebaseStorage(
        file: file,
        image: image,
        projectID,
      );

      // Append the URL to the images list in sceneInformation
      await _updateFrameData(projectID, frameID, {
        'sceneInformation.images': FieldValue.arrayUnion([imageUrl]),
      });
    } catch (e) {
      print('Error adding new image: $e');
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    final reference = FirebaseStorage.instance.refFromURL(imageUrl);

    try {
      await reference.delete();
      print('Image deleted successfully!');
    } on FirebaseException catch (e) {
      print('Error deleting image: $e');
      // Handle errors (e.g., show a user-friendly message)
    }
  }

  Future<String> uploadImageToFirebaseStorage(
    String projectID, {
    Uint8List? image,
    XFile? file,
  }) async {
    try {
      // Generar un ID único para el nombre del archivo
      String fileName = '${projectID}_${DateTime.now().millisecondsSinceEpoch}';

      final storageRef = _firebaseStorage.ref().child('images/$fileName');
      UploadTask uploadTask;
      if (file != null) {
        uploadTask = storageRef.putFile(File(file.path));
      } else {
        uploadTask = storageRef.putData(image!);
      }
      await uploadTask;

      final downloadUrl = await storageRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return '';
    }
  }

  Future<void> deleteFrame(
    String projectID,
    String frameID,
  ) async {
    DocumentReference docRef = _firestore
        .collection('projects')
        .doc(projectID)
        .collection('frames')
        .doc(frameID);
    await docRef.delete();
    _projectService.updateFrameCounter(projectID, false);
  } // Example usage of FrameService methods

  Future<void> exampleUsage() async {
    String projectID = 'project';
    try {
      // Create a frame
      final newFrame = FrameModel(
        id: 'frameID-01',
        storyOrder: 0,
        shotOrder: 1,
      );
      final createdFrame = await createFrame(projectID, newFrame);
      print('Frame created: ${createdFrame.id}');

      await Future.delayed(const Duration(seconds: 2));

      // Update story order
      await updateStoryOrder(2.1, projectID, createdFrame.id);
      print('Story order updated');

      await Future.delayed(const Duration(seconds: 2));

      // Update shot order
      await updateShotOrder(3.0, projectID, createdFrame.id);
      print('Shot order updated');

      await Future.delayed(const Duration(seconds: 2));

      // Mark as completed
      await isCompleted(true, projectID, createdFrame.id);
      print('Marked as completed');

      await Future.delayed(const Duration(seconds: 2));

      // Update location
      final locationModel = LocationModel(
        date: DateTime.now().toString(),
        locationAddress: 'Sample Address',
        appflowyID: 'sampleAppflowyID',
      );
      await updateLocation(locationModel, projectID, createdFrame.id);
      print('Location updated');

      await Future.delayed(const Duration(seconds: 2));

      // Update deadline
      final deadlineModel = DeadlineModel(
        date: DateTime.now(),
        reminders: [DateTime.now()],
      );
      await updateDeadline(deadlineModel, projectID, createdFrame.id);
      print('Deadline updated');

      await Future.delayed(const Duration(seconds: 2));

      // Update scene information
      final sceneInformationModel = SceneInformationModel(
        images: [],
        sketchType: 'Sample Sketch',
        aspectRatio: 'Sample Ratio',
        shotSize: 'sceneInformationModel.shotSize',
        shotType: 'sceneInformationModel.shotType',
        lens: 'sceneInformationModel.lens',
        camera: 'sceneInformationModel.camera',
        frameRate: 'sceneInformationModel.frameRate',
        cameraAngle: 'Sample Camera Angle',
        cameraMovement: 'Sample Camera Movement',
      );

      await updateIdeasID('ideasID', projectID, createdFrame.id);
      print('IdeasID information updated');
      await Future.delayed(const Duration(seconds: 2));

      await updateObstaclesID('obstaclesID', projectID, createdFrame.id);
      print('ObstaclesID information updated');
      await Future.delayed(const Duration(seconds: 2));

      await updateSceneInformation(
        sceneInformationModel,
        projectID,
        createdFrame.id,
      );
      print('Scene information updated');

      await Future.delayed(const Duration(seconds: 2));

      // Update script time
      await updateScriptTime('Sample Time', projectID, createdFrame.id);
      print('Script time updated');

      await Future.delayed(const Duration(seconds: 2));
      await updateScriptID('Sample ScriptID', projectID, createdFrame.id);
      print('ScriptID updated');

      await Future.delayed(const Duration(seconds: 2));
      await updateVisualExplanationID(
        'Sample VisualExplanationID',
        projectID,
        createdFrame.id,
      );
      print('VisualExplanationID updated');

      await Future.delayed(const Duration(seconds: 2));

      // Add new image
      // final sampleImageBytes = Uint8List(0); // Sample image bytes
      // await addNewImage(sampleImageBytes, projectID, createdFrame.id);
      print('New image added');

      await Future.delayed(const Duration(seconds: 2));

      // Escucha los eventos del stream usando el método forEach
      await for (QuerySnapshot<FrameModel> frameSnapshot
          in readFramesSnapshot(projectID, 100, true)) {
        // Itera sobre los documentos en el snapshot
        for (QueryDocumentSnapshot<FrameModel> frameDoc in frameSnapshot.docs) {
          FrameModel frame = frameDoc.data();
          print('Frame: ${frame.toJson()}');
        }
      }

      // Delete a frame
      // await deleteFrame('project', 'N0Y81oLTOaN1bYKokuoH');
    } catch (e) {
      print('Error in exampleUsage: $e');
    }
  }
}

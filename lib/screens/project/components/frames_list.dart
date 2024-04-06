// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_duplicate_app/screens/project/components/frame.dart';
import 'package:web_duplicate_app/constants.dart';
import 'package:web_duplicate_app/models/frame.dart';
import 'package:web_duplicate_app/services/frame.dart';
import 'package:web_duplicate_app/services/project.dart';

class FramesListComponent extends StatefulWidget {
  final String projectID;
  const FramesListComponent({super.key, required this.projectID});

  @override
  State<FramesListComponent> createState() => _FramesListComponentState();
}

class _FramesListComponentState extends State<FramesListComponent> {
  final ProjectService _projectService = ProjectService();
  late ScrollController scrollController;

  final FrameService _frameService =
      FrameService(); // Instancia del servicio de frames

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        StreamBuilder<QuerySnapshot<FrameModel>>(
          stream: _frameService.readFramesSnapshot(
            widget.projectID,
            10,
            true,
          ), // Usa el servicio para leer los frames
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<FrameModel>> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos.
            }

            final frames =
                snapshot.data!.docs.map((doc) => doc.data()).toList();

            return SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Wrap(
                children: frames
                    .map(
                      (frame) => FrameComponent(
                        projectID: widget.projectID,
                        frameModel: frame,
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
        Positioned(
          right: 0,
          bottom: 25,
          child: ElevatedButton(
            onPressed: () {
              _addFrame(); // Llama al método para agregar un frame
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorSkyBlue,
              shape: const CircleBorder(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(icAdd),
            ),
          ),
        ),
      ],
    );
  }

  void _addFrame() async {
    try {
      // Obtener el último storyOrder
      final latestFrame = await _frameService.getLatestFrame(widget.projectID);
      double nextStoryOrder =
          1; // Valor predeterminado si no hay frames todavía

      if (latestFrame != null) {
        nextStoryOrder = latestFrame.storyOrder + 1;
      }

      // Convertir a entero si el número es decimal
      if (nextStoryOrder % 1 != 0) {
        nextStoryOrder = nextStoryOrder.roundToDouble();
      }

      final newFrame = FrameModel(
        id: '',
        storyOrder: nextStoryOrder, // Establecer el nuevo valor de storyOrder
        shotOrder: 0,
      );

      final createdFrame = await _frameService.createFrame(
        widget.projectID,
        newFrame,
      );
      await _projectService.updateFrameCounter(widget.projectID, true);
      print('Frame created: $createdFrame');
    } catch (e) {
      print('Error creating frame: $e');
    }
  }
}

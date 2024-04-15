import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:web_duplicate_app/components/alerts.dart';
import 'package:web_duplicate_app/components/custom_button.dart';
import 'package:web_duplicate_app/components/custom_dropdown.dart';
import 'package:web_duplicate_app/components/snackbarMessage.dart';
import 'package:web_duplicate_app/components/text_widget.dart';
import 'package:web_duplicate_app/constants.dart';
import 'package:web_duplicate_app/extensions.dart';
import 'package:web_duplicate_app/models/frame.dart';
import 'package:web_duplicate_app/screens/project/components/custom_checkbox.dart';
import 'package:web_duplicate_app/screens/project/components/frame_counter.dart';
import 'package:web_duplicate_app/screens/project/components/scriptInfoExpansionPanel.dart';
import 'package:web_duplicate_app/services/frame.dart';
import 'package:web_duplicate_app/services/project.dart';

class FrameComponent extends StatefulWidget {
  final String projectID;
  final FrameModel frameModel;

  const FrameComponent({
    super.key,
    required this.projectID,
    required this.frameModel,
  });

  @override
  State<FrameComponent> createState() => _FrameComponentState();
}

class _FrameComponentState extends State<FrameComponent> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final AlertsComponent alertsComponent = AlertsComponent();
  final FrameService frameService = FrameService();
  final ProjectService projectService = ProjectService();

  bool isPanelOpen = false;

  DropzoneViewController? _dropzoneController;

  int _currentImageIndex = 1;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  togglePanelHeight() {
    isPanelOpen = !isPanelOpen;
    setState(() {});
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  Future<void> _showDeleteDialogWarning(
    BuildContext context, {
    bool isDeletingFrame = true,
    VoidCallback? onPressed,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: AlertDialog(
            backgroundColor: colorDarKBlue,
            title: const Text(
              'Delete Warning',
              style: TextStyle(color: Colors.white),
            ),
            content: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Text(
                isDeletingFrame
                    ? 'Are you sure you want to delete this frame and all its related data, including images, texts, and comments? Pressing "OK" will permanently remove everything. This action cannot be undone.'
                    : 'Are you sure you want to delete this image?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: onPressed,
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: colorSkyBlue, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 527,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: colorLightBlue,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                allAlertDialogs(context, widget.frameModel),
                sketchImagesSection(),
                sceneInformationDropdowns(),
                const ScriptInformationExpansionPanelComponent(),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 5,
            child: Row(
              children: [
                FrameCounter(
                  count: widget.frameModel.storyOrder,
                  onChange: (String newValue) {
                    frameService.updateStoryOrder(
                      double.parse(newValue),
                      widget.projectID,
                      widget.frameModel.id,
                    );
                  },
                  isShotOrder: false,
                ),
                const SizedBox(width: 3),
                FrameCounter(
                  count: widget.frameModel.shotOrder,
                  onChange: (String newValue) {
                    frameService.updateShotOrder(
                      double.parse(newValue),
                      widget.projectID,
                      widget.frameModel.id,
                    );
                  },
                  isShotOrder: true,
                ),
                const SizedBox(width: 3),
                CustomCheckBox(
                  initialValue: widget.frameModel.completed!,
                  onChange: (newValue) {
                    frameService.isCompleted(
                      newValue,
                      widget.projectID,
                      widget.frameModel.id,
                    );
                  },
                ),
              ],
            ),
          ),
          if (firebaseAuth.currentUser!.email == 'admin@programador123.com')
            Positioned(
              top: 5,
              left: 505,
              child: InkWell(
                onTap: () {
                  _showDeleteDialogWarning(
                    context,
                    onPressed: () {
                      frameService.deleteFrame(
                        widget.projectID,
                        widget.frameModel.id,
                      );

                      Navigator.pop(context);
                      snackbarMessage(
                        message: 'Frame deleted successfully.',
                        context: context,
                      );
                    },
                  );
                },
                child: Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    color: colorMediumBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorLightBlue),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget allAlertDialogs(BuildContext context, FrameModel frameModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              const SizedBox(width: 10),
              CustomButton(
                onPressed: () => alertsComponent.showLocationAlert(
                  frameModel: frameModel,
                  projectID: widget.projectID,
                  frameID: widget.frameModel.id,
                  context: context,
                ),
                icon: icLocation,
                text: 'Location',
              ),
              const SizedBox(width: 10),
              CustomButton(
                  onPressed: () => AlertsComponent().showLocationAlert(
                        frameModel: frameModel,
                        projectID: widget.projectID,
                        frameID: widget.frameModel.id,
                        context: context,
                      ),
                  icon: icCheckList,
                  text: 'Checklist'),
              const SizedBox(width: 10),
            ],
          ),
        ),
        Container(
          height: 50,
          width: 0.5,
          color: colorLightBlue,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              CustomButton(
                  onPressed: () => AlertsComponent().showLocationAlert(
                        frameModel: frameModel,
                        projectID: widget.projectID,
                        frameID: widget.frameModel.id,
                        context: context,
                      ),
                  icon: icIdeas,
                  text: 'Ideas'),
              const SizedBox(width: 10),
              CustomButton(
                  onPressed: () => AlertsComponent().showLocationAlert(
                        frameModel: frameModel,
                        projectID: widget.projectID,
                        frameID: widget.frameModel.id,
                        context: context,
                      ),
                  icon: icObstacle,
                  text: 'Obstacles'),
            ],
          ),
        ),
      ],
    );
  }

  Widget sketchImagesSection() {
    final images = widget.frameModel.sceneInformation?.images;
    return Container(
      height: 280,
      decoration: BoxDecoration(
        border: Border.all(color: colorLightBlue, width: 0.5),
      ),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const SizedBox(),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                _showImageDialog();
              },
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: images?.isNotEmpty ?? false
                    ? PageView.builder(
                        controller: _pageController,
                        itemCount: images!.length,
                        onPageChanged: (value) {
                          setState(() {
                            _currentImageIndex = value + 1;
                          });
                        },
                        itemBuilder: (context, index) {
                          final image = images[index];
                          return CachedNetworkImage(
                            imageUrl: image,
                            fit: BoxFit.cover,
                            errorListener: (value) {
                              print(value);
                            },
                          );
                        },
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          DropzoneView(
                            operation: DragOperation.move,
                            onCreated: (controller) {
                              _dropzoneController = controller;
                            },
                            onLoaded: () => print('Zone loaded'),
                            onError: (String? ev) => print('Error: $ev'),
                            onHover: () => print('Zone hovered'),
                            onDrop: (dynamic ev) async {
                              final data =
                                  await _dropzoneController?.getFileData(ev);
                              print('File dropped: $data');
                              // convert uin8list to File
                              final path =
                                  await _dropzoneController?.createFileUrl(ev);

                              final lastModified = await _dropzoneController
                                  ?.getFileLastModified(ev);

                              if (path != null) {
                                var image = XFile(
                                  path,
                                  bytes: data,
                                  lastModified: lastModified,
                                );
                                _images.add(
                                  image,
                                );
                                if (mounted) {
                                  context.showLoading();
                                }
                                await _uploadImage(image);
                                if (mounted) {
                                  context.hideLoading();
                                }
                                setState(() {});
                              }
                            },
                            onLeave: () => print('Zone left'),
                          ),
                          const TextWidget(
                            text: 'IMAGE HERE',
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomDropDown(
                        initialValue:
                            widget.frameModel.sceneInformation?.sketchType,
                        hint: 'Sketch Type',
                        options: const {
                          "Category": {
                            "Sketched":
                                "Expected Price: 12.00 USD per 6 frames.\nDetails: Black and white, rough lines, simple design.",
                            "Detailed":
                                "Expected Price: 30.00 USD per 6 frames.\nDetails: Coloured (simple), shading, shadows.",
                            "Colored":
                                "Expected Price: 70.00 USD per 25 frames.\nDetails: Coloured, shading, shadows, highlights and tones."
                          },
                          "Category2": {
                            "Sketched2":
                                "Expected Price: 12.00 USD per 6 frames.\nDetails: Black and white, rough lines, simple design.",
                            "Detailed2":
                                "Expected Price: 30.00 USD per 6 frames.\nDetails: Coloured (simple), shading, shadows.",
                            "Colored2":
                                "Expected Price: 70.00 USD per 25 frames.\nDetails: Coloured, shading, shadows, highlights and tones."
                          }
                        },
                        onChange: (selectedOption) {
                          frameService.updateSceneInformation(
                            widget.frameModel.sceneInformation!.copyWith(
                              sketchType: selectedOption,
                            ),
                            widget.projectID,
                            widget.frameModel.id,
                          );
                        },
                      ),
                      const SizedBox(width: defaultPadding / 2),
                      ArrowButtons(
                        icon: icLeftAndroidArrow,
                        onPressed: () {
                          _pageController?.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                          print(_currentImageIndex);
                          setState(() {});
                        },
                      ),
                      const SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: colorMediumBlue,
                          border: Border.all(color: colorLightBlue),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: TextWidget(
                          text:
                              '${(images?.isEmpty ?? false) ? 0 : _currentImageIndex} of ${images?.length}',
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 5),
                      ArrowButtons(
                        icon: icRightAndroidArrow,
                        onPressed: () {
                          _pageController?.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                          print(_currentImageIndex);

                          setState(() {});
                        },
                      ),
                      const SizedBox(width: defaultPadding / 2),
                      if (images?.isNotEmpty ?? false)
                        InkWell(
                          onTap: () {
                            _showDeleteDialogWarning(
                              context,
                              isDeletingFrame: false,
                              onPressed: () {
                                Navigator.of(context).pop();
                                frameService.deleteImage(
                                  images![_currentImageIndex - 1],
                                );

                                final updateImages = images;
                                if (_currentImageIndex > 1) {
                                  _currentImageIndex = _currentImageIndex - 1;
                                }
                                updateImages.removeAt(_currentImageIndex - 1);
                                setState(() {
                                  frameService.updateSceneInformation(
                                    widget.frameModel.sceneInformation!
                                        .copyWith(
                                      images: updateImages,
                                    ),
                                    widget.projectID,
                                    widget.frameModel.id,
                                  );
                                });
                              },
                            );
                          },
                          child: Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              color: colorMediumBlue,
                              shape: BoxShape.circle,
                              border: Border.all(color: colorLightBlue),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sceneInformationDropdowns() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      child: Column(
        children: [
          OutlinedButton(
            onPressed: () => togglePanelHeight(),
            style: OutlinedButton.styleFrom(
              backgroundColor: colorMediumBlue,
              side: const BorderSide(
                color: colorLightBlue,
                width: 0.7,
              ),
              minimumSize: const Size(516, 32),
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const TextWidget(
                  text: 'Film Information',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(width: 6),
                SvgPicture.asset(icDownArrow),
              ],
            ),
          ),
          Visibility(
              visible: isPanelOpen,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10, // horizontal spacing between the children
                  runSpacing: 10, // vertical spacing between the lines
                  children: [
                    CustomDropDown(
                      initialValue:
                          widget.frameModel.sceneInformation?.aspectRatio,
                      hint: 'Aspect Ratio',
                      options: const {
                        "Aspect Ratios": {
                          "1:1":
                              "Square format, often used in social media profile pictures.",
                          "4:3":
                              "Standard television format used in older TVs and computer monitors.",
                          "16:9":
                              "Widescreen format commonly used in modern TVs, monitors, and YouTube videos.",
                          "21:9":
                              "Ultra-wide format often found in cinematic films and gaming monitors.",
                          "9:16":
                              "Vertical format commonly used in portrait mode on smartphones.",
                          "3:2":
                              "Common aspect ratio in DSLR camera photography.",
                          "2.35:1":
                              "Cinematic widescreen format used in many feature films."
                        }
                      },
                      onChange: (selectedOption) {
                        frameService.updateSceneInformation(
                          widget.frameModel.sceneInformation!.copyWith(
                            aspectRatio: selectedOption,
                          ),
                          widget.projectID,
                          widget.frameModel.id,
                        );
                      },
                    ),
                    CustomDropDown(
                      initialValue:
                          widget.frameModel.sceneInformation?.shotSize,
                      hint: 'Shot Size',
                      options: const {
                        "CLOSE-UPS": {
                          "Close-up":
                              "A framing that captures the subject's face or a specific object up close, allowing for detailed views of details and emotions.",
                          "Medium Close-up":
                              "A framing that captures the subject from the chest up, offering a balance between facial expression and some background.",
                          "Extreme Close-up":
                              "A framing that focuses on a very specific detail, such as the eyes, mouth, or a small object, to capture the essence or importance of the element.",
                          "Wide Close-up":
                              "A framing that slightly widens the angle of the traditional close-up, including more of the subject's surroundings or context."
                        },
                        "MEDIUM SHOTS": {
                          "Medium Shot":
                              "A framing that shows the subject from the waist up, ideal for dialogues and to show interactions between characters in a context.",
                          "Close Shot":
                              "A less common term that might refer to a close framing, possibly similar to a close-up, capturing the subject in detail but with slightly more context than a traditional close-up.",
                          "Medium Close Shot":
                              "An intermediate framing between the medium shot and the close-up, showing the subject in more detail than a medium shot without being as intimate as a close-up."
                        },
                        "LONG SHOTS": {
                          "Wide Shot":
                              "A framing that captures a wide view of the environment, showing the complete subject in its context, ideal for establishing location or spatial relationships.",
                          "Extreme Wide Shot":
                              "A framing used to show the subject from a significant distance, emphasizing the environment and place more than the subject itself.",
                          "Full Shot":
                              "A framing that includes the entire subject, from head to toe, perfect for showing full action and body language.",
                          "Medium Full Shot":
                              "A framing that might be slightly closer than a full shot, still showing the subject almost in full but with a bit more focus on the subject.",
                          "Long Shot":
                              "A framing that shows the complete subject within a broad context, but with less emphasis on the environment than the wide shot.",
                          "Extreme Long Shot":
                              "A framing that shows the environment on a large scale, often making the subject appear small or insignificant in comparison to their surroundings."
                        }
                      },
                      onChange: (selectedOption) {
                        frameService.updateSceneInformation(
                          widget.frameModel.sceneInformation!.copyWith(
                            shotSize: selectedOption,
                          ),
                          widget.projectID,
                          widget.frameModel.id,
                        );
                      },
                    ),
                    CustomDropDown(
                      initialValue:
                          widget.frameModel.sceneInformation?.shotType,
                      hint: 'Shot Type',
                      options: const {
                        "CAMERA HEIGHT": {
                          "Eye Level":
                              "The camera is positioned at the subject's eye level, creating a neutral and natural perspective.",
                          "Low Angle":
                              "The camera looks up at the subject, making them appear larger or more imposing.",
                          "High Angle":
                              "The camera looks down at the subject, making them appear smaller or less powerful.",
                          "Overhead":
                              "The camera is positioned directly above the subject, offering a bird's-eye view.",
                          "Shoulder Level":
                              "The camera is positioned at the level of the subject's shoulder, slightly lower than eye level.",
                          "Hip Level":
                              "The camera is positioned at the level of the subject's hip, offering a view that captures more of the midground.",
                          "Knee Level":
                              "The camera is positioned at the level of the subject's knee, creating an upward angle without being as extreme as a low angle shot.",
                          "Ground Level":
                              "The camera is placed on or very close to the ground, capturing a view from the lowest possible angle."
                        },
                        "DUTCH ANGLE": {
                          "Dutch (left)":
                              "The camera is tilted to the left, creating a disorienting effect and suggesting imbalance or tension.",
                          "Dutch (right)":
                              "The camera is tilted to the right, similarly creating a sense of unease or dynamic action."
                        },
                        "FRAMING": {
                          "Single":
                              "A shot framing a single subject, focusing attention solely on them.",
                          "Two Shot":
                              "A shot that includes two subjects in the frame, often used to capture the interaction between them.",
                          "Three Shot":
                              "A shot that includes three subjects, used to capture group dynamics or interactions.",
                          "Over-the-Shoulder":
                              "A shot taken from over the shoulder of one subject, framing another subject, creating a sense of depth and perspective.",
                          "Over-the-Hip":
                              "Similar to an over-the-shoulder shot but taken from a lower angle, offering a unique perspective on the framed subject.",
                          "Point of View":
                              "A shot that shows what a character is seeing from their perspective, immersing the viewer in the character's experience."
                        },
                        "FOCUS / DOF (Depth of Field)": {
                          "Rack Focus":
                              "A technique that involves changing the focus from one subject to another within the same shot, directing the viewer's attention.",
                          "Shallow Focus":
                              "A technique where the subject is in sharp focus while the background is blurred, emphasizing the subject.",
                          "Deep Focus":
                              "A technique where both the foreground and background are in sharp focus, showing clear details across all distances.",
                          "Tilt-Shift":
                              "A technique that uses camera movements to simulate a miniature scene, or selectively focus to draw attention to a specific part of the image.",
                          "Zoom":
                              "A technique that changes the focal length of the lens to move closer to or further away from the subject, often used to magnify the subject or reveal context."
                        }
                      },
                      onChange: (selectedOption) {
                        frameService.updateSceneInformation(
                          widget.frameModel.sceneInformation!.copyWith(
                            shotType: selectedOption,
                          ),
                          widget.projectID,
                          widget.frameModel.id,
                        );
                      },
                    ),
                    CustomDropDown(
                      initialValue:
                          widget.frameModel.sceneInformation?.cameraMovement,
                      hint: 'Movement',
                      options: const {
                        "CAMERA MOVEMENT": {
                          "Static":
                              "The camera remains in a fixed position, capturing the scene without any movement, providing a stable and constant viewpoint.",
                          "Pan":
                              "The camera moves horizontally from one side to another on a fixed axis, allowing the viewer to follow action or explore the environment.",
                          "Tilt":
                              "The camera moves vertically up or down from a fixed position, used to reveal elements vertically or follow a subject's movement.",
                          "Swish Pan":
                              "A rapid horizontal pan movement that creates a blur effect, often used for transitions or to convey rapid action.",
                          "Swish Tilt":
                              "A rapid vertical tilt movement, similar to a swish pan but in a vertical direction, creating a blur effect for dynamic transitions or action sequences.",
                          "Tracking":
                              "The camera moves along with the subject, keeping them in frame while capturing movement through space, often using tracks or handheld stabilizers."
                        }
                      },
                      onChange: (selectedOption) {
                        frameService.updateSceneInformation(
                          widget.frameModel.sceneInformation!.copyWith(
                            cameraMovement: selectedOption,
                          ),
                          widget.projectID,
                          widget.frameModel.id,
                        );
                      },
                    ),
                    CustomDropDown(
                      initialValue: widget.frameModel.sceneInformation?.lens,
                      hint: 'Lens',
                      options: const {
                        "ANGLE OF VIEW": {
                          "Normal":
                              "Offers a field of view similar to that of the human eye, typically associated with focal lengths around 50mm on a full-frame camera.",
                          "Telephoto":
                              "Provides a narrow field of view, magnifying distant subjects, typically associated with focal lengths longer than 70mm.",
                          "Wide Angle":
                              "Offers a broader field of view, ideal for capturing landscapes or architectural scenes, typically associated with focal lengths shorter than 35mm.",
                          "Fish-eye":
                              "Provides an extremely wide field of view, creating a spherical or distorted image, typically associated with focal lengths shorter than 16mm.",
                          "Zoom":
                              "Refers to lenses with variable focal lengths, allowing for a range of perspectives from wide angle to telephoto without changing the lens."
                        },
                        "PRIMES": {
                          "10mm":
                              "Ultra-wide angle lens, providing an expansive field of view with significant perspective distortion.",
                          "12mm":
                              "Very wide angle lens, offering a broad view with less distortion than fish-eye lenses.",
                          "14mm":
                              "Wide angle lens, suitable for landscape and architectural photography with minimal distortion.",
                          "16mm":
                              "Wide angle lens, balancing field of view with perspective distortion, ideal for dynamic landscapes.",
                          "18mm":
                              "Moderate wide angle lens, versatile for a variety of subjects with a natural perspective.",
                          "20mm":
                              "Slightly wide angle lens, good for indoor and street photography with a natural look.",
                          "24mm":
                              "Popular wide angle lens, offering a broad view without excessive distortion, great for landscapes.",
                          "25mm":
                              "Near-normal wide angle lens, providing a slightly wider perspective than the human eye.",
                          "28mm":
                              "Common wide angle lens, favored for its natural perspective and versatility in various types of photography.",
                          "30mm":
                              "Mild wide angle lens, offering a broad perspective with minimal distortion, suitable for general photography.",
                          "32mm":
                              "Close to normal focal length, providing a natural field of view with a slight wide angle effect.",
                          "35mm":
                              "Standard wide angle lens, popular for street and documentary photography with a natural perspective.",
                          "40mm":
                              "Slightly wider than normal lens, blending versatility with a natural field of view.",
                          "50mm":
                              "Standard lens, mirroring the human eye's perspective, ideal for portraits and everyday photography.",
                          "65mm":
                              "Mild telephoto lens, offering a tighter field of view, ideal for portraits with flattering compression.",
                          "75mm":
                              "Short telephoto lens, good for portraits and isolating subjects from the background.",
                          "85mm":
                              "Classic portrait lens, providing excellent subject isolation and background compression.",
                          "100mm":
                              "Medium telephoto lens, suited for portraits, macro, and close-up photography with clear detail.",
                          "135mm":
                              "Telephoto lens, ideal for sports, portraits, and where significant subject-background separation is desired.",
                          "150mm":
                              "Telephoto lens, offering greater magnification and isolation for sports and wildlife photography.",
                          "180mm":
                              "Long telephoto lens, excellent for wildlife, sports, and any situation requiring significant magnification."
                        }
                      },
                      onChange: (selectedOption) {
                        frameService.updateSceneInformation(
                          widget.frameModel.sceneInformation!.copyWith(
                            lens: selectedOption,
                          ),
                          widget.projectID,
                          widget.frameModel.id,
                        );
                      },
                    ),
                    CustomDropDown(
                      initialValue: widget.frameModel.sceneInformation?.camera,
                      hint: 'Camera',
                      options: const {
                        "CAMERA": {
                          "CAM A": "Camera A",
                          "CAM B": "Camera B",
                          "CAM C": "Camera C",
                          "CAM D": "Camera D"
                        }
                      },
                      onChange: (selectedOption) {
                        frameService.updateSceneInformation(
                          widget.frameModel.sceneInformation!.copyWith(
                            camera: selectedOption,
                          ),
                          widget.projectID,
                          widget.frameModel.id,
                        );
                      },
                    ),
                    CustomDropDown(
                      initialValue:
                          widget.frameModel.sceneInformation?.frameRate,
                      hint: 'Frame Rate',
                      options: const {
                        "FRAME RATES": {
                          "24 fps":
                              "Standard frame rate for cinema, creating a filmic look with natural motion blur.",
                          "23.98 fps":
                              "A slightly lower frame rate used primarily in North America to match the NTSC television standard, nearly indistinguishable from 24 fps.",
                          "25 fps":
                              "Standard frame rate for PAL and SECAM television systems, common in Europe and parts of Asia.",
                          "30 fps":
                              "Used for some TV broadcasts and often for online video, offering smoother motion than 24 fps.",
                          "29.97 fps":
                              "A standard for NTSC broadcast to accommodate color encoding, slightly lower than 30 fps to avoid interference.",
                          "48 fps":
                              "High frame rate used in some films for much smoother motion, reducing motion blur and judder in fast-moving scenes.",
                          "47.95 fps":
                              "A variation of 48 fps, adjusted for compatibility with certain broadcast systems or technical requirements.",
                          "50 fps":
                              "High frame rate used in PAL regions for sports broadcasts and live events, providing smoother motion.",
                          "59.94 fps":
                              "Twice the standard NTSC frame rate, used for high-motion video like sports to reduce motion blur.",
                          "60 fps":
                              "Provides very smooth motion, commonly used in video games and high-definition online video.",
                          "75 fps":
                              "An uncommon frame rate, offering even smoother motion, potentially used for specific computer or experimental uses.",
                          "100 fps":
                              "High frame rate for ultra-smooth motion in slow-motion playback or high-speed recording.",
                          "120 fps":
                              "Very high frame rate for ultra-smooth motion effects, slow-motion detail, or high-end video game rendering.",
                          "240 fps":
                              "Extremely high frame rate, used for super slow-motion effects in sports or scientific research.",
                          "300 fps":
                              "An ultra-high frame rate for specialized slow-motion capture, often in scientific or technical applications for analyzing fast movements."
                        }
                      },
                      onChange: (selectedOption) {
                        frameService.updateSceneInformation(
                          widget.frameModel.sceneInformation!.copyWith(
                            frameRate: selectedOption,
                          ),
                          widget.projectID,
                          widget.frameModel.id,
                        );
                      },
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  final List<XFile> _images = [];

  Future<void> _showImageDialog() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (mounted) {
        context.showLoading();
      }
      await _uploadImage(image);
      if (mounted) {
        context.hideLoading();
      }
      if (image != null) {
        _pageController?.jumpToPage(_images.length);
      }

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> _uploadImage(XFile? image) async {
    if (image != null) {
      _images.add(XFile(image.path));
      final bytes = await image.readAsBytes();
      if (kIsWeb) {
        await FrameService().addNewImage(
          file: null,
          image: bytes,
          widget.projectID,
          widget.frameModel.id,
        );
      } else {
        await FrameService().addNewImage(
          file: image,
          widget.projectID,
          widget.frameModel.id,
        );
      }
    }
  }
}

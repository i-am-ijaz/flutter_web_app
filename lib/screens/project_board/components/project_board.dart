import 'package:flutter/material.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:web_duplicate_app/constants.dart';
import 'package:web_duplicate_app/models/counter.dart';
import 'package:web_duplicate_app/models/project_model.dart';
import 'package:web_duplicate_app/screens/login/login.dart';
import 'package:web_duplicate_app/screens/project_board/components/email_inviation_dialog.dart';
import 'package:web_duplicate_app/screens/project_board/project_board_screen.dart';
import 'package:web_duplicate_app/services/project.dart';

class ProjectBoard extends StatefulWidget {
  const ProjectBoard({super.key});

  @override
  State<ProjectBoard> createState() => _ProjectBoardState();
}

class _ProjectBoardState extends State<ProjectBoard> {
  final _controller = AppFlowyBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move item from $fromIndex to $toIndex');
    },
    onMoveGroupItem: (groupId, fromIndex, toIndex) {
      debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
    },
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
    },
  );

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  Project? _project;

  List<TaskData> _todoTasks = [];
  List<TaskData> _onProcessTasks = [];
  List<TaskData> _finishedTasks = [];

  AppFlowyGroupData group1 = AppFlowyGroupData(
    id: "To Do",
    name: 'To Do',
    items: [],
  );

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    _controller.addListener(() {
      print("_project ${_project?.toJson()}");
      if (_project != null) {
        ProjectService().createProject(
          _project!.copyWith(
            todoTasks: _todoTasks,
            onProcessTasks: _onProcessTasks,
            finishedTasks: _finishedTasks,
          ),
        );
      } else {
        _fetchProject();
      }
    });

    _fetchProject();
    final group2 = AppFlowyGroupData(
      id: "On Process",
      name: 'On Process',
      items: [],
    );
    final group3 = AppFlowyGroupData(
      id: "Finished",
      name: 'Finished',
      items: [],
    );
    _controller.addGroup(group1);
    _controller.addGroup(group2);
    _controller.addGroup(group3);

    _controller.getGroupController(group1.id)?.addListener(() {
      if (_controller.getGroupController(group1.id) == null) return;

      _todoTasks = List<TextItem>.from(
              _controller.getGroupController(group1.id)!.groupData.items)
          .map((e) => e.data)
          .toList();
      print(_todoTasks.length);
    });

    _controller.getGroupController(group2.id)?.addListener(() {
      if (_controller.getGroupController(group2.id) == null) return;
      _onProcessTasks = List<TextItem>.from(
              _controller.getGroupController(group2.id)!.groupData.items)
          .map((e) => e.data)
          .toList();
      print(_onProcessTasks.length);
    });

    _controller.getGroupController(group3.id)?.addListener(() {
      if (_controller.getGroupController(group3.id) == null) return;

      _finishedTasks = List<TextItem>.from(
              _controller.getGroupController(group3.id)!.groupData.items)
          .map((e) => e.data)
          .toList();
      print(_finishedTasks.length);
    });
  }

  Future<void> _fetchProject() async {
    try {
      final date = DateTime.now();
      final id = DateFormat('dd-MM-yyyy').format(date);
      final project = await ProjectService().readProject(id);

      if (project == null) {
        final newProject = Project(
          id: id,
          name: 'Project $id',
          description: 'This is an example project for demonstration.',
          createdAt: date,
          counters: CounterModel(
            framesCount: 4,
            estTimeSpeak: '0:02',
            wordsCount: '10',
            characters: '100',
          ),
          assignedTo: const [],
        );

        await ProjectService().createProject(newProject);
        _project = newProject;
      } else {
        _project = project;
        _todoTasks = project.todoTasks;
        _onProcessTasks = project.onProcessTasks;
        _finishedTasks = project.finishedTasks;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 68.0,
          top: 68.0,
          bottom: 68.0,
        ),
        child: AppFlowyBoard(
          controller: _controller,
          groupConstraints: width > 800
              ? BoxConstraints(
                  maxWidth: width * 0.25,
                  minWidth: width * 0.25,
                  minHeight: 4000,
                )
              : const BoxConstraints(
                  maxWidth: 350,
                  minHeight: 4000,
                ),
          config: const AppFlowyBoardConfig(
            stretchGroupHeight: false,
          ),
          headerBuilder: (context, groupData) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 18.0,
                left: 16,
              ),
              child: Row(
                children: [
                  Text(
                    groupData.id,
                    style: const TextStyle(
                      color: colorWhite,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
          footerBuilder: (context, groupData) {
            if (groupData.id != 'To Do') {
              return const SizedBox.shrink();
            }

            return LayoutBuilder(
              builder: (context, constraint) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _showAddEditTaskDialog(
                        context: context,
                        canEdit: false,
                        data: TaskData(
                          title: '',
                          description: '',
                          createdAt: DateTime.now(),
                        ),
                        groupId: groupData.id,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: Size(constraint.maxWidth * 0.94, 50),
                    ),
                    child: const Text('Add Task'),
                  ),
                );
              },
            );
          },
          cardBuilder: (context, group, groupItem) {
            final textItem = groupItem as TextItem;
            return AppFlowyGroupCard(
              key: Key(textItem.data.title),
              decoration: BoxDecoration(
                color: ThemeColors.loginContainerColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                border: Border.all(
                  color: colorLightBlue,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: SvgPicture.asset(icEventNotes),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  textItem.data.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: colorWhite,
                                  ),
                                ),
                              ),
                              Text(
                                timeago.format(textItem.data.createdAt),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                          Text(
                            textItem.data.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: colorWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      color: ThemeColors.backgroundColor2,
                      onSelected: (value) {
                        if (value == 2) {
                          _deleteTask(group.id, textItem);
                        } else if (value == 1) {
                          _showAddEditTaskDialog(
                            context: context,
                            canEdit: true,
                            data: textItem.data,
                            groupId: group.id,
                          );
                        } else {
                          _showInviteUserToBoardDialog(context: context);
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(
                          color: colorLightBlueShade2,
                          width: 2,
                        ),
                      ),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 0,
                            child: Row(
                              children: [
                                SvgPicture.asset(icShare),
                                const SizedBox(width: 10),
                                const Text(
                                  'Share',
                                  style: TextStyle(color: colorWhite),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [
                                SvgPicture.asset(icEdit),
                                const SizedBox(width: 10),
                                const Text(
                                  'Edit',
                                  style: TextStyle(color: colorWhite),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Row(
                              children: [
                                SvgPicture.asset(icDelete),
                                const SizedBox(width: 10),
                                const Text(
                                  'Delete',
                                  style: TextStyle(color: colorWhite),
                                ),
                              ],
                            ),
                          )
                        ];
                      },
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: colorWhite,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddEditTaskDialog({
    required BuildContext context,
    required bool canEdit,
    required TaskData data,
    required String groupId,
  }) {
    if (canEdit) {
      _titleController.text = data.title;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          ' ${canEdit ? 'Edit' : 'Add'} Task',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: colorDarKBlue,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: colorSkyBlue, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width > 800
              ? 800
              : MediaQuery.sizeOf(context).width,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  validator: (title) {
                    if (title == null || title.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                  maxLength: 30,
                  keyboardType: TextInputType.multiline,
                  style: GoogleFonts.inter(fontSize: 12, color: colorWhite),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      color: colorWhite,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(color: colorSkyBlue),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(color: colorSkyBlue),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(color: colorSkyBlue),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  validator: (description) {
                    if (description == null || description.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                  maxLength: 180,
                  keyboardType: TextInputType.multiline,
                  style: GoogleFonts.inter(fontSize: 12, color: colorWhite),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      color: colorWhite,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(color: colorSkyBlue),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(color: colorSkyBlue),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(color: colorSkyBlue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
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
            onPressed: () {
              if (canEdit) {
                _updateTask(
                  groupId,
                  data,
                );
              } else {
                _addTask(groupId);
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _addTask(String groupId) {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      final title = _titleController.text;
      final description = _descriptionController.text;
      final data = TaskData(
        title: title,
        description: description,
        createdAt: DateTime.now(),
      );
      _controller.addGroupItem(groupId, TextItem(data));
      _titleController.clear();
      _descriptionController.clear();
    }
  }

  void _updateTask(String groupId, TaskData task) {
    Navigator.pop(context);
    final title = _titleController.text;
    const description = '';
    final data = task.copyWith(
      title: title,
      description: description,
    );
    _controller.updateGroupItem(groupId, TextItem(data));
    _titleController.clear();
    _descriptionController.clear();
  }

  void _deleteTask(String groupId, TextItem item) {
    _controller.removeGroupItem(groupId, item.id);
  }

  void _showInviteUserToBoardDialog({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) => InviteCollaboratorsDialog(
        projectID: _project!.id,
      ),
    );
  }
}

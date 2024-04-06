import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web_duplicate_app/components/text_widget.dart';
import 'package:web_duplicate_app/constants.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    super.key,
    required this.hint,
    required this.options,
    required this.onChange,
    this.initialValue,
  });

  final String hint;
  final Map<String, Map<String, String>> options;
  final void Function(String) onChange;
  final String? initialValue;

  @override
  CustomDropDownState createState() => CustomDropDownState();
}

class CustomDropDownState extends State<CustomDropDown> {
  List<String> selectedOptions = [];
  TextEditingController customTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      if (widget.initialValue!.contains(',')) {
        final keys = widget.initialValue!.split(',');
        for (var key in keys) {
          if (widget.options.values
              .any((element) => element.containsKey(key.trim()))) {
            selectedOptions.add(key.trim());
          }
        }
      } else {
        if (widget.options.values.any(
            (element) => element.containsKey(widget.initialValue!.trim()))) {
          selectedOptions.add(widget.initialValue!.trim());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: GestureDetector(
        onTap: () {
          _showCustomPopupMenu(context);
        },
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
              color: colorMediumBlue,
              border: Border.all(color: colorLightBlue),
              borderRadius: BorderRadius.circular(5),
            ),
            child: IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget(
                    text: selectedOptions.isNotEmpty
                        ? selectedOptions.join(', ')
                        : widget.hint,
                    fontSize: 11,
                  ),
                  const SizedBox(width: defaultPadding / 2),
                  SvgPicture.asset(icDownArrow),
                ],
              ),
            )),
      ),
    );
  }

  void _showCustomPopupMenu(BuildContext context) async {
    List<String> tempSelectedOptions = List.from(selectedOptions);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Select Options'),
              content: SingleChildScrollView(
                  child: Column(
                children: [
                  for (var categoryOptions in widget.options.entries)
                    Padding(
                      padding: const EdgeInsets.only(top: defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoryOptions.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          for (var optionEntry in categoryOptions.value.entries)
                            InkWell(
                              onTap: () {
                                // Cambiar el estado del checkbox al hacer clic en la fila
                                setStateDialog(() {
                                  if (tempSelectedOptions
                                      .contains(optionEntry.key)) {
                                    tempSelectedOptions.remove(optionEntry.key);
                                  } else {
                                    tempSelectedOptions.add(optionEntry.key);
                                  }
                                });
                              },
                              child: Tooltip(
                                message: optionEntry.value,
                                waitDuration: const Duration(seconds: 1),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: tempSelectedOptions
                                          .contains(optionEntry.key),
                                      onChanged: (bool? value) {
                                        setStateDialog(() {
                                          if (value == true) {
                                            tempSelectedOptions
                                                .add(optionEntry.key);
                                          } else {
                                            tempSelectedOptions
                                                .remove(optionEntry.key);
                                          }
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Text(optionEntry.key),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  TextField(
                    controller: customTextController,
                    decoration: const InputDecoration(
                      hintText: 'Custom',
                    ),
                  ),
                ],
              )),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final customText = customTextController.text;
                    if (customText.isNotEmpty) {
                      tempSelectedOptions.add(customText);
                      customTextController.clear();
                    }
                    setState(() {
                      selectedOptions = List.from(tempSelectedOptions);
                    });
                    Navigator.of(context).pop();
                    if (selectedOptions.isEmpty) {
                      widget.onChange('');
                    } else {
                      widget.onChange(selectedOptions.join(', '));
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    customTextController.dispose();
    super.dispose();
  }
}

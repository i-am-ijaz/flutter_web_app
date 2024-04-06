// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web_duplicate_app/components/custom_button.dart';
import 'package:web_duplicate_app/constants.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({
    super.key,
  });

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool isExpanded = false;

  Widget _switchedWidget = IconButton(
    onPressed: () {},
    icon: SvgPicture.asset(icEventNotes),
  );

  toggleExpansion() {
    isExpanded = !isExpanded;
    setState(() {});
    if (!isExpanded) {
      _switchedWidget = IconButton(
        onPressed: () {},
        icon: SvgPicture.asset(icEventNotes),
      );
    } else {
      _switchedWidget = const CustomDrawerButton(
        icon: icEventNotes,
        text: 'Projects',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 1280 && isExpanded) {
      toggleExpansion();
    }

    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: isExpanded ? 140 : 58,
          height: double.infinity,
          margin: EdgeInsets.only(right: isExpanded ? 15 : 25),
          decoration: BoxDecoration(
            color: colorDarKBlue,
            border: Border.all(color: colorLightBlue, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: defaultPadding / 2),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _switchedWidget,
              ),
              const SizedBox(height: defaultPadding / 2),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * .4,
          left: isExpanded ? 130 : 50,
          child: CloseOpenDrawerButton(
            isExpanded: isExpanded,
            onPressed: () => toggleExpansion(),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web_duplicate_app/components/text_widget.dart';
import 'package:web_duplicate_app/constants.dart';
import 'package:web_duplicate_app/screens/project/components/drawerMenu.dart';

class DashboardScreen extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool? backActionEnabled;

  const DashboardScreen({
    super.key,
    required this.title,
    required this.children,
    this.backActionEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Film Planner',
      color: Colors.white,
      child: Scaffold(
        backgroundColor: colorDarKBlue,
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: colorWhite),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 10,
                top: 15,
                bottom: 15,
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorSkyBlue,
                  shape: const CircleBorder(),
                ),
                child: SvgPicture.asset(
                  icQuestion,
                ),
              ),
            ),
          ],
          leading: backActionEnabled!
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 28,
                  ),
                )
              : null,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: defaultPadding / 15),
              TextWidget(
                text: title,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorLightBlue),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 70,
                            ),
                            child: Column(
                              children: children,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const DrawerMenu(),
          ],
        ),
      ),
    );
  }
}

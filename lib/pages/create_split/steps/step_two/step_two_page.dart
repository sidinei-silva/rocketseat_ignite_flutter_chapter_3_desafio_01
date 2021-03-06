import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:split_it/pages/create_split/create_split_controller.dart';

import 'package:split_it/pages/create_split/steps/step_two/step_two_controller.dart';
import 'package:split_it/pages/create_split/widgets/person_tile/person_tile_widget.dart';
import 'package:split_it/pages/create_split/widgets/step_input_text/step_input_text_widget.dart';
import 'package:split_it/pages/create_split/widgets/step_title/step_title_widget.dart';

class StepTwoPage extends StatefulWidget {
  final CreateSplitController createSplitController;

  StepTwoPage({
    Key? key,
    required this.createSplitController,
  }) : super(key: key);

  @override
  _StepTwoPageState createState() => _StepTwoPageState();
}

class _StepTwoPageState extends State<StepTwoPage> {
  late StepTwoController controller;

  @override
  void initState() {
    controller = StepTwoController(
      createSplitController: widget.createSplitController,
    );
    controller.getFriends();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StepTitleWidget(
          title: "Com quem",
          subtitle: "\nvocê quer dividir?",
        ),
        StepInputTextWidget(
          onChange: (value) {
            controller.onChange(value);
          },
          hintText: "Nome da pessoa",
        ),
        SizedBox(height: 35),
        Observer(builder: (_) {
          if (controller.selectFriends.isEmpty) {
            return Container();
          } else {
            return Column(
              children: controller.selectFriends
                  .map(
                    (friend) => PersonTileWidget(
                      isRemoved: true,
                      data: friend,
                      onPressed: () {
                        controller.removeFriends(friend: friend);
                      },
                    ),
                  )
                  .toList(),
            );
          }
        }),
        SizedBox(height: 20),
        Observer(builder: (_) {
          if (controller.items.isEmpty) {
            return Text("Nenhum amigo");
          } else {
            return Column(
              children: controller.items
                  .map(
                    (friend) => PersonTileWidget(
                      data: friend,
                      onPressed: () {
                        controller.addFriends(friend: friend);
                      },
                    ),
                  )
                  .toList(),
            );
          }
        }),
      ],
    );
  }
}

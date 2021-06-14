import 'package:flutter/material.dart';
import 'package:split_it/pages/home/home_controller.dart';
import 'package:split_it/pages/home/home_state.dart';
import 'package:split_it/pages/home/widgets/app_bar/app_bar_widget.dart';
import 'package:split_it/pages/home/widgets/event_tile/event_tile_widget.dart';
import 'package:split_it/pages/login/models/user_model.dart';
import 'package:split_it/shared/models/event_model.dart';
import 'package:split_it/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = HomeController();

  @override
  void initState() {
    homeController.getEvents();
    homeController.listen((state) => {setState(() {})});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      backgroundColor: AppTheme.colors.backgroundPrimary,
      appBar: AppBarWidget(
        user: user,
        buttonAddOnTap: () {
          Navigator.pushNamed(context, "/create_split");
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (homeController.homeState is HomeStateLoading) ...[
              ...List.generate(
                4,
                (index) => EventTileWidget(
                  isLoading: true,
                  data: EventModel(
                    date: DateTime.now(),
                    money: 0,
                    people: 0,
                    title: '',
                  ),
                ),
              )
            ] else if (homeController.homeState is HomeStateSuccess) ...[
              ...(homeController.homeState as HomeStateSuccess).events.map(
                    (event) => EventTileWidget(data: event),
                  )
            ] else if (homeController.homeState is HomeStateFailure) ...[
              Text((homeController.homeState as HomeStateFailure).message)
            ]
          ],
        ),
      ),
    );
  }
}

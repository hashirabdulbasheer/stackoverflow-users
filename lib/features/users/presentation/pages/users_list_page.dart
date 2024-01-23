import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/users/users.dart';

class SOFUsersListPage extends StatelessWidget {
  const SOFUsersListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SOFUsersListPageBloc, SOFUsersListPageState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Container(color: Colors.grey),
          );
        });
  }
}

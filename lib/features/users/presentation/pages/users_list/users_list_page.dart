import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/users/users.dart';
import 'widgets/users_list_widget.dart';

class SOFUsersListPage extends StatelessWidget {
  const SOFUsersListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SOFUsersListPageBloc, SOFUsersListPageState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is SOFUsersListPageLoadingState) {
            // loading
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is SOFUsersListPageErrorState) {
            // error
          } else if (state is SOFUsersListPageLoadedState) {
            // loaded state
            return Scaffold(
              appBar: AppBar(),
              body: SOFUsersListWidget(users: state.users),
            );
          }
          // default
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.green)),
          );
        });
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/failures.dart';
import '../../bloc/users/users.dart';
import 'widgets/error_widget.dart';
import 'widgets/users_list_widget.dart';

class SOFUsersListPage extends StatelessWidget {
  const SOFUsersListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<SOFUsersListPageBloc, SOFUsersListPageState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is SOFUsersListPageLoadingState) {
              // Loading
              return const Center(child: CircularProgressIndicator());
            } else if (state is SOFUsersListPageErrorState) {
              // Error - retry loading current page again
              return Center(
                  child: SOFErrorWidget(
                failure: state.failure as GeneralFailure,
                onRetry: () => _reloadPage(
                  context: context,
                  page: state.currentPage,
                ),
              ));
            } else if (state is SOFUsersListPageLoadedState) {
              // Loaded state
              return ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    physics: const BouncingScrollPhysics(),
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad
                    },
                  ),
                  child: RefreshIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.blue,
                      strokeWidth: 4.0,
                      onRefresh: () => _pullRefresh(context: context, page: 1),
                      child: SOFUsersListWidget(users: state.users)));
            }
            // Default
            return const Center(
                child: CircularProgressIndicator(color: Colors.green));
          }),
    );
  }

  Future<void> _pullRefresh(
      {required BuildContext context, required int page}) async {
    await Future.delayed(const Duration(seconds: 1));
    _reloadPage(context: context, page: page);
  }

  void _reloadPage({required BuildContext context, required int page}) {
    SOFUsersListPageBloc bloc = context.read<SOFUsersListPageBloc>();
    bloc.add(SOFUsersListPageLoadEvent(page: page));
  }
}

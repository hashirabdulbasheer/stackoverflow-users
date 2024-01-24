import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/failures.dart';
import '../../bloc/bookmarks/bookmarks.dart';
import '../../shared/error_widget.dart';
import 'widgets/bookmarks_list_widget.dart';

class SOFBookmarksListPage extends StatelessWidget {
  const SOFBookmarksListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("usersPage.bookmark_title".tr()),
      ),
      body: BlocConsumer<SOFBookmarksListPageBloc, SOFBookmarksListPageState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is SOFBookmarksListPageLoadingState) {
              /// Loading
              return const Center(child: CircularProgressIndicator());
            } else if (state is SOFBookmarksListPageErrorState) {
              /// Error - retry loading current page again
              return Center(
                  child: SOFErrorWidget(
                failure: state.failure as GeneralFailure,
                onRetry: () => _reloadPage(context),
              ));
            } else if (state is SOFBookmarksListPageLoadedState) {
              /// Loaded state
              if (state.users.isEmpty) {
                return Center(child: Text("error.no_bookmark".tr()));
              }
              return SOFBookmarksListWidget(
                users: state.users,
                onRefresh: () => _pullRefresh(context),
              );
            }
            // Default
            return const Center(
                child: CircularProgressIndicator(color: Colors.green));
          }),
    );
  }

  Future<void> _pullRefresh(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    _reloadPage(context);
  }

  void _reloadPage(BuildContext context) {
    SOFBookmarksListPageBloc bloc = context.read<SOFBookmarksListPageBloc>();
    bloc.add(SOFLoadBookmarksListPageEvent());
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/misc/logger.dart';
import '../../../../../core/models/failures.dart';
import '../../../domain/entities/user.dart';
import '../../bloc/users/users.dart';
import '../../shared/error_widget.dart';
import 'widgets/users_list_widget.dart';

class SOFUsersListPage extends StatefulWidget {
  const SOFUsersListPage({Key? key}) : super(key: key);

  @override
  State<SOFUsersListPage> createState() => _SOFUsersListPageState();
}

class _SOFUsersListPageState extends State<SOFUsersListPage> {
  final PagingController<int, SOFUser> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController
        .addPageRequestListener((page) => _pageControllerListener(page));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("user.title".tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/bookmarks').then((value) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  SOFUsersListPageBloc bloc =
                      context.read<SOFUsersListPageBloc>();
                  bloc.add(SOFInitializeUserListPageEvent());
                });
              });
            },
            child: Text("usersPage.bookmark_title".tr()),
          )
        ],
      ),
      body: BlocConsumer<SOFUsersListPageBloc, SOFUsersListPageState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is SOFUsersListPageLoadingState) {
              /// Loading
              return const Center(child: CircularProgressIndicator());
            } else if (state is SOFUsersListPageErrorState) {
              /// Error - retry loading current page again
              return Center(
                  child: SOFErrorWidget(
                failure: state.failure as GeneralFailure,
                onRetry: () => _onRefreshRequested(),
              ));
            } else if (state is SOFUsersListPageLoadedState) {
              /// Loaded state
              _pagingController.value = PagingState(
                nextPageKey: state.page + 1,
                error: null,
                itemList: state.users,
              );

              return SOFUsersListWidget(
                pagingController: _pagingController,
                onBookmarkTapped: (user) => _onBookmarkTapped(user),
                onRefreshRequested: () => _onRefreshRequested(),
              );
            }
            // Default
            return const Center(
                child: CircularProgressIndicator(color: Colors.green));
          }),
    );
  }

  void _pageControllerListener(int page) {
    // load next page
    SOFUsersListPageBloc bloc = context.read<SOFUsersListPageBloc>();
    if (bloc.state is SOFUsersListPageLoadedState) {
      SOFUsersListPageLoadedState state =
          bloc.state as SOFUsersListPageLoadedState;
      if (!state.isLoading) {
        // loading complete
        bloc.add(SOFUsersListPageLoadEvent(page: page));
        SOFLogger.d("Loading Page $page");
      }
    }
  }

  void _onBookmarkTapped(SOFUser user) {
    SOFUsersListPageBloc bloc = context.read<SOFUsersListPageBloc>();
    if (user.isBookmarked) {
      bloc.add(SOFRemoveBookmarkEvent(user: user));
    } else {
      bloc.add(SOFSaveBookmarkEvent(user: user));
    }
  }

  void _onRefreshRequested() {
    SOFUsersListPageBloc bloc = context.read<SOFUsersListPageBloc>();
    bloc.add(SOFForceLoadFromApiUserListPageEvent());
  }
}

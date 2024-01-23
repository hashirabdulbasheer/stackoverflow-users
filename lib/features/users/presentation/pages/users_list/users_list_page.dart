import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/models/failures.dart';
import '../../../domain/entities/user.dart';
import '../../bloc/users/users.dart';
import 'widgets/error_widget.dart';
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/bookmarks');
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
                onRetry: () => _reloadPage(),
              ));
            } else if (state is SOFUsersListPageLoadedState) {
              /// Loaded state
              _pagingController.value = PagingState(
                nextPageKey: state.page + 1,
                error: null,
                itemList: state.users,
              );
              return SOFUsersListWidget(
                users: state.users,
                pagingController: _pagingController,
                onBookmarkTapped: (user) => _onBookmarkTapped(user),
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
      }
    }
  }

  void _reloadPage() {
    _pagingController.refresh();
  }

  void _onBookmarkTapped(SOFUser user) {
    SOFUsersListPageBloc bloc = context.read<SOFUsersListPageBloc>();
    if(user.isBookmarked) {

    } else {
      bloc.add(SOFSaveBookmarkEvent(user: user));
    }
  }
}

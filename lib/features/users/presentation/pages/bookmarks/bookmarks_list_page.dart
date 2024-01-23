import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SOFBookmarksDisplayPage extends StatelessWidget {
  const SOFBookmarksDisplayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                    onRetry: () => _reloadPage(context, state.currentPage),
                  ));
            } else if (state is SOFUsersListPageLoadedState) {
              /// Loaded state
              _pagingController.value = PagingState(
                nextPageKey: state.page + 1,
                error: null,
                itemList: state.users,
              );
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
                      onRefresh: () => _pullRefresh(context, 1),
                      child: SOFUsersListWidget(
                        users: state.users,
                        pagingController: _pagingController,
                      )));
            }
            // Default
            return const Center(
                child: CircularProgressIndicator(color: Colors.green));
          }),
    );
  }
}

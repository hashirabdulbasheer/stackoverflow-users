import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/misc/logger.dart';
import '../../../../../core/models/failures.dart';
import '../../../domain/entities/reputation.dart';
import '../../bloc/reputations/reputations.dart';
import '../../shared/error_widget.dart';
import 'widgets/reputations_list_widget.dart';

class SOFReputationsListPage extends StatefulWidget {
  final int userId;

  const SOFReputationsListPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<SOFReputationsListPage> createState() => _SOFReputationsListPageState();
}

class _SOFReputationsListPageState extends State<SOFReputationsListPage> {
  final PagingController<int, SOFReputation> _pagingController =
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
        title: Text("reputation.title".tr()),
      ),
      body:
          BlocConsumer<SOFReputationsListPageBloc, SOFReputationsListPageState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is SOFReputationsListPageLoadingState) {
                  /// Loading
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SOFReputationsListPageErrorState) {
                  /// Error - retry loading current page again
                  return Center(
                      child: SOFErrorWidget(
                    failure: state.failure as GeneralFailure,
                    onRetry: () => _reloadPage(),
                  ));
                } else if (state is SOFReputationsListPageLoadedState) {
                  /// Loaded state
                  _pagingController.value = PagingState(
                    nextPageKey: state.page + 1,
                    error: null,
                    itemList: state.reputations,
                  );

                  return SOFReputationsListWidget(
                    pagingController: _pagingController,
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
    SOFReputationsListPageBloc bloc =
        context.read<SOFReputationsListPageBloc>();
    if (bloc.state is SOFReputationsListPageLoadedState) {
      SOFReputationsListPageLoadedState state =
          bloc.state as SOFReputationsListPageLoadedState;
      if (!state.isLoading) {
        // loading complete
        bloc.add(SOFReputationsListPageLoadEvent(
          page: page,
          userId: state.userId,
        ));
        SOFLogger.d("Loading Page $page");
      }
    }
  }

  void _reloadPage() {
    SOFReputationsListPageBloc bloc =
        context.read<SOFReputationsListPageBloc>();
    bloc.add(SOFInitializeReputationsListPageEvent(userId: widget.userId));
  }
}

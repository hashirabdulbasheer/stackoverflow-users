import 'package:flutter/material.dart';

import '../../../../../../core/misc/design_system.dart';
import '../../../../../../core/models/failures.dart';

class SOFErrorWidget extends StatelessWidget {
  final GeneralFailure failure;
  final Function onRetry;

  const SOFErrorWidget({Key? key, required this.failure, required this.onRetry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.warning_amber, size: 30),
        const SizedBox(
          height: 20,
        ),
        Text(
          "ERROR: ${failure.message}",
          style: SOFDesignSystem.subHeadline,
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () => onRetry(),
          child: const Text("Retry"),
        )
      ],
    );
  }
}

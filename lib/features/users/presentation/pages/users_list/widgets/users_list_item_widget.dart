import 'package:flutter/material.dart';

import '../../../../domain/entities/user.dart';

class SOFUsersListItemWidget extends StatelessWidget {
  final SOFUser user;

  const SOFUsersListItemWidget({Key? key, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 80,
          width: 100,
          child: Image.network(
            user.avatar.toString(),
            fit: BoxFit.fitHeight,
            errorBuilder: (context, object, stacktrace) {
              return const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: Colors.black26,
                ),
              );
            },
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${user.name}"),
              Text("Location: ${user.location}"),
              if (user.age != null) Text("Age: ${user.age.toString()}"),
              Text("Reputation: ${user.reputation.toString()}")
            ],
          ),
        ),
      ],
    );
  }
}

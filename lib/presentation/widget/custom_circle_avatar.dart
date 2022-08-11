import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuro_chat/presentation/constant/color.dart';
import 'package:kuro_chat/presentation/util/string_util.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({Key? key, this.imageUrl, this.name})
      : super(key: key);

  final String? imageUrl;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: imageUrl?.isNotEmpty == true
          ? Image(
              image: CachedNetworkImageProvider(imageUrl!),
            ).image
          : null,
      backgroundColor: clrMint,
      radius: 20.0,
      child: Text(
        name?.isNotEmpty == true ? name!.getInitials() : '',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

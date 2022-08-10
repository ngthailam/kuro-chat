import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuro_chat/presentation/constant/color.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({Key? key, this.imageUrl, this.name})
      : super(key: key);

  final String? imageUrl;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      // TODO: change substring to initials
      backgroundImage: imageUrl?.isNotEmpty == true
          ? Image(
              image: CachedNetworkImageProvider(imageUrl!),
            ).image
          : null,
      backgroundColor: clrMint,
      radius: 20.0,
      child: Text(
        name?.isNotEmpty == true ? name!.substring(0, 2) : '',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

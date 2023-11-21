import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:supashop/util/util.dart';

class HorizontalListAsync<T> extends StatelessWidget {
  Future<Iterable<T>> itens;
  double heightSkeleton;
  double widthSkeleton;
  Widget Function(T item) itemBuilder;

  HorizontalListAsync({
    required this.itens,
    required this.itemBuilder,
    this.heightSkeleton = 50,
    this.widthSkeleton = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FutureBuilder(
        future: itens,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return buildSkeleton();
          if (snap.hasError) return Text(snap.error.toString());
          return Row(children: [
            for (var category in snap.data!)
              Row(children: [itemBuilder(category), SizedBox(width: kPadding)])
          ]);
        },
      ),
    );
  }

  Widget buildSkeleton() => Row(children: [
        for (var i = 0; i < 8; i++)
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
                width: widthSkeleton,
                height: heightSkeleton,
                padding: EdgeInsets.only(
                  right: kPadding,
                )),
          )
      ]);
}
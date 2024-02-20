import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FutureBuilderGridView extends StatelessWidget {
  final Future future;
  final int gridCount;
  final Widget itemBuilder;

  const FutureBuilderGridView({
    Key? key,
    required this.future,
    required this.gridCount,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return itemBuilder;
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        } else {
          print(snapshot.error);
          // Shimmer loading animation
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            enabled: true,
            child: GridView.builder(
              itemCount: gridCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(15.0)),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

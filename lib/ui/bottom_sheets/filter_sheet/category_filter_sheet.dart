import 'package:flutter/material.dart';
import 'package:news_app_mayank/enums/category.dart';
import 'package:news_app_mayank/ui/common/app_colors.dart';
import 'package:news_app_mayank/ui/common/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';

class CategoryFilterSheet extends StatelessWidget {
  const CategoryFilterSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  final Function(SheetResponse)? completer;
  final SheetRequest request;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: Column(
        children: [
          Text(
            request.title!,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          verticalSpaceTiny,
          Text(
            request.description!,
            style: const TextStyle(fontSize: 14, color: kcMediumGrey),
            maxLines: 3,
            softWrap: true,
          ),
          verticalSpaceTiny,
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    Category.values.elementAt(index).name.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () {
                    completer?.call(
                      SheetResponse(
                        confirmed: true,
                        data: Category.values.elementAt(index) == Category.all
                            ? ''
                            : Category.values.elementAt(index),
                      ),
                    );
                  },
                );
              },
              itemCount: Category.values.length,
            ),
          ),
        ],
      ),
    );
  }
}

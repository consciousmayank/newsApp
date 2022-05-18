import 'package:flutter/material.dart';
import 'package:news_app_mayank/ui/common/app_colors.dart';
import 'package:news_app_mayank/ui/common/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';

class CountryFilterSheet extends StatelessWidget {
  const CountryFilterSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  final Function(SheetResponse)? completer;
  final Map<String, String> countriesList = const {
    'India': 'in',
    'United States': 'us',
    'United Kingdom': 'gb',
    'Canada': 'ca',
    'Australia': 'au',
    'Hong Kong': 'hk',
    'Singapore': 'sg',
  };

  final SheetRequest request;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
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
                    countriesList.keys.elementAt(index),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: Text(
                    countriesList.values.elementAt(index),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  onTap: () {
                    completer?.call(
                      SheetResponse(
                        confirmed: true,
                        data: countriesList.entries.elementAt(index).value,
                      ),
                    );
                  },
                );
              },
              itemCount: countriesList.entries.length,
            ),
          ),
        ],
      ),
    );
  }
}

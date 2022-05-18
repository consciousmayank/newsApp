import 'package:flutter/material.dart';
import 'package:news_app_mayank/enums/search_in.dart';
import 'package:news_app_mayank/ui/common/app_colors.dart';
import 'package:news_app_mayank/ui/common/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchInFilterList extends StatefulWidget {
  final Function(SheetResponse)? completer;
  final SheetRequest request;
  const SearchInFilterList({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  State<SearchInFilterList> createState() => _SearchInFilterListState();
}

class _SearchInFilterListState extends State<SearchInFilterList> {
  final Map<String, SearchIn> searchInOption = const {
    'Only in Titles': SearchIn.title,
    'Only in Descriptions': SearchIn.description,
    'Only in Content': SearchIn.content,
  };

  final List<SearchIn> _selectedSearchIn = [];

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
            widget.request.title!,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          verticalSpaceTiny,
          Text(
            widget.request.description!,
            style: const TextStyle(fontSize: 14, color: kcMediumGrey),
            maxLines: 3,
            softWrap: true,
          ),
          verticalSpaceTiny,
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  value: _selectedSearchIn
                      .contains(searchInOption.values.elementAt(index)),
                  title: Text(
                    searchInOption.keys.elementAt(index),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onChanged: (bool? value) {
                    if (value != null) {
                      if (value) {
                        _selectedSearchIn
                            .add(searchInOption.values.elementAt(index));
                      } else {
                        _selectedSearchIn
                            .remove(searchInOption.values.elementAt(index));
                      }
                    }
                  },
                );
              },
              itemCount: searchInOption.entries.length,
            ),
          ),
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.completer?.call(
                    SheetResponse(
                      confirmed: false,
                    ),
                  );
                },
                child: const Text(
                  'Cancel',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.completer?.call(
                    SheetResponse(
                      confirmed: true,
                      data: _selectedSearchIn,
                    ),
                  );
                },
                child: const Text(
                  'Ok',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

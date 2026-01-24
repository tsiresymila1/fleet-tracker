import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/api/navigation_service.dart';
import '../../../../core/theme/app_theme.dart';

class NavigationSearchBar extends StatelessWidget {
  final NavigationService navService;
  final Function(Map<String, dynamic>) onPlaceSelected;
  final VoidCallback onSearchStarted;
  final VoidCallback onSearchEnded;
  final bool isLoading;

  const NavigationSearchBar({
    super.key,
    required this.navService,
    required this.onPlaceSelected,
    required this.onSearchStarted,
    required this.onSearchEnded,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Autocomplete<Map<String, dynamic>>(
          optionsBuilder: (textEditingValue) async {
            if (textEditingValue.text.length < 3) return [];
            onSearchStarted();
            return await navService
                .searchPlaces(textEditingValue.text)
                .whenComplete(onSearchEnded);
          },
          displayStringForOption: (option) => option['display_name'],
          fieldViewBuilder: (
            context,
            textEditingController,
            focusNode,
            onFieldSubmitted,
          ) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'map_search_placeholder'.tr(),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.primaryPink,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                suffixIcon: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : null,
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).cardColor,
                child: Container(
                  width: MediaQuery.of(context).size.width - 96,
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        leading: Icon(
                          Icons.location_on_outlined,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          option['display_name'].toString().split(',')[0],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          option['display_name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          onSelected: onPlaceSelected,
        ),
      ),
    );
  }
}

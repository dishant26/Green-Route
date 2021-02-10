import 'package:green_route/buttons/round_button.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:flutter/material.dart';

import 'package:popup_menu/popup_menu.dart';

class floatingSearchBar extends StatelessWidget {
  floatingSearchBar({this.onPressed});
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: -1.0,
      openAxisAlignment: 0.0,
      maxWidth: 500,
      debounceDelay: const Duration(milliseconds: 200),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: true,
          child: CircularButton(
            icon: Icon(Icons.person),
            onPressed: onPressed,
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: Colors.white);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

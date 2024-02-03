import 'package:flutter/material.dart';
import 'package:music_player/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class NeuBox extends StatelessWidget {
  const NeuBox({super.key,required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            //darker shadow
            color: isDarkMode ? Colors.black : Colors.grey.shade500,
            blurRadius: 15,
            offset: const Offset(4,4)),

          BoxShadow(
            //lighter shadow
            color:isDarkMode ? Colors.grey.shade800 : Colors.white,
            blurRadius: 15,
            offset: const Offset(-4,-4))
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}
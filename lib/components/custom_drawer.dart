import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_player/pages/library.dart';
import 'package:music_player/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            // Logo Icon
            SizedBox(
              child: Lottie.asset("assets/lottie_icons/opener-loading.json"),
            ),
            // Home tile
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                title: const Text("Home"),
                leading: const Icon(Icons.home),
                onTap:(){
                  Navigator.pop(context);
                },
              ),
            ),

              // Dark mode toggle
              Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                title: const Text("Dark Mode"),
                leading: const Icon(Icons.dark_mode),
                trailing: Switch(
                    value: Provider.of<ThemeProvider>(context,listen: false).isDarkMode, 
                    onChanged: (value)=> Provider.of<ThemeProvider>(context,listen: false).toggleTheme(),
                    ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                title: const Text("Library"),
                leading: const Icon(Icons.library_music),
                onTap:(){
                  Navigator.pop(context);
                  Navigator.push(context, 
                  MaterialPageRoute(
                    builder: (context) => const Library(),
                    )
                    );
                },
              ),
              ),
          ],
        ),
      ),
    );
  }
}
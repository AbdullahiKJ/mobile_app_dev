import 'package:flutter/material.dart';
import 'package:mobile_app_dev/view/pages/new_post.dart';
import 'package:mobile_app_dev/view/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.cyanAccent),
      ),
      home: const PageLayout(title: "Social Media"),
    );
  }
}

class PageLayout extends StatefulWidget {
  const PageLayout({super.key, required this.title});
  final String title;

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  int currentPageIndex = 0;

  // todo: handle page navigation
  void _navigatePage(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // todo: the body should reflect the current page index (home, profile, search)
      body: HomePage(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) => _navigatePage(index),
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.account_circle_rounded), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const NewPost(),
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

}

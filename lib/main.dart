import 'package:flutter/material.dart';
import 'package:mobile_app_dev/view/pages/new_post.dart';
import 'package:mobile_app_dev/view/pages/home_page.dart';
import 'package:mobile_app_dev/view/pages/profile.dart';
import 'package:mobile_app_dev/view/pages/search.dart';

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
  late final HomePage _homePage;
  late final Profile _profilePage;
  late final Search _searchPage;

  @override
  void initState() {
    super.initState();
    _homePage = HomePage();
    _profilePage = Profile();
    _searchPage = Search();
  }

  void _navigatePage(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  Widget getCurrentPage(int index) {
    switch(index) {
      case 1:
        return _profilePage;
      case 2:
        return _searchPage;
      default:
        return _homePage;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentPageIndex == 0
          ? AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
          )
          : null,
      body: getCurrentPage(currentPageIndex),
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
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewPost(),
            ),
          );
          if(result == true){
            setState(() {});
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

}

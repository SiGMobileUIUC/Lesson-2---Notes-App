import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/misc/colors.dart';
import 'package:notes_app/screens/note.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String noteTitle = "My Note";
  String note = "This is my note";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            forceElevated: true,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Notes",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.black,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    isThreeLine: true,
                    title: Text(
                      noteTitle,
                      style: const TextStyle(fontSize: 25.0),
                    ),
                    subtitle: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              note,
                              style: const TextStyle(fontSize: 20.0),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(bottom: 5.0),
                          ),
                          Row(
                            children: [
                              Text(
                                DateFormat.yMd().format(DateTime.now()),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Note(
                          title: "My Note",
                          note: "This is my note",
                        ),
                      ));
                    },
                  ),
                );
              },
              childCount: 15,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: AppColors.urbanaOrange,
      ),
    );
  }
}

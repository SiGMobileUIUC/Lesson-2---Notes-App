import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/misc/colors.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/screens/notes.dart';
import 'package:notes_app/services/database_service.dart';
import 'package:notes_app/widgets/alert_box.dart';

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
  Future<List<Note>> future = DBService.db.getNotes();
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
              (context, ind) {
                return FutureBuilder(
                  future: future,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Note>?> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return const Center(
                          child: SpinKitRing(
                            color: AppColors.secondaryUofILightest,
                          ),
                        );
                      case ConnectionState.done:
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const AlertBox(
                            child: Text(
                              'You do not have any notes.',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                isThreeLine: true,
                                title: Text(
                                  snapshot.data![index].noteTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(fontSize: 25.0),
                                ),
                                subtitle: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Text(
                                          snapshot.data![index].note,
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                          style:
                                              const TextStyle(fontSize: 20.0),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            DateFormat.yMd()
                                                .format(DateTime.now()),
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
                                onTap: () async {
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => Notes(
                                      note: snapshot.data![index],
                                    ),
                                  ));
                                  setState(() {
                                    future = DBService.db.getNotes();
                                  });
                                },
                              ),
                            );
                          },
                        );
                    }
                  },
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Note newNote = await DBService.db.newNote("", "");
          setState(() {});
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Notes(
                note: newNote,
              ),
            ),
          );
          setState(() {
            future = DBService.db.getNotes();
          });
        },
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: AppColors.urbanaOrange,
      ),
    );
  }
}

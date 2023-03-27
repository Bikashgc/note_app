import 'package:flutter/material.dart';

import 'add_note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('add note button clicked');
          navigateToAddNote('Add Note');
        },
        tooltip: 'Add a note',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle? titleStyle = Theme.of(context).textTheme.headline6;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
            ),
            title: Text(
              'Title of note will appear here',
              style: titleStyle,
            ),
            subtitle: Text('subtitle will appear here'),
            trailing: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onTap: () {
              debugPrint("List Tile clicked");
              navigateToAddNote('Edit Note');
            },
          ),
        );
      },
    );
  }

  void navigateToAddNote(String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddNote(title);
    }));
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:note_app/models/note.dart';
import 'package:note_app/database/db_helper.dart';
import 'package:intl/intl.dart';

class AddNote extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  AddNote(this.note, this.appBarTitle);

  @override
  State<AddNote> createState() => _AddNoteState(this.note, this.appBarTitle);
}

class _AddNoteState extends State<AddNote> {
  static var _priorities = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  _AddNoteState(this.note, this.appBarTitle);

  @override
  void dispose() {
    // Cancel any active asynchronous operations here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6!;

    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
      onWillPop: () async {
        //To control back button, when user press back navigation button in device
        return Future.value(true);
        moveToHomePageScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // To control back button, when user press back navigation button in Appbar
              moveToHomePageScreen();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: ListView(
            children: [
              //Prority dropdown as first element in listview
              ListTile(
                title: DropdownButton(
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: textStyle,
                  value: getPriorityAsString(note.priority),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      debugPrint('User selected $valueSelectedByUser');
                      UpdatePriorityAsInt(valueSelectedByUser.toString());
                    });
                  },
                ),
              ),

              // title textfield of note as second element in listview
              Padding(
                padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Title of note is added in Title Text Field');
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),

              // description textfield of note as third element in listview
              Padding(
                padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint(
                        'Description of note is added in description Text Field');
                    updateDescription();
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),

              // Buttons to save note as fourth element in listview
              Padding(
                padding: EdgeInsets.only(bottom: 12.0, top: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Save button clicked");
                            _save();
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Delete button clicked");
                            _delete();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToHomePageScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to database
  void UpdatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  // Convert int priority to String Priority and display it to users in dropdown
  String getPriorityAsString(int value) {
    String priority = '';
    switch (value) {
      case 1:
        priority = _priorities[0]; //High
        break;
      case 2:
        priority = _priorities[1]; //Low
        break;
    }
    return priority;
  }

  // Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update thye description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToHomePageScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      // update operation
      result = await helper.updateNote(note);
    } else {
      // Insert operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      // success
      _showAlertDialog('Status', 'Note Saved Suscessfully');
    } else {
      // failure
      _showAlertDialog('Status', 'Problem saving Note');
    }
  }

  void _delete() async {
    moveToHomePageScreen();
    // If user is trying to delete the new note
    if (note.id == null) {
      _showAlertDialog('Status', 'No note deleted');
      return;
    }
    // if user is trying delete old nate having valid ID
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note deleted suscessfully');
    } else {
      _showAlertDialog('Status', 'Error occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}

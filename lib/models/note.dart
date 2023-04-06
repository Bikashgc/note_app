class Note {
  late int _id;
  late String _title;
  late String _description;
  late int _priority;
  late String _date;

  Note(
    this._title,
    this._date,
    this._priority,
    this._description,
  ) : _id = 0;

  Note.withId(
    this._id,
    this._title,
    this._date,
    this._priority,
    this._description,
  );

  int get id => _id;
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  String get date => _date;

  // no need to set id because id is automatically generated
  set title(String newTitle) {
    if (newTitle.length <= 200) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 300) {
      this._description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  set date(String newData) {
    this._date = newData;
  }

  //convert  a note object into a map object
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['title'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  //Extract a note object from a map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}

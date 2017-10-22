class Peer {
  final int tempId;
  final String id;
  List<Record> records;

  Peer({this.tempId, this.id, this.records});
}

class Record {
  var String record_date;
  var String created_at;
  var String asset;
  var Debt description;

  Record({this.record_date, this.created_at, this.asset, this.description});
}

class Debt {
  var String from
  var String to
  var String amt

  Debt({this.from, this.to, this.amt})
}

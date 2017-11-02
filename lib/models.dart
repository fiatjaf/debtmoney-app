class Peer {
  int idx;
  String id;
  String account;
  String name;

  Peer({this.idx, this.account, this.id, this.name});
}

class Event {
  String id;
  String name;
  String asset;
  String date;
  double mypmt;
  double mydue;
  double theirpmt;
  double theirdue;
  bool saved;

  Event({this.id, this.name,
         this.asset, this.date,
         this.mypmt, this.theirpmt,
         this.mydue, this.theirdue,
         this.saved});
}

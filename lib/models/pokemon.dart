class Pokemon {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  Pokemon({this.count, this.next, this.previous, this.results});
}

class Results {
  String? name;
  String? url;

  Results({this.name, this.url});
}

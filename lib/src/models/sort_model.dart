class SortModel{
  String name;
  String query;

  SortModel({required this.name,required this.query});

  @override
  String toString() {
    return 'SortModel{name: $name, query: $query}';
  }

  @override
  bool operator ==(dynamic  other) {
    return name==other.name&& query==other.query;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;



}
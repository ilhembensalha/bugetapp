class Objectif{

 int id;
  String name;
  String type;
  String somme;
 Objectif(this.id, this.name, this.somme, this.type);
  
    Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'somme': somme
    };
    return map;
  }

  Objectif.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    type = map['type'];
    somme= map['somme'];
  }
}

  
  
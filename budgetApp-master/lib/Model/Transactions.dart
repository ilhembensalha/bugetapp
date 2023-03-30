class Transactions{

 int id;
  String name;
  String prix;
  String description;
 Transactions(this.id, this.name, this.description, this.prix);
  
    Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'prix': prix,
      'description': description
    };
    return map;
  }

  Transactions.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    prix = map['prix'];
    description= map['description'];
  }
}

  
  
  
  
  
  
  
  
  
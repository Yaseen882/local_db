class Product {
  int id = 0;
  String name = '';
  String conception = '';
  static const tableName = 'Product';
  static const keyId = 'id';
  static const keName = 'name';
  static const keyConception = 'conception';
  static const createTable =
      'CREATE TABLE IF NOT EXISTS $tableName ($keyId INTEGER PRIMARY KEY,$keName TEXT,$keyConception TEXT)';

//<editor-fold desc="Data Methods">

  Product({
    required this.id,
    required this.name,
    required this.conception,
  });

//<ed@override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Product &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              conception == other.conception
          );


  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      conception.hashCode;


  @override
  String toString() {
    return 'Product{' +
        ' id: $id,' +
        ' name: $name,' +
        ' conception: $conception,' +
        '}';
  }


  Product copyWith({
    int? id,
    String? name,
    String? conception,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      conception: conception ?? this.conception,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'conception': conception,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
      conception: map['conception'] as String,
    );
  }


  //</editor-fold>



}

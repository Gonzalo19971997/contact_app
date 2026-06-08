class Contact {
  String _nom;
  String _email;
  String _telephone;
  String _photo;

  // Constructeur principal
  Contact(this._nom, this._email, this._telephone, this._photo);

  // Constructeur nommé (fromJson)
  Contact.fromJson(Map<String, dynamic> json)
    : _nom = json['name']['first'] + " " + json['name']['last'],
      _email = json['email'],
      _telephone = json['phone'],
      _photo = json['picture']['large'];

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'nom': _nom,
      'email': _email,
      'telephone': _telephone,
      'photo': _photo,
    };
  }

  // Getters
  String get nom => _nom;
  String get email => _email;
  String get telephone => _telephone;
  String get photo => _photo;

  // Setters avec validation
  set nom(String value) {
    if (value.isNotEmpty) {
      _nom = value;
    }
  }

  set email(String value) {
    if (value.contains("@")) {
      _email = value;
    }
  }

  set telephone(String value) {
    if (value.length >= 8) {
      _telephone = value;
    }
  }

  set photo(String value) {
    _photo = value;
  }
}

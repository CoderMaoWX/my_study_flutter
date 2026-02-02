class Owner {
  String name;
  String face;
  int fans;

  Owner({required this.name, required this.face, required this.fans});

  //将map转mo
  Owner.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        face = json['face'],
        fans = json['fans'];

  //将mo转map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['face'] = face;
    data['fans'] = fans;
    return data;
  }
}

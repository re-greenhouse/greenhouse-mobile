class DescriptionData {
  final String name;
  final String value;

  DescriptionData({required this.name, required this.value});

  factory DescriptionData.fromJson(Map<String, dynamic> json) {
    return DescriptionData(
      name: json['name'],
      value: json['value'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
      };
}

class Benefits {
  final List<DescriptionData> data;

  Benefits({required this.data});

  factory Benefits.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<DescriptionData> dataList =
        list.map((i) => DescriptionData.fromJson(i)).toList();
    return Benefits(data: dataList);
  }

  Map<String, dynamic> toJson() => {
        'data': data.map((item) => item.toJson()).toList(),
      };

  List<Map<String, dynamic>> getDifferences(Benefits other) {
    List<Map<String, dynamic>> differences = [];

    for (var data1 in data) {
      var data2 = other.data.firstWhere(
        (element) => element.name == data1.name,
        orElse: () => DescriptionData(name: data1.name, value: ''),
      );

      if (data1.value != data2.value) {
        differences.add({
          'name': data1.name,
          'before': data1.value,
          'after': data2.value,
        });
      }
    }
    print(differences);
    return differences;
  }
}

class MembershipLevel {
  String id;
  String name;
  final Benefits benefits;

  MembershipLevel({
    this.id = '',
    required this.name,
    required this.benefits,
  });

  factory MembershipLevel.fromJson(Map<String, dynamic> json) {
    return MembershipLevel(
      id: json['id'],
      name: json['name'],
      benefits: Benefits.fromJson(json['benefits']),
    );
  }

  Map<String, dynamic> toJson() =>
      {'name': benefits, 'benefits': benefits.toJson()};
}

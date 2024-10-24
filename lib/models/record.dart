class PayloadData {
  final String name;
  final String value;

  PayloadData({required this.name, required this.value});

  factory PayloadData.fromJson(Map<String, dynamic> json) {
    return PayloadData(
      name: json['name'],
      value: json['value'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'value': value,
  };
}

class Payload {
  final List<PayloadData> data;

  Payload({required this.data});

  factory Payload.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<PayloadData> dataList =
        list.map((i) => PayloadData.fromJson(i)).toList();
    return Payload(data: dataList);
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((item) => item.toJson()).toList(),
  };
}

class Record {
  String id;
  String author;
  String createdDate;
  String updatedDate;
  final String phase;
  final Payload payload;
  String cropId = '';

  Record({
    this.id = '',
    required this.author,
    this.createdDate = '',
    this.updatedDate = '',
    required this.phase,
    required this.payload,
    this.cropId = '',
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'],
      createdDate: json['createdDate'],
      author: json['author'],
      updatedDate: json['updatedDate'],
      phase: json['phase'],
      payload: Payload.fromJson(json['payload']),
    );
  }

  Map<String, dynamic> toJson() => {
    'author': author,
    'phase': phase,
    'payload': payload.toJson(),
    'cropId': cropId,
  };
}

class ColorValue {
  final int? id;
  final String date;
  final int color;

  ColorValue({this.id, required this.date, required this.color});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'color': color,
    };
  }

  factory ColorValue.fromMap(Map<String, dynamic> map) {
    return ColorValue(
      id: map['id'],
      date: map['date'],
      color: map['color'],
    );
  }
}

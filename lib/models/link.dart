import 'package:equatable/equatable.dart';

class Link extends Equatable {
  Link({
    required this.id,
    required this.type,
  });

  final String id;
  final String type;

  @override
  List<Object?> get props => [id, type];

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      id: json['sys']['id'],
      type: json['sys']['linkType'],
    );
  }

  Map<String, dynamic> toJson() => {
        'sys': {
          'type': 'Link',
          'linkType': type,
          'id': id,
        },
      };
}

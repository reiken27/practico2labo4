import 'dart:convert';

Move movimientoFromJson(String str) => Move.fromJson(json.decode(str));
String movimientoToJson(Move data) => json.encode(data.toJson());

class Move {
  int? id;
  String? name;
  int? accuracy;
  int? power;
  int? pp;
  int? priority;
  String? damageClass;
  String? target;
  String? type;
  List<EffectEntry>? effectEntries;
  Generation? generation;

  Move({
    this.id,
    this.name,
    this.accuracy,
    this.power,
    this.pp,
    this.priority,
    this.damageClass,
    this.target,
    this.type,
    this.effectEntries,
    this.generation,
  });

  factory Move.fromJson(Map<String, dynamic> json) => Move(
        id: json["id"],
        name: json["name"],
        accuracy: json["accuracy"],
        power: json["power"],
        pp: json["pp"],
        priority: json["priority"],
        damageClass: json["damage_class"]["name"],
        target: json["target"]["name"],
        type: json["type"]["name"],
        effectEntries: json["effect_entries"] == null
            ? []
            : List<EffectEntry>.from(
                json["effect_entries"]!.map((x) => EffectEntry.fromJson(x))),
        generation: json["generation"] == null
            ? null
            : Generation.fromJson(json["generation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "accuracy": accuracy,
        "power": power,
        "pp": pp,
        "priority": priority,
        "damage_class": damageClass,
        "target": target,
        "type": type,
        "effect_entries": effectEntries == null
            ? []
            : List<dynamic>.from(effectEntries!.map((x) => x.toJson())),
        "generation": generation?.toJson(),
      };
}

class EffectEntry {
  String? effect;
  String? shortEffect;
  Generation? language;

  EffectEntry({
    this.effect,
    this.shortEffect,
    this.language,
  });

  factory EffectEntry.fromJson(Map<String, dynamic> json) => EffectEntry(
        effect: json["effect"],
        shortEffect: json["short_effect"],
        language: json["language"] == null
            ? null
            : Generation.fromJson(json["language"]),
      );

  Map<String, dynamic> toJson() => {
        "effect": effect,
        "short_effect": shortEffect,
        "language": language?.toJson(),
      };
}

class Generation {
  String? name;
  String? url;

  Generation({
    this.name,
    this.url,
  });

  factory Generation.fromJson(Map<String, dynamic> json) => Generation(
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}

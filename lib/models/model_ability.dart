import 'dart:convert';

Ability abilityFromJson(String str) => Ability.fromJson(json.decode(str));

String abilityToJson(Ability data) => json.encode(data.toJson());

class Ability {
    List<EffectChange>? effectChanges;
    List<AbilityEffectEntry>? effectEntries;
    List<FlavorTextEntry>? flavorTextEntries;
    Generation? generation;
    int? id;
    bool? isMainSeries;
    String? name;
    List<Name>? names;
    List<Pokemon>? pokemon;

    Ability({
        this.effectChanges,
        this.effectEntries,
        this.flavorTextEntries,
        this.generation,
        this.id,
        this.isMainSeries,
        this.name,
        this.names,
        this.pokemon,
    });

    factory Ability.fromJson(Map<String, dynamic> json) => Ability(
        effectChanges: json["effect_changes"] == null ? [] : List<EffectChange>.from(json["effect_changes"]!.map((x) => EffectChange.fromJson(x))),
        effectEntries: json["effect_entries"] == null ? [] : List<AbilityEffectEntry>.from(json["effect_entries"]!.map((x) => AbilityEffectEntry.fromJson(x))),
        flavorTextEntries: json["flavor_text_entries"] == null ? [] : List<FlavorTextEntry>.from(json["flavor_text_entries"]!.map((x) => FlavorTextEntry.fromJson(x))),
        generation: json["generation"] == null ? null : Generation.fromJson(json["generation"]),
        id: json["id"],
        isMainSeries: json["is_main_series"],
        name: json["name"],
        names: json["names"] == null ? [] : List<Name>.from(json["names"]!.map((x) => Name.fromJson(x))),
        pokemon: json["pokemon"] == null ? [] : List<Pokemon>.from(json["pokemon"]!.map((x) => Pokemon.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "effect_changes": effectChanges == null ? [] : List<dynamic>.from(effectChanges!.map((x) => x.toJson())),
        "effect_entries": effectEntries == null ? [] : List<dynamic>.from(effectEntries!.map((x) => x.toJson())),
        "flavor_text_entries": flavorTextEntries == null ? [] : List<dynamic>.from(flavorTextEntries!.map((x) => x.toJson())),
        "generation": generation?.toJson(),
        "id": id,
        "is_main_series": isMainSeries,
        "name": name,
        "names": names == null ? [] : List<dynamic>.from(names!.map((x) => x.toJson())),
        "pokemon": pokemon == null ? [] : List<dynamic>.from(pokemon!.map((x) => x.toJson())),
    };
}

class EffectChange {
    List<EffectChangeEffectEntry>? effectEntries;
    Generation? versionGroup;

    EffectChange({
        this.effectEntries,
        this.versionGroup,
    });

    factory EffectChange.fromJson(Map<String, dynamic> json) => EffectChange(
        effectEntries: json["effect_entries"] == null ? [] : List<EffectChangeEffectEntry>.from(json["effect_entries"]!.map((x) => EffectChangeEffectEntry.fromJson(x))),
        versionGroup: json["version_group"] == null ? null : Generation.fromJson(json["version_group"]),
    );

    Map<String, dynamic> toJson() => {
        "effect_entries": effectEntries == null ? [] : List<dynamic>.from(effectEntries!.map((x) => x.toJson())),
        "version_group": versionGroup?.toJson(),
    };
}

class EffectChangeEffectEntry {
    String? effect;
    Generation? language;

    EffectChangeEffectEntry({
        this.effect,
        this.language,
    });

    factory EffectChangeEffectEntry.fromJson(Map<String, dynamic> json) => EffectChangeEffectEntry(
        effect: json["effect"],
        language: json["language"] == null ? null : Generation.fromJson(json["language"]),
    );

    Map<String, dynamic> toJson() => {
        "effect": effect,
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

class AbilityEffectEntry {
    String? effect;
    Generation? language;
    String? shortEffect;

    AbilityEffectEntry({
        this.effect,
        this.language,
        this.shortEffect,
    });

    factory AbilityEffectEntry.fromJson(Map<String, dynamic> json) => AbilityEffectEntry(
        effect: json["effect"],
        language: json["language"] == null ? null : Generation.fromJson(json["language"]),
        shortEffect: json["short_effect"],
    );

    Map<String, dynamic> toJson() => {
        "effect": effect,
        "language": language?.toJson(),
        "short_effect": shortEffect,
    };
}

class FlavorTextEntry {
    String? flavorText;
    Generation? language;
    Generation? versionGroup;

    FlavorTextEntry({
        this.flavorText,
        this.language,
        this.versionGroup,
    });

    factory FlavorTextEntry.fromJson(Map<String, dynamic> json) => FlavorTextEntry(
        flavorText: json["flavor_text"],
        language: json["language"] == null ? null : Generation.fromJson(json["language"]),
        versionGroup: json["version_group"] == null ? null : Generation.fromJson(json["version_group"]),
    );

    Map<String, dynamic> toJson() => {
        "flavor_text": flavorText,
        "language": language?.toJson(),
        "version_group": versionGroup?.toJson(),
    };
}

class Name {
    Generation? language;
    String? name;

    Name({
        this.language,
        this.name,
    });

    factory Name.fromJson(Map<String, dynamic> json) => Name(
        language: json["language"] == null ? null : Generation.fromJson(json["language"]),
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "language": language?.toJson(),
        "name": name,
    };
}

class Pokemon {
    bool? isHidden;
    Generation? pokemon;
    int? slot;

    Pokemon({
        this.isHidden,
        this.pokemon,
        this.slot,
    });

    factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(
        isHidden: json["is_hidden"],
        pokemon: json["pokemon"] == null ? null : Generation.fromJson(json["pokemon"]),
        slot: json["slot"],
    );

    Map<String, dynamic> toJson() => {
        "is_hidden": isHidden,
        "pokemon": pokemon?.toJson(),
        "slot": slot,
    };
}

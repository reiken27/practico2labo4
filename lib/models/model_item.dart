// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {
    List<Category>? attributes;
    dynamic babyTriggerFor;
    Category? category;
    int? cost;
    List<EffectEntry>? effectEntries;
    List<FlavorTextEntry>? flavorTextEntries;
    dynamic flingEffect;
    dynamic flingPower;
    List<GameIndex>? gameIndices;
    List<dynamic>? heldByPokemon;
    int? id;
    List<dynamic>? machines;
    String? name;
    List<Name>? names;
    Sprites? sprites;

    Item({
        this.attributes,
        this.babyTriggerFor,
        this.category,
        this.cost,
        this.effectEntries,
        this.flavorTextEntries,
        this.flingEffect,
        this.flingPower,
        this.gameIndices,
        this.heldByPokemon,
        this.id,
        this.machines,
        this.name,
        this.names,
        this.sprites,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        attributes: json["attributes"] == null ? [] : List<Category>.from(json["attributes"]!.map((x) => Category.fromJson(x))),
        babyTriggerFor: json["baby_trigger_for"],
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        cost: json["cost"],
        effectEntries: json["effect_entries"] == null ? [] : List<EffectEntry>.from(json["effect_entries"]!.map((x) => EffectEntry.fromJson(x))),
        flavorTextEntries: json["flavor_text_entries"] == null ? [] : List<FlavorTextEntry>.from(json["flavor_text_entries"]!.map((x) => FlavorTextEntry.fromJson(x))),
        flingEffect: json["fling_effect"],
        flingPower: json["fling_power"],
        gameIndices: json["game_indices"] == null ? [] : List<GameIndex>.from(json["game_indices"]!.map((x) => GameIndex.fromJson(x))),
        heldByPokemon: json["held_by_pokemon"] == null ? [] : List<dynamic>.from(json["held_by_pokemon"]!.map((x) => x)),
        id: json["id"],
        machines: json["machines"] == null ? [] : List<dynamic>.from(json["machines"]!.map((x) => x)),
        name: json["name"],
        names: json["names"] == null ? [] : List<Name>.from(json["names"]!.map((x) => Name.fromJson(x))),
        sprites: json["sprites"] == null ? null : Sprites.fromJson(json["sprites"]),
    );

    Map<String, dynamic> toJson() => {
        "attributes": attributes == null ? [] : List<dynamic>.from(attributes!.map((x) => x.toJson())),
        "baby_trigger_for": babyTriggerFor,
        "category": category?.toJson(),
        "cost": cost,
        "effect_entries": effectEntries == null ? [] : List<dynamic>.from(effectEntries!.map((x) => x.toJson())),
        "flavor_text_entries": flavorTextEntries == null ? [] : List<dynamic>.from(flavorTextEntries!.map((x) => x.toJson())),
        "fling_effect": flingEffect,
        "fling_power": flingPower,
        "game_indices": gameIndices == null ? [] : List<dynamic>.from(gameIndices!.map((x) => x.toJson())),
        "held_by_pokemon": heldByPokemon == null ? [] : List<dynamic>.from(heldByPokemon!.map((x) => x)),
        "id": id,
        "machines": machines == null ? [] : List<dynamic>.from(machines!.map((x) => x)),
        "name": name,
        "names": names == null ? [] : List<dynamic>.from(names!.map((x) => x.toJson())),
        "sprites": sprites?.toJson(),
    };
}

class Category {
    String? name;
    String? url;

    Category({
        this.name,
        this.url,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}

class EffectEntry {
    String? effect;
    Category? language;
    String? shortEffect;

    EffectEntry({
        this.effect,
        this.language,
        this.shortEffect,
    });

    factory EffectEntry.fromJson(Map<String, dynamic> json) => EffectEntry(
        effect: json["effect"],
        language: json["language"] == null ? null : Category.fromJson(json["language"]),
        shortEffect: json["short_effect"],
    );

    Map<String, dynamic> toJson() => {
        "effect": effect,
        "language": language?.toJson(),
        "short_effect": shortEffect,
    };
}

class FlavorTextEntry {
    Category? language;
    String? text;
    Category? versionGroup;

    FlavorTextEntry({
        this.language,
        this.text,
        this.versionGroup,
    });

    factory FlavorTextEntry.fromJson(Map<String, dynamic> json) => FlavorTextEntry(
        language: json["language"] == null ? null : Category.fromJson(json["language"]),
        text: json["text"],
        versionGroup: json["version_group"] == null ? null : Category.fromJson(json["version_group"]),
    );

    Map<String, dynamic> toJson() => {
        "language": language?.toJson(),
        "text": text,
        "version_group": versionGroup?.toJson(),
    };
}

class GameIndex {
    int? gameIndex;
    Category? generation;

    GameIndex({
        this.gameIndex,
        this.generation,
    });

    factory GameIndex.fromJson(Map<String, dynamic> json) => GameIndex(
        gameIndex: json["game_index"],
        generation: json["generation"] == null ? null : Category.fromJson(json["generation"]),
    );

    Map<String, dynamic> toJson() => {
        "game_index": gameIndex,
        "generation": generation?.toJson(),
    };
}

class Name {
    Category? language;
    String? name;

    Name({
        this.language,
        this.name,
    });

    factory Name.fromJson(Map<String, dynamic> json) => Name(
        language: json["language"] == null ? null : Category.fromJson(json["language"]),
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "language": language?.toJson(),
        "name": name,
    };
}

class Sprites {
    String? spritesDefault;

    Sprites({
        this.spritesDefault,
    });

    factory Sprites.fromJson(Map<String, dynamic> json) => Sprites(
        spritesDefault: json["default"],
    );

    Map<String, dynamic> toJson() => {
        "default": spritesDefault,
    };
}
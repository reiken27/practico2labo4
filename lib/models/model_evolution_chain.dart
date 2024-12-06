// To parse this JSON data, do
//
//     final evolutionchain = evolutionchainFromJson(jsonString);

import 'dart:convert';

ModelEvolutionChain evolutionchainFromJson(String str) => ModelEvolutionChain.fromJson(json.decode(str));

String evolutionchainToJson(ModelEvolutionChain data) => json.encode(data.toJson());

class ModelEvolutionChain {
    dynamic babyTriggerItem;
    Chain? chain;
    int? id;

    ModelEvolutionChain({
        this.babyTriggerItem,
        this.chain,
        this.id,
    });

    factory ModelEvolutionChain.fromJson(Map<String, dynamic> json) => ModelEvolutionChain(
        babyTriggerItem: json["baby_trigger_item"],
        chain: json["chain"] == null ? null : Chain.fromJson(json["chain"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "baby_trigger_item": babyTriggerItem,
        "chain": chain?.toJson(),
        "id": id,
    };
}

class Chain {
    List<EvolutionDetail>? evolutionDetails;
    List<Chain>? evolvesTo;
    bool? isBaby;
    Species? species;

    Chain({
        this.evolutionDetails,
        this.evolvesTo,
        this.isBaby,
        this.species,
    });

    factory Chain.fromJson(Map<String, dynamic> json) => Chain(
        evolutionDetails: json["evolution_details"] == null ? [] : List<EvolutionDetail>.from(json["evolution_details"]!.map((x) => EvolutionDetail.fromJson(x))),
        evolvesTo: json["evolves_to"] == null ? [] : List<Chain>.from(json["evolves_to"]!.map((x) => Chain.fromJson(x))),
        isBaby: json["is_baby"],
        species: json["species"] == null ? null : Species.fromJson(json["species"]),
    );

    Map<String, dynamic> toJson() => {
        "evolution_details": evolutionDetails == null ? [] : List<dynamic>.from(evolutionDetails!.map((x) => x.toJson())),
        "evolves_to": evolvesTo == null ? [] : List<dynamic>.from(evolvesTo!.map((x) => x.toJson())),
        "is_baby": isBaby,
        "species": species?.toJson(),
    };
}

class EvolutionDetail {
    dynamic gender;
    dynamic heldItem;
    dynamic item;
    dynamic knownMove;
    dynamic knownMoveType;
    dynamic location;
    dynamic minAffection;
    dynamic minBeauty;
    dynamic minHappiness;
    int? minLevel;
    bool? needsOverworldRain;
    dynamic partySpecies;
    dynamic partyType;
    dynamic relativePhysicalStats;
    String? timeOfDay;
    dynamic tradeSpecies;
    Species? trigger;
    bool? turnUpsideDown;

    EvolutionDetail({
        this.gender,
        this.heldItem,
        this.item,
        this.knownMove,
        this.knownMoveType,
        this.location,
        this.minAffection,
        this.minBeauty,
        this.minHappiness,
        this.minLevel,
        this.needsOverworldRain,
        this.partySpecies,
        this.partyType,
        this.relativePhysicalStats,
        this.timeOfDay,
        this.tradeSpecies,
        this.trigger,
        this.turnUpsideDown,
    });

    factory EvolutionDetail.fromJson(Map<String, dynamic> json) => EvolutionDetail(
        gender: json["gender"],
        heldItem: json["held_item"],
        item: json["item"],
        knownMove: json["known_move"],
        knownMoveType: json["known_move_type"],
        location: json["location"],
        minAffection: json["min_affection"],
        minBeauty: json["min_beauty"],
        minHappiness: json["min_happiness"],
        minLevel: json["min_level"],
        needsOverworldRain: json["needs_overworld_rain"],
        partySpecies: json["party_species"],
        partyType: json["party_type"],
        relativePhysicalStats: json["relative_physical_stats"],
        timeOfDay: json["time_of_day"],
        tradeSpecies: json["trade_species"],
        trigger: json["trigger"] == null ? null : Species.fromJson(json["trigger"]),
        turnUpsideDown: json["turn_upside_down"],
    );

    Map<String, dynamic> toJson() => {
        "gender": gender,
        "held_item": heldItem,
        "item": item,
        "known_move": knownMove,
        "known_move_type": knownMoveType,
        "location": location,
        "min_affection": minAffection,
        "min_beauty": minBeauty,
        "min_happiness": minHappiness,
        "min_level": minLevel,
        "needs_overworld_rain": needsOverworldRain,
        "party_species": partySpecies,
        "party_type": partyType,
        "relative_physical_stats": relativePhysicalStats,
        "time_of_day": timeOfDay,
        "trade_species": tradeSpecies,
        "trigger": trigger?.toJson(),
        "turn_upside_down": turnUpsideDown,
    };
}

class Species {
    String? name;
    String? url;

    Species({
        this.name,
        this.url,
    });

    factory Species.fromJson(Map<String, dynamic> json) => Species(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}

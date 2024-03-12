class Event {
  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    this.mapsLink,
    required this.category,
    required this.details,
    required this.price,
    required this.teamSize,
    required this.venue,
    required this.scedule,
    required this.isLimitedNumberOfTeams,
  });
  String id, name, description, image, category, venue;
  List<String> details;
  String? mapsLink;
  int price, teamSize;
  bool isLimitedNumberOfTeams;
  List<List<DateTime>> scedule;
}

class FilterData {
  String? frequency;
  String? category;
  Set<String> tags;
  String sortBy;

  FilterData({
    this.frequency,
    this.category,
    Set<String>? tags,
    this.sortBy = 'default',
  }) : tags = tags ?? {};

  FilterData copy() => FilterData(
    frequency: frequency,
    category: category,
    tags: Set<String>.from(tags),
    sortBy: sortBy,
  );
}

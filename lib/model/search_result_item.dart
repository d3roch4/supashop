class SearchResultItem {
  String id;
  String title;
  String subtitle;
  String image;
  SearchResultItemType type;

  SearchResultItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.type,
  });
}

enum SearchResultItemType { product, category, store }
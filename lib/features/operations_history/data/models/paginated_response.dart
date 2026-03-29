class PaginatedResponse<T> {
  final List<T> items;
  final bool hasMore;
  final String? nextUrl;

  PaginatedResponse({required this.items, required this.hasMore, this.nextUrl});
}

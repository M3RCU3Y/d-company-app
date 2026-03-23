class RestaurantFilterState {
  const RestaurantFilterState({
    this.query = '',
    this.selectedCategory = 'All',
  });

  final String query;
  final String selectedCategory;

  RestaurantFilterState copyWith({
    String? query,
    String? selectedCategory,
  }) {
    return RestaurantFilterState(
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

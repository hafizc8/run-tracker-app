class PaginatedDataResponse<T> {
  final PaginationMeta pagination;
  final List<T> data;

  PaginatedDataResponse({
    required this.pagination,
    required this.data,
  });

  factory PaginatedDataResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonItem,
  ) {
    return PaginatedDataResponse(
      pagination: PaginationMeta.fromJson(json['pagination']),
      data: List<T>.from(json['data'].map((item) => fromJsonItem(item))),
    );
  }
}

class PaginationMeta {
  final int total;
  final int offset;
  final int current;
  final int last;
  final String? next;
  final String? prev;

  PaginationMeta({
    required this.total,
    required this.offset,
    required this.current,
    required this.last,
    this.next,
    this.prev,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      total: json['total'],
      offset: json['offset'],
      current: json['current'],
      last: json['last'],
      next: json['next'],
      prev: json['prev'],
    );
  }
}

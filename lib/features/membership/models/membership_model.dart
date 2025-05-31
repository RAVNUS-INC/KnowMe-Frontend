class MembershipPlan {
  final String label;
  final String? originalPrice;
  final String price;
  final String? discountPrice;
  final String periodText;
  final bool isRecommended;

  MembershipPlan({
    required this.label,
    this.originalPrice,
    required this.price,
    this.discountPrice,
    required this.periodText,
    this.isRecommended = false,
  });
}

final List<MembershipPlan> membershipPlans = [
  MembershipPlan(
    label: '12개월',
    price: '70,800원',
    discountPrice: '63,800원',
    periodText: '/ 년',
    isRecommended: true,
  ),
  MembershipPlan(
    label: '1개월',
    price: '5,900원',
    periodText: '/ 월',
  ),
];
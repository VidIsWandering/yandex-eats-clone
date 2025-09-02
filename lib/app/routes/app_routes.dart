enum AppRoutes {
  auth('/auth'),
  restaurants('/restaurants'),
  cart('/cart'),
  profile('/profile'),
  orders('/orders'),
  updateEmail('/update-email');

  const AppRoutes(this.route);

  final String route;
}

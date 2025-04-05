import '../models/restaurant.dart';

class RestaurantService {
  // In a real app, this would call an API
  Future<List<Restaurant>> getNearbyRestaurants(
    String mealName, {
    int limit = 6,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data
    return [
      Restaurant(
        id: '1',
        name: 'Kahawa Sukari Restaurant',
        distance: '1.2 km',
        rating: 4.2,
        imageUrl:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&q=80',
      ),
      Restaurant(
        id: '2',
        name: 'Kahawa West Food Market',
        distance: '2.8 km',
        rating: 3.5,
        imageUrl:
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500&q=80',
      ),
      Restaurant(
        id: '3',
        name: 'Thika Road Mall Food Court',
        distance: '5.1 km',
        rating: 4.8,
        imageUrl:
            'https://images.unsplash.com/photo-1537047902294-62a40c20a6ae?w=500&q=80',
      ),
      Restaurant(
        id: '4',
        name: 'Garden City Restaurant',
        distance: '3.4 km',
        rating: 4.0,
        imageUrl:
            'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=500&q=80',
      ),
      Restaurant(
        id: '5',
        name: 'The Local Bistro',
        distance: '2.1 km',
        rating: 4.5,
        imageUrl:
            'https://images.unsplash.com/photo-1544148103-0773bf10d330?w=500&q=80',
      ),
      Restaurant(
        id: '6',
        name: 'Safari Grill House',
        distance: '4.3 km',
        rating: 4.1,
        imageUrl:
            'https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?w=500&q=80',
      ),
    ];
  }
}

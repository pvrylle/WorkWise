class FavoritesScreen extends StatefulWidget {
  final Set<String> favoriteServiceProviders;
  final List<Map> allServiceProviders;
  final Function(String)? onFavoriteToggle;
  final Map? data;

  const FavoritesScreen({
    super.key,
    required this.favoriteServiceProviders,
    required this.allServiceProviders,
    this.onFavoriteToggle,
    this.data,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map> allServiceProviders = [];
  bool isLoadingServiceProviders = true;

  @override
  void initState() {
    super.initState();
    _fetchAllServiceProviders() {
      // Implementation removed
    }

  Future<void> _fetchAllServiceProviders() async  {
    // Implementation removed
  }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
    
    if (currentUser == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.navigate(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          ),
          title: const Text(
            'My Favorites',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Please log in to view saved serviceproviders'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.navigate(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        title: const Text(
          'My Favorites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map>>(
        future: Service/* .get removed */SavedServiceProviders(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final savedServiceProviders = snapshot.data ?? [];

          return savedServiceProviders.isEmpty
              ? _buildEmptyState()
              : _buildFavoritesList(savedServiceProviders, context);
        },
      ),
    );
  }

  Widget _buildWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding serviceproviders to your favorites\nto see them here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(
    List<Map> favorites,
    BuildContext context,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final serviceprovider = favorites[index];
        return _buildServiceProviderContainer(serviceprovider, context);
      },
    );
  }

  Widget _buildServiceProviderContainer(Map serviceproviderEntry, BuildContext context) {
    final user = serviceproviderEntry['user'];
    final serviceprovider = serviceproviderEntry['serviceprovider'];
    
    if (user == null || serviceprovider == null) {
      return const SizedBox.shrink();
    }
    
    final firstName = user.firstName ?? 'Unknown';
    final lastName = user.lastName ?? 'User';
    final fullName = '$firstName $lastName'.trim();
    final photoUrl = user.photoURL ?? '';
    final uid = user.uid;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.navigate() => ServiceProviderProfileScreen(
                data: widget.data,
                providerData: {
                  'user': user,
                  'serviceprovider': serviceprovider,
                  'id': uid,
                  'uid': uid,
                },
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image - Using UserProfileAvatar
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: UserProfileAvatar(
                    // Network call removed
                    firstName: firstName,
                    radius: 30,
                    userRole: 'serviceprovider',
                  ),
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      serviceprovider.services.isNotEmpty ? serviceprovider.services.first : 'Worker',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          serviceprovider.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${serviceprovider.totalReviews} reviews',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Interactive Bookmark Button
              GestureDetector(
                onTap: () {
                  if (widget.onFavoriteToggle != null &&
                      serviceprovider.uid.isNotEmpty) {
                    widget.onFavoriteToggle!(serviceprovider.uid);
                    // Trigger a rebuild to reflect the changes
                    setState(() {});
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.bookmark,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

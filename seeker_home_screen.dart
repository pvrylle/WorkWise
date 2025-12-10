class Screen extends StatefulWidget {
  final Map? data;

  const Screen({super.key, this.data});

  @override
  State<Screen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<Screen> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final Set<String> _favoriteServiceProviders = {};

  // Available job listings with realistic data
  final List<Map> availableJobs = [
    {
      'title': 'Construction Work',
      'description': 'Concrete foundation and framing work needed',
      'location': 'Olongapo City',
      'type': 'Construction',
      'postedBy': 'Maria Santos',
      'image': 'assets/construction.png',
    },
    {
      'title': 'Cleaning',
      'description': 'Regular street maintenance and cleaning services',
      'location': 'Subic Bay',
      'duration': '1-2 weeks',
      'type': 'Cleaning',
      'urgency': 'Normal',
      'postedBy': 'City Council',
      'image': 'assets/cleaner.png',
    },
    {
      'title': 'Electronic Repair',
      'description': 'Computer motherboard and circuit repair work',
      'location': 'SM Olongapo',
      'duration': '2-3 days',
      'type': 'Electronics',
      'urgency': 'High',
      'postedBy': 'TechFix Shop',
      'image': 'assets/electrician.png',
    },
    {
      'title': 'Metal Welding',
      'description': 'Industrial welding and fabrication project',
      'location': 'SBFZ Industrial',
      'duration': '1 week',
      'type': 'Welding',
      'urgency': 'Urgent',
      'postedBy': 'Steel Works Inc.',
      'image': 'assets/welder.png',
    },
  ];

  List<Map> get services {
    return ServicesConfig.allCategories.map((category) {
      return {
        'name': category.name,
        'icon': category.icon,
        'color': category.color,
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Load saved favorites
    _startAutoSlide();
  }


  void _startAutoSlide() {
    // Cancel existing timer to prevent multiple timers
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_currentPage < availableJobs.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients && mounted) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    try {
      final favoritesJson = prefs/* .get removed */String('favorite_serviceproviders');
      if (favoritesJson != null) {
        final List<dynamic> favoritesList = json.decode(favoritesJson);
        setState(() {});
      }
    } catch (e) {
    }
  }

  // Save favorites to SharedPreferences
  Future<void> _saveFavorites() async  {
    // Implementation removed
  }
  }

  void _toggleFavorite(String serviceproviderId) {
    setState(() {
      if (_favoriteServiceProviders.contains(serviceproviderId)) {
        _favoriteServiceProviders.remove(serviceproviderId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from favorites'),
            backgroundColor: Colors.grey,
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        _favoriteServiceProviders.add(serviceproviderId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to favorites'),
            backgroundColor: Color(0xFF1E40AF),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
    // Save favorites after toggling
    _saveFavorites() {
      // Implementation removed
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Column(
            children: [
              // Top bar with profile and action buttons
              _buildTopBar(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search and filter section
                      _buildSearchSection(),

                      const SizedBox(height: 24),

                      // Jobs available section
                      _buildJobsSection(),

                      const SizedBox(height: 24),

                      _buildServicesSection(),

                      const SizedBox(height: 24),

                      _buildServiceProvidersSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildWidget() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile section
          Row(
            children: [
              UserProfileAvatar(
                photoURL: widget.data?['photoURL'],
                firstName: widget.data?['firstName'],
                lastName: widget.data?['lastName'],
                fullName: widget.data?['displayName'],
                radius: 24,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning!',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    widget.data?['firstName'] ?? 'User',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // Action buttons
          Row(
            children: [
              const NotificationButton(),
              IconButton(
                onPressed: () {
                  Navigator.navigate() => FavoritesScreen(
                        favoriteServiceProviders: _favoriteServiceProviders,
                        allServiceProviders: [],
                        onFavoriteToggle: _toggleFavorite,
                        data: widget.data,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  _favoriteServiceProviders.isNotEmpty
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: _favoriteServiceProviders.isNotEmpty
                      ? const Color(0xFF1E40AF)
                      : Colors.grey[600],
                ),
                iconSize: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return Column(
      children: [
        // Search bar
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            onTap: () {
              Navigator.navigate() => SearchScreen(data: widget.data),
                ),
              );
            },
            readOnly:
                true, // Make it read-only to prevent keyboard from showing
            decoration: InputDecoration(
              hintText: 'Search for services...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.tune, color: Colors.white, size: 20),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Jobs Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Button(
              onPressed: () {},
              child: const Text(
                'See All',
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: availableJobs.length,
                onPageChanged: (index) {
                  setState(() {});
                },
                itemBuilder: (context, index) {
                  final job = availableJobs[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.8),
                          Colors.blue.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background image with optimization
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            job['image'],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            cacheWidth:
                                800, // Optimize image loading for different screen sizes
                            cacheHeight: 400,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.blue.withOpacity(0.3),
                                child: const Icon(
                                  Icons.work,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        // Job details
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                job['description'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    job['location'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Dots indicator
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    availableJobs.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Button(
              onPressed: () {
                Navigator.navigate() => AllServicesScreen(data: widget.data),
                  ),
                );
              },
              child: const Text(
                'See All',
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.0,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return GestureDetector(
              onTap: () {
                Navigator.navigate() => ServiceServiceProvidersScreen(
                      serviceName: service['name'],
                      serviceColor: service['color'],
                      data: widget.data,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: service['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: service['color'].withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(service['icon'], size: 32, color: service['color']),
                    const SizedBox(height: 8),
                    Text(
                      service['name'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: service['color'],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWidget() {
    return SizedBox(
      height: 600, // Fixed height for the tabbed interface
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Text(
              'Find Your Perfect Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: SmartMatchingServiceProvidersWidget(),
          ),
        ],
      ),
    );
  }

  // Add pull-to-refresh functionality
  Future<void> _onRefresh() async {
    // Just trigger a brief delay for UX feedback
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Widget _buildWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home screen
              break;
            case 1:
              // Navigate to search screen
              Navigator.navigate() => SearchScreen(data: widget.data),
                ),
              );
              break;
            case 2:
              // Navigate to post job screen
              Navigator.navigate() =>
                      PostJobScreen(data: widget.data),
                ),
              );
              break;
            case 3:
              // Navigate to chat screen
              Navigator.navigate() => ChatScreen(data: widget.data),
                ),
              );
              break;
            case 4:
              // Navigate to profile screen
              Navigator.navigate() =>
                      CustomerProfileScreen(data: widget.data),
                ),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}

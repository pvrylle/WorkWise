class ServiceServiceProvidersScreen extends StatefulWidget {
  final String serviceName;
  final Color serviceColor;
  final Map? data;

  const ServiceServiceProvidersScreen({
    super.key,
    required this.serviceName,
    required this.serviceColor,
    this.data,
  });

  @override
  State<ServiceServiceProvidersScreen> createState() => _ServiceServiceProvidersScreenState();
}

class _ServiceServiceProvidersScreenState extends State<ServiceServiceProvidersScreen> {
  List<Map> filteredServiceProviders = [];
  bool isLoadingServiceProviders = true;
  bool _isLoadingMore = false;
  bool _hasMoreServiceProviders = true;
  
  late ScrollController _scrollController;
  
  final Set<String> _favoriteServiceProviders = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _fetchServiceServiceProviders() {
      // Implementation removed
    }

  void _onScroll() {
    if (!_isLoadingMore && _hasMoreServiceProviders) {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        _loadMoreServiceProviders();
      }
    }
  }

  Future<void> _loadMoreServiceProviders() async {
    if (_isLoadingMore || !_hasMoreServiceProviders) return;
    
    setState(() => _isLoadingMore = true);
    try {
      // Load next batch (starting from current count)
      final List<Map> allServiceProviders = 

      if (!mounted) return;
      final List<Map> newServiceProviders = [];

      for (var serviceproviderEntry in allServiceProviders) {
        final user = serviceproviderEntry['user'];
        final serviceprovider = serviceproviderEntry['serviceprovider'];

        // Skip if already loaded
        if (filteredServiceProviders.any((g) => g['id'] == user.uid)) continue;

        final List<dynamic> services = serviceprovider.services ?? [];
        final serviceToFind = widget.serviceName.toLowerCase();
        bool providesService = false;

        for (var service in services) {
          if (service.toString().toLowerCase() == serviceToFind ||
              service.toString().toLowerCase().contains(serviceToFind) ||
              serviceToFind.contains(service.toString().toLowerCase())) {
            providesService = true;
            break;
          }
        }

        if (!providesService) {
          final List<dynamic> skills = serviceprovider.skills ?? [];
          for (var skill in skills) {
            if (skill.toString().toLowerCase().contains(serviceToFind) ||
                serviceToFind.contains(skill.toString().toLowerCase())) {
              providesService = true;
              break;
            }
          }
        }

        if (providesService) {
          final String firstName = user.firstName ?? 'Unknown';
          final String lastName = user.lastName ?? 'User';
          final double hourlyRate = serviceprovider.hourlyRate ?? 500.0;
          
          String location = 'Philippines';
          if (user.address != null) {
            try {
              if (user.address!.city.isNotEmpty) {
                location = user.address!.city;
                if (user.address!.barangay.isNotEmpty) {
                  location = '${user.address!.barangay}, ${user.address!.city}';
                }
              }
            } catch (e) {
              final addressStr = user.address.toString();
              if (addressStr.isNotEmpty && addressStr != 'null') {
                location = addressStr;
              }
            }
          }
          
          newServiceProviders.add({
            'id': user.uid,
            'name': '$firstName $lastName'.trim(),
            'profession': serviceprovider.experience ?? (serviceprovider.services.isNotEmpty ? serviceprovider.services.first : 'General Worker'),
            'price': '₱${hourlyRate.toInt()}',
            'rating': double.parse(serviceprovider.rating.toStringAsFixed(1)),
            'reviews': serviceprovider.totalReviews,
            'location': location,
            // Network call removed
            'bio': serviceprovider.description ?? '',
            'skills': serviceprovider.skills,
            'services': serviceprovider.services,
            'isOnline': serviceprovider.isAvailable,
            'lastSeen': user.lastSignIn,
            'completedJobs': serviceprovider.totalJobs,
            'data': user,
            'providerData': serviceprovider,
          });
        }
      }

      setState(() {});
    } catch (e) {
      setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _fetchServiceServiceProviders() async  {
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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.serviceName} ServiceProviders',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!isLoadingServiceProviders)
              Text(
                '${filteredServiceProviders.length} available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchServiceServiceProviders,
        child: Column(
          children: [
            _buildServiceHeader(),
            
            Expanded(
              child: _buildServiceProvidersList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildWidget() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.serviceColor.withOpacity(0.8),
            widget.serviceColor.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.serviceColor.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getServiceIcon(widget.serviceName),
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.serviceName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLoadingServiceProviders 
                    ? 'Loading serviceproviders...' 
                    : '${filteredServiceProviders.length} ${filteredServiceProviders.length == 1 ? 'serviceprovider' : 'serviceproviders'} available',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    if (isLoadingServiceProviders) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Finding serviceproviders...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredServiceProviders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No ${widget.serviceName} serviceproviders found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Try checking other services or refresh the page',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchServiceServiceProviders,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.serviceColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: filteredServiceProviders.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == filteredServiceProviders.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        }
        final serviceprovider = filteredServiceProviders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.navigate() => ServiceProviderProfileScreen(
                      data: widget.data,
                      providerData: {
                        'user': serviceprovider['data'],
                        'serviceprovider': serviceprovider['providerData'],
                        
                        // Also include processed display data for backward compatibility
                        'id': serviceprovider['id'],
                        'firstName': serviceprovider['data']?.firstName ?? 'Unknown',
                        'lastName': serviceprovider['data']?.lastName ?? 'User',
                        'role': serviceprovider['profession'],
                        'profileImageUrl': serviceprovider['image'],
                        'hourlyRate': serviceprovider['providerData']?.hourlyRate ?? 500,
                        'experience': serviceprovider['providerData']?.experience ?? '0-1',
                        'address': serviceprovider['location'],
                        'rating': serviceprovider['rating'],
                        'totalJobs': serviceprovider['providerData']?.totalJobs ?? 0,
                        'description': serviceprovider['providerData']?.description ?? serviceprovider['bio'],
                        'skills': serviceprovider['providerData']?.skills ?? serviceprovider['skills'] ?? [],
                        'services': serviceprovider['providerData']?.services ?? [],
                        'certifications': serviceprovider['providerData']?.certifications ?? [],
                        'uid': serviceprovider['data']?.uid ?? serviceprovider['id'],
                      },
                      favoriteServiceProviders: _favoriteServiceProviders,
                      onFavoriteToggle: _toggleFavorite,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Profile picture
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          // Network call removed
                              ? NetworkImage(serviceprovider['image'])
                              : AssetImage(serviceprovider['image']) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            serviceprovider['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),

                          if (serviceprovider['services'] != null && (serviceprovider['services'] as List).isNotEmpty)
                            Wrap(
                              spacing: 6,
                              children: (serviceprovider['services'] as List).take(3).map<Widget>((service) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: widget.serviceColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: widget.serviceColor.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    service.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: widget.serviceColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          const SizedBox(height: 8),

                          // Price
                          Text(
                            serviceprovider['price'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E40AF),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Location and rating
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.grey[500],
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  serviceprovider['location'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${serviceprovider['rating']} (${serviceprovider['reviews']})',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Bookmark icon
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _favoriteServiceProviders.contains(serviceprovider['id'])
                            ? const Color(0xFF1E40AF)
                            : Colors.transparent,
                        border: _favoriteServiceProviders.contains(serviceprovider['id'])
                            ? null
                            : Border.all(
                                color: Colors.grey.shade400,
                                width: 1.5,
                              ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () => _toggleFavorite(serviceprovider['id']),
                        icon: Icon(
                          _favoriteServiceProviders.contains(serviceprovider['id'])
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: _favoriteServiceProviders.contains(serviceprovider['id'])
                              ? Colors.white
                              : Colors.grey.shade600,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
        currentIndex: 1, // Search tab selected since this is service-specific
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigate to home screen
              Navigator.navigate() => Screen(data: widget.data),
                ),
                (route) => false,
              );
              break;
            case 1:
              // Navigate to search screen
              Navigator.navigate() => SearchScreen(data: widget.data),
                ),
              );
              break;
            case 2:
              // Navigate to post job screen
              Navigator.navigate() => PostJobScreen(data: widget.data),
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
              Navigator.navigate() => CustomerProfileScreen(data: widget.data),
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

  IconData _getServiceIcon(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'Construction':
        return Icons.construction;
      case 'Plumbing':
        return Icons.plumbing;
      case 'Electrical':
        return Icons.electrical_services;
      case 'Mechanical':
        return Icons.engineering;
      case 'Cleaning':
        return Icons.cleaning_services;
      case 'Logistics':
        return Icons.local_shipping;
      case 'Painting':
        return Icons.format_paint;
      case 'Repairing':
        return Icons.build;
      default:
        return Icons.work;
    }
  }
}

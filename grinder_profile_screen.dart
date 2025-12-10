class ServiceProviderProfileScreen extends StatefulWidget {
  final Map providerData;
  final Map? data;
  final Set<String>? favoriteServiceProviders;
  final Function(String)? onFavoriteToggle;

  const ServiceProviderProfileScreen({
    super.key,
    required this.providerData,
    this.data,
    this.favoriteServiceProviders,
    this.onFavoriteToggle,
  });

  @override
  State<ServiceProviderProfileScreen> createState() => _ServiceProviderProfileScreenState();
}

class _ServiceProviderProfileScreenState extends State<ServiceProviderProfileScreen> {
  bool _isStartingChat = false;
  List<Map> _serviceproviderReviews = [];
  double _averageRating = 0.0;
  Map _ratingStats = {};
  String _selectedRatingFilter = 'All';
  final Set<String> _likedReviews = {};
  int _completedJobsCount = 0; // Real count from booking history
  bool _isLoadingJobsCount = true;
  bool _showAllServices = false; // Toggle for services expansion
  bool _isBookmarked = false; // Track bookmark status
  late Stream<List<String>> _bookmarksStream; // Stream for real-time bookmark updates

  List<String> get serviceproviderServices {
    List<String> services = [];
    
    // First try nested structure
    final providerData = widget.providerData['serviceprovider'];
    if (providerData != null) {
      try {
        services = List<String>.from(providerData.services ?? []);
      } catch (e) {
        // Try Map access
        if (providerData is Map) {
          services = List<String>.from(providerData['services'] ?? []);
        }
      }
    }
    
    if (services.isEmpty) {
      try {
        services = List<String>.from(widget.providerData['services'] ?? []);
        if (services.isEmpty) {
          services = List<String>.from(widget.providerData['skills'] ?? []);
        }
        if (services.isEmpty && widget.providerData['profession'] != null) {
          services = [widget.providerData['profession']];
        }
      } catch (e) {
      }
    }
    
    services = services/* .where removed */((s) => s.toString().isNotEmpty && s.toString() != '0-1').map((s) => s.toString()).toList();
    
    return services.isNotEmpty ? services : ['General Services'];
  }

  List<String> get serviceproviderCertifications {
    final providerData = widget.providerData['serviceprovider'] ?? widget.providerData;
    if (providerData != null) {
      try {
        return List<String>.from(providerData.certifications ?? []);
      } catch (e) {
        // Fallback to Map access
        if (providerData is Map) {
          return List<String>.from(providerData['certifications'] ?? []);
        }
      }
    }
    return [];
  }

  List<String> get serviceproviderPhotos {
    final providerData = widget.providerData['serviceprovider'] ?? widget.providerData;
    if (providerData != null) {
      try {
        return List<String>.from(providerData.portfolioUrls ?? []);
      } catch (e) {
        // Fallback to Map access
        if (providerData is Map) {
          return List<String>.from(providerData['portfolioImages'] ?? providerData['portfolioUrls'] ?? []);
        }
      }
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _loadServiceProviderReviews();
    _loadCompletedJobsCount(); // Load real completed jobs count
    _debugServiceProviderData();
    _initializeBookmarkStream(); // Initialize bookmark stream
  }

  // Initialize bookmark stream to track real-time changes
  void _initializeBookmarkStream() {
    _bookmarksStream = FavoritesService.favoritesStream();
    _checkIfBookmarked() {
      // Implementation removed
    }

  // Check current bookmark status
  Future<void> _checkIfBookmarked() async  {
    // Implementation removed
  }
  }

  String? _getServiceProviderId() {
    String? serviceproviderId = widget.providerData['id'] as String?;
    
    if (serviceproviderId == null || serviceproviderId.isEmpty) {
      serviceproviderId = widget.providerData['uid'] as String?;
    }
    
    if ((serviceproviderId == null || serviceproviderId.isEmpty) && widget.providerData['user'] != null) {
      final data = widget.providerData['user'];
      if (data is Map) {
        serviceproviderId = data['uid'] as String?;
      } else {
        try {
          serviceproviderId = (data as dynamic).uid as String?;
        } catch (e) {}
      }
    }
    
    return serviceproviderId;
  }

  // Load actual completed jobs count from booking history
  Future<void> _loadCompletedJobsCount() async {
    try {
      String? serviceproviderId = widget.providerData['id'] as String?;
      
      // Fallback to uid field
      if (serviceproviderId == null || serviceproviderId.isEmpty) {
        serviceproviderId = widget.providerData['uid'] as String?;
      }
      
      // Fallback to user.uid
      if ((serviceproviderId == null || serviceproviderId.isEmpty) && widget.providerData['user'] != null) {
        final data = widget.providerData['user'];
        if (data is Map) {
          serviceproviderId = data['uid'] as String?;
        } else {
          try {
            serviceproviderId = data.uid as String?;
          } catch (e) {}
        }
      }
      
      if ((serviceproviderId == null || serviceproviderId.isEmpty) && widget.providerData['serviceprovider'] != null) {
        final providerData = widget.providerData['serviceprovider'];
        if (providerData is Map) {
          serviceproviderId = providerData['uid'] as String?;
        } else {
          try {
            serviceproviderId = providerData.uid as String?;
          } catch (e) {}
        }
      }

      if (serviceproviderId == null || serviceproviderId.isEmpty) {
        if (mounted) {});
        }
        return;
      }
      // Get completed jobs from booking history
      if (mounted) {});
      }
    } catch (e) {
      if (mounted) {});
      }
    }
  }

  void _debugServiceProviderData() {
    // Check if we have nested or flat structure
    final data = widget.providerData['user'];
    final providerData = widget.providerData['serviceprovider'];
    
    if (data != null && providerData != null) {
      if (data is Map) {
      } else {
        try {
        } catch (e) {
        }
      }
    }
  }

  Future<void> _loadServiceProviderReviews() async {
    try {
      String? serviceproviderId = widget.providerData['id'] as String?;
      
      // Fallback to uid field
      if (serviceproviderId == null || serviceproviderId.isEmpty) {
        serviceproviderId = widget.providerData['uid'] as String?;
      }
      
      // Fallback to user.uid
      if ((serviceproviderId == null || serviceproviderId.isEmpty) && widget.providerData['user'] != null) {
        final data = widget.providerData['user'];
        if (data is Map) {
          serviceproviderId = data['uid'] as String?;
        } else {
          try {
            serviceproviderId = data.uid as String?;
          } catch (e) {}
        }
      }
      
      if ((serviceproviderId == null || serviceproviderId.isEmpty) && widget.providerData['serviceprovider'] != null) {
        final providerData = widget.providerData['serviceprovider'];
        if (providerData is Map) {
          serviceproviderId = providerData['uid'] as String?;
        } else {
          try {
            serviceproviderId = providerData.uid as String?;
          } catch (e) {}
        }
      }
      
      if (serviceproviderId == null || serviceproviderId.isEmpty) {
        return;
      }

      if (mounted) {});
      }
    } catch (e) {
      // Keep empty reviews list as fallback
      if (mounted) {};
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with background image and overlay
          _buildHeader(),
          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileInfo(),
                  _buildServices(),
                  _buildReviews(),
                  const SizedBox(height: 100), // Space for bottom buttons
                ],
              ),
            ),
          ),
          // Bottom action buttons
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/construction.png'), // Background work image
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.navigate(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleFavorite,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _isBookmarked
                                  ? const Color(0xFF1E40AF)
                                  : Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              _isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _showOptionsMenu,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Profile image and verified badge
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: UserProfileAvatar(
                            photoURL: () {
                              // Gather possible raw value
                              String? raw;
                              final data = widget.providerData['user'];
                              if (data != null) {
                                if (data is Map) {
                                  raw = (data['photoURL'] ?? data['profileImageUrl']) as String?;
                                } else {
                                  try {
                                    raw = data.photoURL as String?; // dynamic access
                                  } catch (_) {}
                                }
                              }
                              raw ??= widget.providerData['profileImageUrl'] as String? ?? widget.providerData['photoURL'] as String?;
                              if (raw == null) return null;
                              final t = raw.trim();
                              if (t.isEmpty || t == 'null' || t == 'No image') return null; // force fallback
                              return t;
                            }(),
                            firstName: () {
                              final data = widget.providerData['user'];
                              if (data != null) {
                                if (data is Map) {
                                  return data['firstName'];
                                } else {
                                  try {
                                    return data.firstName;
                                  } catch (e) {
                                    return null;
                                  }
                                }
                              }
                              return widget.providerData['firstName'];
                            }(),
                            lastName: () {
                              final data = widget.providerData['user'];
                              if (data != null) {
                                if (data is Map) {
                                  return data['lastName'];
                                } else {
                                  try {
                                    return data.lastName;
                                  } catch (e) {
                                    return null;
                                  }
                                }
                              }
                              return widget.providerData['lastName'];
                            }(),
                            fullName: () {
                              final data = widget.providerData['user'];
                              if (data != null) {
                                if (data is Map) {
                                  return data['displayName'];
                                } else {
                                  try {
                                    return data.displayName;
                                  } catch (e) {
                                    return null;
                                  }
                                }
                              }
                              return widget.providerData['displayName'];
                            }(),
                            radius: 45,
                            userRole: 'serviceprovider',
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E40AF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidget() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and verification badge
          Row(
            children: [
              Text(
                () {
                  final data = widget.providerData['user'] ?? widget.providerData;
                  String firstName = 'Unknown';
                  String lastName = 'User';
                  if (data != null) {
                    try {
                      firstName = data.firstName ?? 'Unknown';
                      lastName = data.lastName ?? 'User';
                    } catch (e) {
                      if (data is Map) {
                        firstName = data['firstName'] ?? 'Unknown';
                        lastName = data['lastName'] ?? 'User';
                      }
                    }
                  }
                  return '$firstName $lastName';
                }(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.verified, color: Color(0xFF1E40AF), size: 20),
            ],
          ),

          const SizedBox(height: 8),

          // Per day rate
          Row(
            children: [
              Text(
                'Per Day',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const Spacer(),
              Text(
                () {
                  final providerData = widget.providerData['serviceprovider'] ?? widget.providerData;
                  double rate = 750;
                  if (providerData != null) {
                    try {
                      var hourlyRate = providerData.hourlyRate;
                      if (hourlyRate != null) {
                        rate = hourlyRate is String ? double.tryParse(hourlyRate) ?? 750 : hourlyRate.toDouble();
                      }
                    } catch (e) {
                      // Fallback to Map access
                      if (providerData is Map) {
                        var hourlyRate = providerData['hourlyRate'];
                        if (hourlyRate != null) {
                          rate = hourlyRate is String ? double.tryParse(hourlyRate) ?? 750 : hourlyRate.toDouble();
                        }
                      }
                    }
                  }
                  return '₱${rate.toStringAsFixed(0)}';
                }(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E40AF),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Location
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                () {
                  // Try multiple data sources for address
                  String? addressDisplay;
                  
                  // Try 1: Check root level address
                  if (widget.providerData['address'] != null) {
                    final addr = widget.providerData['address'];
                    if (addr is String && addr.isNotEmpty) {
                      addressDisplay = addr;
                    } else if (addr is Map) {
                      final city = addr['city'] ?? '';
                      final barangay = addr['barangay'] ?? '';
                      if (city.isNotEmpty || barangay.isNotEmpty) {
                        addressDisplay = '$city, $barangay'.replaceAll(RegExp(r',\s*$'), '').trim();
                      }
                    }
                  }
                  
                  // Try 2: Check user object
                  if (addressDisplay == null) {
                    final data = widget.providerData['user'];
                    if (data != null) {
                      try {
                        final address = data.address;
                        if (address != null) {
                          try {
                            final city = address.city ?? '';
                            final barangay = address.barangay ?? '';
                            if (city.isNotEmpty || barangay.isNotEmpty) {
                              addressDisplay = '$city, $barangay'.replaceAll(RegExp(r',\s*$'), '').trim();
                            }
                          } catch (e) {
                            addressDisplay = address.toString();
                          }
                        }
                      } catch (e) {
                        // Fallback to Map access on user data
                        if (data is Map) {
                          final address = data['address'];
                          if (address is String && address.isNotEmpty) {
                            addressDisplay = address;
                          } else if (address is Map) {
                            final city = address['city'] ?? '';
                            final barangay = address['barangay'] ?? '';
                            if (city.isNotEmpty || barangay.isNotEmpty) {
                              addressDisplay = '$city, $barangay'.replaceAll(RegExp(r',\s*$'), '').trim();
                            }
                          }
                        }
                      }
                    }
                  }
                  
                  // Try 3: Check location field
                  if (addressDisplay == null && widget.providerData['location'] != null) {
                    final loc = widget.providerData['location'];
                    if (loc is String && loc.isNotEmpty) {
                      addressDisplay = loc;
                    } else if (loc is Map) {
                      final city = loc['city'] ?? '';
                      final barangay = loc['barangay'] ?? '';
                      if (city.isNotEmpty || barangay.isNotEmpty) {
                        addressDisplay = '$city, $barangay'.replaceAll(RegExp(r',\s*$'), '').trim();
                      }
                    }
                  }
                  
                  return addressDisplay ?? 'Location not specified';
                }(),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Rating
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 16),
              const SizedBox(width: 4),
              Text(
                '${_averageRating.toStringAsFixed(1)} ${_serviceproviderReviews.length} reviews',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Experience and Jobs Completed
          Row(
            children: [
              // Years of Experience
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.work_history,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Experience',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        () {
                          String experience = '0-1';
                          
                          // Try nested structure first
                          final nestedServiceProviderData = widget.providerData['serviceprovider'];
                          if (nestedServiceProviderData != null) {
                            try {
                              experience = nestedServiceProviderData.experienceYears?.toString() ?? nestedServiceProviderData.experience ?? '0-1';
                            } catch (e) {
                              if (nestedServiceProviderData is Map) {
                                experience = nestedServiceProviderData['experienceYears']?.toString() ?? nestedServiceProviderData['experience'] ?? '0-1';
                              }
                            }
                          } else {
                            // Try flat structure
                            experience = widget.providerData['experienceYears']?.toString() ?? widget.providerData['experience'] ?? '0-1';
                          }
                          return '$experience years';
                        }(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Jobs Completed
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Jobs Done',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _isLoadingJobsCount
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E40AF)),
                              ),
                            )
                          : Text(
                              _completedJobsCount.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    final hasMoreThanTwo = serviceproviderServices.length > 2;
    final servicesToShow = _showAllServices || !hasMoreThanTwo 
        ? serviceproviderServices 
        : serviceproviderServices.take(2).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: servicesToShow.isNotEmpty
                ? servicesToShow.map((service) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E40AF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF1E40AF).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.construction,
                            color: Color(0xFF1E40AF),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            service.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF1E40AF),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()
                : [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E40AF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF1E40AF).withOpacity(0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.construction,
                            color: Color(0xFF1E40AF),
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'GENERAL SERVICES',
                            style: TextStyle(
                              color: Color(0xFF1E40AF),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
          ),
          if (hasMoreThanTwo) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: Text(
                _showAllServices ? 'See Less' : 'See More (+${serviceproviderServices.length - 2} more)',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1E40AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (_serviceproviderReviews.isNotEmpty)
                GestureDetector(
                  onTap: _showAllReviews,
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1E40AF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (_serviceproviderReviews.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Center(
                child: Text(
                  'No reviews yet',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ..._serviceproviderReviews.take(3).map((review) => _buildReviewItem(review)),
          
          const SizedBox(height: 24),
          
          // Verified Portfolio Section
          _buildVerifiedPortfolio(),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    String? serviceproviderId = widget.providerData['id'] as String?;
    
    // Fallback to uid field
    if (serviceproviderId == null || serviceproviderId.isEmpty) {
      serviceproviderId = widget.providerData['uid'] as String?;
    }
    
    // Fallback to user.uid
    if ((serviceproviderId == null || serviceproviderId.isEmpty) && widget.providerData['user'] != null) {
      final data = widget.providerData['user'];
      serviceproviderId = data is Map ? data['uid'] as String? : null;
    }
    
    if ((serviceproviderId == null || serviceproviderId.isEmpty) && widget.providerData['serviceprovider'] != null) {
      final providerData = widget.providerData['serviceprovider'];
      serviceproviderId = providerData is Map ? providerData['uid'] as String? : null;
    }

    if (serviceproviderId == null || serviceproviderId.isEmpty) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Portfolio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          
          VerifiedPortfolioWidget(serviceproviderId: serviceproviderId),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRatingFilter(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (mounted) {});
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E40AF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E40AF) : Colors.grey[300]!,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1E40AF).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (text != 'All') ...[
              Icon(
                Icons.star,
                size: 14,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(Map review) {
    // Get reviewer photo URL - check multiple field names
    final reviewerPhotoURL = review['reviewerProfileUrl'] ?? 
                             review['reviewerPhotoURL'] ?? 
                             review['reviewerAvatar'] ?? 
                             review['photoURL'] ?? 
                             '';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserProfileAvatar(
            photoURL: reviewerPhotoURL,
            firstName: review['reviewerName'],
            fullName: review['reviewerName'],
            radius: 20,
            userRole: '/* payment_logic */',
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review['reviewerName'] ?? 'Robert Abalos',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _toggleReviewLike(
                            review['reviewerName'] ?? 'unknown',
                          ),
                          child: Icon(
                            _likedReviews.contains(
                                  review['reviewerName'] ?? 'unknown',
                                )
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 20,
                            color:
                                _likedReviews.contains(
                                  review['reviewerName'] ?? 'unknown',
                                )
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showReviewOptions(review),
                          child: Icon(
                            Icons.more_horiz,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      color: index < (review['rating'] ?? 5)
                          ? Colors.orange
                          : Colors.grey[300],
                      size: 16,
                    );
                  }),
                ),

                const SizedBox(height: 8),

                Text(
                  review['comment'] ??
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  review['date'] ?? 'Jul 20 2025',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Message Button
          Expanded(
            child: Button(
              onPressed: _isStartingChat ? null : _startOrContinueChat,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: const BorderSide(color: Color(0xFF1E40AF)),
                ),
              ),
              child: _isStartingChat
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Color(0xFF1E40AF),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Message',
                      style: TextStyle(
                        color: Color(0xFF1E40AF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 12),

          // Hire Button
          Expanded(
            child: Button(
              onPressed: _hireServiceProvider,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E40AF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Hire',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Methods

  void _hireServiceProvider() {
    Navigator.navigate() =>
            BookingDetailsScreen(providerData: widget.providerData),
      ),
    );
  }

  Future<void> _startOrContinueChat() async {
    setState(() => _isStartingChat = true);

    try {
      if (mounted) {}
        
        // Fallback to user.uid
        if ((serviceproviderId == null || serviceproviderId.isEmpty) && widget.providerData['user'] != null) {
          final data = widget.providerData['user'];
          if (data is Data) {
            serviceproviderId = data.uid;
          } else if (data is Map) {
            serviceproviderId = data['uid'] as String?;
          } else if (data != null) {
            try {
              serviceproviderId = (data as dynamic).uid as String?;
            } catch (e) {}
          }
        }
        
        if (serviceproviderId == null || serviceproviderId.isEmpty) {
          throw Exception('No serviceprovider ID found');
        }

        var data = widget.providerData['user'];
        String firstName = 'Unknown';
        String lastName = 'User';
        String? photoURL;
        String? role;
        
        if (data is Data) {
          firstName = data.firstName ?? 'Unknown';
          lastName = data.lastName ?? 'User';
          photoURL = data.photoURL;
          role = data.role;
        } else if (data is Map) {
          firstName = data['firstName'] ?? widget.providerData['firstName'] ?? 'Unknown';
          lastName = data['lastName'] ?? widget.providerData['lastName'] ?? 'User';
          photoURL = data['photoURL'] ?? widget.providerData['photoURL'];
          role = data['role'] ?? 'serviceprovider';
        } else {
          firstName = widget.providerData['firstName'] ?? 'Unknown';
          lastName = widget.providerData['lastName'] ?? 'User';
          photoURL = widget.providerData['photoURL'];
          role = 'serviceprovider';
        }
        
        final serviceproviderForChat = {
          'uid': serviceproviderId,
          'firstName': firstName,
          'lastName': lastName,
          'role': role ?? 'serviceprovider',
          'photoURL': photoURL,
          'isOnline': true, // Default to online for demo
        };
        
        // find existing conversation or create new one, similar to clicking on a 
        // conversation in the chat screen
        Navigator.navigate() => ChatScreen(
              data: widget.data,
              startChatWith: serviceproviderForChat, // This triggers direct conversation mode
            ),
          ),
        );

        // Show confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening conversation with $firstName...'),
            backgroundColor: const Color(0xFF1E40AF),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {}
    } finally {
      if (mounted) {}
    }
  }

  void _toggleFavorite() async {
    try {
      final serviceproviderId = _getServiceProviderId();
      if (serviceproviderId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Could not find serviceprovider ID'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Toggle the bookmark
      if (_isBookmarked) {
        if (mounted) {}
      } else {
        if (mounted) {}
      }
    } catch (e) {
      if (mounted) {}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Show options menu with report functionality
  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.flag, color: Colors.red),
              title: const Text('Report Data'),
              onTap: () {
                Navigator.navigate();
                _showReportDialog();
              },
            ),

            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Block Data'),
              onTap: () {
                Navigator.navigate();
                _showBlockDialog();
              },
            ),

            ListTile(
              leading: const Icon(Icons.share, color: Colors.blue),
              title: const Text('Share Profile'),
              onTap: () {
                Navigator.navigate();
                _shareProfile();
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Show report dialog
  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Why are you reporting this serviceprovider?'),
            const SizedBox(height: 16),

            ...[
                  'Inappropriate behavior',
                  'Spam or fake profile',
                  'Poor work quality',
                  'Safety concerns',
                  'Other',
                ]
                .map(
                  (reason) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(reason),
                    leading: Radio<String>(
                      value: reason,
                      groupValue: null,
                      onChanged: (value) {
                        Navigator.navigate();
                        _submitReport(reason);
                      },
                    ),
                  ),
                )
                ,
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Show block dialog
  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block Data'),
        content: const Text(
          'Are you sure you want to block this serviceprovider? You won\'t see their profile or receive messages from them.',
        ),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Cancel'),
          ),
          Button(
            onPressed: () {
              Navigator.navigate();
              _blockServiceProvider();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  // Submit report
  void _submitReport(String reason) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report submitted: $reason'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _blockServiceProvider() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data has been blocked'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Share profile
  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile sharing functionality will be implemented'),
        backgroundColor: Color(0xFF1E40AF),
      ),
    );
  }

  // Show all reviews
  void _showAllReviews() {
    Navigator.navigate() => Scaffold(
          appBar: AppBar(
            title: const Text('All Reviews'),
            backgroundColor: const Color(0xFF1E40AF),
            foregroundColor: Colors.white,
          ),
          body: Column(
            children: [
              // Rating summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  children: [
                    Text(
                      _averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < _averageRating.floor()
                                    ? Icons.star
                                    : index < _averageRating
                                    ? Icons.star_half
                                    : Icons.star_border,
                                color: Colors.orange,
                                size: 24,
                              );
                            }),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_serviceproviderReviews.length} reviews',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Rating filters
              Container(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildRatingFilter('All', _selectedRatingFilter == 'All'),
                      const SizedBox(width: 8),
                      _buildRatingFilter('5', _selectedRatingFilter == '5'),
                      const SizedBox(width: 8),
                      _buildRatingFilter('4', _selectedRatingFilter == '4'),
                      const SizedBox(width: 8),
                      _buildRatingFilter('3', _selectedRatingFilter == '3'),
                      const SizedBox(width: 8),
                      _buildRatingFilter('2', _selectedRatingFilter == '2'),
                      const SizedBox(width: 8),
                      _buildRatingFilter('1', _selectedRatingFilter == '1'),
                    ],
                  ),
                ),
              ),

              // Reviews list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _getFilteredReviews().length,
                  itemBuilder: (context, index) {
                    return _buildReviewItem(_getFilteredReviews()[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Get filtered reviews based on selected rating
  List<Map> _getFilteredReviews() {
    if (_selectedRatingFilter == 'All') {
      return _serviceproviderReviews;
    }

    try {
      int targetRating = int.parse(_selectedRatingFilter);
      return _serviceproviderReviews/* .where removed */((review) {
        return (review['rating'] ?? 5) == targetRating;
      }).toList();
    } catch (e) {
      return _serviceproviderReviews;
    }
  }

  // Toggle review like
  void _toggleReviewLike(String reviewerId) {
    setState(() {
      if (_likedReviews.contains(reviewerId)) {
        _likedReviews.remove(reviewerId);
      } else {
        _likedReviews.add(reviewerId);
      }
    });
  }

  // Show review options
  void _showReviewOptions(Map review) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.flag, color: Colors.red),
              title: const Text('Report Review'),
              onTap: () {
                Navigator.navigate();
                _reportReview(review);
              },
            ),

            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Review'),
              onTap: () {
                Navigator.navigate();
                _copyReview(review);
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Report review
  void _reportReview(Map review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Review'),
        content: const Text('Are you sure you want to report this review?'),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Cancel'),
          ),
          Button(
            onPressed: () {
              Navigator.navigate();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Review has been reported'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Report', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Copy review
  void _copyReview(Map review) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Review copied to clipboard'),
        backgroundColor: Color(0xFF1E40AF),
      ),
    );
  }
}

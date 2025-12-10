class SearchScreen extends StatefulWidget {
  final Map? data;

  const SearchScreen({super.key, this.data});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showResults = false;
  bool _isSearching = false;
  String _searchQuery = '';
  List<Map> _searchResults = [];
  final Set<String> _favoriteServiceProviders = {};
  List<String> _recentSearches = []; // Will load from SharedPreferences
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  // Filter variables
  List<String> _selectedCategories = []; // Multiple selection support
  String _selectedSort = 'Recommended'; // Sort option
  final TextEditingController _minPriceController = TextEditingController(
    text: '0',
  );
  final TextEditingController _maxPriceController = TextEditingController(
    text: '500',
  );

  // Sort options
  final List<String> _sortOptions = [
    'Recommended',
    'Price: Low to High',
    'Price: High to Low',
    'Rating: High to Low',
    'Most Reviews',
    'Most Jobs Completed',
  ];
  bool _showAllCategories = false;

  List<String> get _allCategories => ['All'] + ServicesConfig.categoryNames;

  /// Load search history from SharedPreferences
  Future<void> _loadSearchHistory() async {
    try {
      if (mounted) {});
      }
    } catch (e) {
      if (mounted) {});
      }
    }
  }

  /// Perform search with query and save to history
  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      // If no query but categories are selected, search by categories only
      if (_selectedCategories.isNotEmpty) {
        return;
      }
      _clearSearch();
      return;
    }

    // Special handling for filter-only searches
    final queryLower = query.toLowerCase();
    final isFilterOnlySearch = query == 'All serviceproviders' || 
                                _allCategories.contains(query) ||
                                _allCategories.contains(queryLower);
    
    if (isFilterOnlySearch) {
      return;
    }

    // Save to search history (only for real text searches)

    setState(() {});

    try {
      print('📍 Filters - Categories: ${_selectedCategories.join(", ")}, Price: ₱${_minPriceController.text}-₱${_maxPriceController.text}');
      
      // Build search parameters
      List<String>? services;
      if (_selectedCategories.isNotEmpty) {
        services = _selectedCategories;
      }

      double? minRate;
      double? maxRate;
      if (_minPriceController.text.isNotEmpty) {
        minRate = double.tryParse(_minPriceController.text);
      }
      if (_maxPriceController.text.isNotEmpty) {
        maxRate = double.tryParse(_maxPriceController.text);
      }

      // Validate price range
      if (minRate != null && maxRate != null && minRate > maxRate) {
        // Swap values if min > max
        final temp = minRate;
        minRate = maxRate;
        maxRate = temp;
        _minPriceController.text = minRate.toString();
        _maxPriceController.text = maxRate.toString();
      }

        services: services,
        location: null, // Location filter removed
        maxRate: maxRate,
        limit: 50, // Higher limit for search results
      );

      final filteredByMinRate = minRate != null 
          ? providerData/* .where removed */((entry) => (entry['serviceprovider'].hourlyRate ?? 0.0) >= minRate!).toList()
          : providerData;

      final filteredResults = filteredByMinRate/* .where removed */((serviceproviderEntry) {
        final user = serviceproviderEntry['user'];
        final serviceprovider = serviceproviderEntry['serviceprovider'];
        
        final searchText = query.toLowerCase();
        final firstName = (user.firstName ?? '').toLowerCase();
        final lastName = (user.lastName ?? '').toLowerCase();
        final fullName = '$firstName $lastName'.toLowerCase();
        final description = (serviceprovider.description ?? '').toLowerCase();
        final services = (serviceprovider.services ?? []).join(' ').toLowerCase();
        final skills = (serviceprovider.skills ?? []).join(' ').toLowerCase();
        
        bool serviceMatches = services.contains(searchText) || skills.contains(searchText);
        
        if (!serviceMatches) {
          for (final serviceName in (serviceprovider.services ?? [])) {
            final category = ServicesConfig/* .get removed */Category(serviceName);
            if (category != null) {
              // Check main category name
              if (category.name.toLowerCase().contains(searchText)) {
                serviceMatches = true;
                break;
              }
              // Check subcategories
              for (final subcat in category.subcategories) {
                if (subcat.toLowerCase().contains(searchText)) {
                  serviceMatches = true;
                  break;
                }
              }
              if (serviceMatches) break;
            }
          }
        }
        
        return fullName.contains(searchText) ||
               description.contains(searchText) ||
               serviceMatches;
      }).toList();

      // Transform to display format
      final List<Map> searchResults = [];
      for (var serviceproviderEntry in filteredResults) {
        final user = serviceproviderEntry['user'];
        final serviceprovider = serviceproviderEntry['serviceprovider'];

        final String firstName = user.firstName ?? 'Unknown';
        final String lastName = user.lastName ?? 'User';
        final double hourlyRate = serviceprovider.hourlyRate ?? 500.0;
        
        String location = 'Philippines';
        if (user.address != null) {
          if (user.address!.city.isNotEmpty) {
            location = user.address!.city;
            if (user.address!.barangay.isNotEmpty) {
              location = '${user.address!.barangay}, ${user.address!.city}';
            }
          }
        }
        
        searchResults.add({
          // Display fields for search results
          'id': user.uid,
          'name': '$firstName $lastName'.trim(),
          'profession': serviceprovider.services?.isNotEmpty == true ? serviceprovider.services!.first : 'General Services',
          'location': location,
          'price': '₱${hourlyRate.toStringAsFixed(0)}',
          'rating': serviceprovider.rating ?? 0.0,
          'reviews': serviceprovider.totalReviews ?? 0,
          'profileImageUrl': user.photoURL,
          'isAvailable': serviceprovider.isAvailable ?? false,
          'skills': serviceprovider.services ?? [],
          'bio': serviceprovider.description ?? '',
          'uid': user.uid,
          'firstName': firstName,
          
          // Pass complete nested structure for profile screen
          'user': user,    // Full Data
          'serviceprovider': serviceprovider,  // Full ServiceProviderModel
          'lastName': lastName,
          'role': user.role ?? 'serviceprovider',
          'hourlyRate': hourlyRate,
          'experienceYears': serviceprovider.experience ?? '1',
          'address': location,
          'completedJobs': serviceprovider.totalJobs ?? 0,
        });
      }

      // Apply sorting
      _applySorting(searchResults);

      if (mounted) {});
      }
    } catch (e) {
      if (mounted) {});
      }
    }
  }

  /// Apply sorting to search results based on selected sort option
  void _applySorting(List<Map> results) {
    switch (_selectedSort) {
      case 'Price: Low to High':
        results.sort((a, b) {
          final aRate = a['hourlyRate'] ?? 0.0;
          final bRate = b['hourlyRate'] ?? 0.0;
          return aRate.compareTo(bRate);
        });
        break;
      
      case 'Price: High to Low':
        results.sort((a, b) {
          final aRate = a['hourlyRate'] ?? 0.0;
          final bRate = b['hourlyRate'] ?? 0.0;
          return bRate.compareTo(aRate);
        });
        break;
      
      case 'Rating: High to Low':
        results.sort((a, b) {
          final aRating = a['rating'] ?? 0.0;
          final bRating = b['rating'] ?? 0.0;
          if (aRating == bRating) {
            // If ratings are equal, sort by number of reviews
            final aReviews = a['reviews'] ?? 0;
            final bReviews = b['reviews'] ?? 0;
            return bReviews.compareTo(aReviews);
          }
          return bRating.compareTo(aRating);
        });
        break;
      
      case 'Most Reviews':
        results.sort((a, b) {
          final aReviews = a['reviews'] ?? 0;
          final bReviews = b['reviews'] ?? 0;
          return bReviews.compareTo(aReviews);
        });
        break;
      
      case 'Most Jobs Completed':
        results.sort((a, b) {
          final aJobs = a['completedJobs'] ?? 0;
          final bJobs = b['completedJobs'] ?? 0;
          return bJobs.compareTo(aJobs);
        });
        break;
      
      case 'Recommended':
      default:
        // Recommended: Balanced algorithm
        // Priority: Available > High Rating > Many Reviews > Low Price
        results.sort((a, b) {
          final aAvailable = a['isAvailable'] ?? false;
          final bAvailable = b['isAvailable'] ?? false;
          if (aAvailable != bAvailable) {
            return bAvailable ? 1 : -1;
          }
          
          // 2. Calculate quality score (rating * log(reviews + 1))
          final aRating = a['rating'] ?? 0.0;
          final bRating = b['rating'] ?? 0.0;
          final aReviews = a['reviews'] ?? 0;
          final bReviews = b['reviews'] ?? 0;
          
          final aScore = aRating * (1 + (aReviews / 10).clamp(0, 5));
          final bScore = bRating * (1 + (bReviews / 10).clamp(0, 5));
          
          if ((aScore - bScore).abs() > 0.5) {
            return bScore.compareTo(aScore);
          }
          
          // 3. If scores are similar, prefer lower price
          final aRate = a['hourlyRate'] ?? 999.0;
          final bRate = b['hourlyRate'] ?? 999.0;
          return aRate.compareTo(bRate);
        });
        break;
    }
  }

  /// Perform search using filters only (no text query required)
  Future<void> _performFilterSearch() async {
    // Don't save to history for filter-only searches
    setState(() {
      // Build display text for selected categories
      String displayText;
      if (_selectedCategories.isEmpty) {
        displayText = 'All serviceproviders';
      } else if (_selectedCategories.length == 1) {
        final cat = _selectedCategories.first;
        displayText = cat[0].toUpperCase() + cat.substring(1);
      } else {
        // Multiple categories: "Plumbing, Electrical, +2 more"
        final firstTwo = _selectedCategories.take(2).map((cat) => 
          cat[0].toUpperCase() + cat.substring(1)
        ).join(', ');
        if (_selectedCategories.length > 2) {
          displayText = '$firstTwo, +${_selectedCategories.length - 2} more';
        } else {
          displayText = firstTwo;
        }
      }
      _searchQuery = displayText;
      _showResults = true;
      _isSearching = true;
    });

    try {
      print('📍 Categories: ${_selectedCategories.join(", ")}, Price: ₱${_minPriceController.text}-₱${_maxPriceController.text}');
      
      // Build search parameters
      List<String>? services;
      if (_selectedCategories.isNotEmpty) {
        services = _selectedCategories;
      }

      double? minRate;
      double? maxRate;
      if (_minPriceController.text.isNotEmpty) {
        minRate = double.tryParse(_minPriceController.text);
      }
      if (_maxPriceController.text.isNotEmpty) {
        maxRate = double.tryParse(_maxPriceController.text);
      }

      // Validate price range
      if (minRate != null && maxRate != null && minRate > maxRate) {
        final temp = minRate;
        minRate = maxRate;
        maxRate = temp;
        _minPriceController.text = minRate.toString();
        _maxPriceController.text = maxRate.toString();
      }

        services: services,
        location: null,
        maxRate: maxRate,
        limit: 50,
      );

      // Apply additional client-side filtering for min rate
      final filteredByMinRate = minRate != null 
          ? providerData/* .where removed */((entry) => (entry['serviceprovider'].hourlyRate ?? 0.0) >= minRate!).toList()
          : providerData;

      // Filter-only search - use all results that match selected categories
      final List<Map> searchResults = [];
      for (var serviceproviderEntry in filteredByMinRate) {
        final user = serviceproviderEntry['user'];
        final serviceprovider = serviceproviderEntry['serviceprovider'];

        final String firstName = user.firstName ?? 'Unknown';
        final String lastName = user.lastName ?? 'User';
        final double hourlyRate = serviceprovider.hourlyRate ?? 500.0;
        
        String location = 'Philippines';
        if (user.address != null) {
          if (user.address!.city.isNotEmpty) {
            location = user.address!.city;
            if (user.address!.barangay.isNotEmpty) {
              location = '${user.address!.barangay}, ${user.address!.city}';
            }
          }
        }
        
        searchResults.add({
          'id': user.uid,
          'name': '$firstName $lastName'.trim(),
          'profession': serviceprovider.services?.isNotEmpty == true ? serviceprovider.services!.first : 'General Services',
          'location': location,
          'price': '₱${hourlyRate.toStringAsFixed(0)}',
          'rating': serviceprovider.rating ?? 0.0,
          'reviews': serviceprovider.totalReviews ?? 0,
          'profileImageUrl': user.photoURL,
          'isAvailable': serviceprovider.isAvailable ?? false,
          'skills': serviceprovider.services ?? [],
          'bio': serviceprovider.description ?? '',
          'uid': user.uid,
          'firstName': firstName,
          'user': user,
          'serviceprovider': serviceprovider,
          'lastName': lastName,
          'role': user.role ?? 'serviceprovider',
          'hourlyRate': hourlyRate,
          'experienceYears': serviceprovider.experience ?? '1',
          'address': location,
          'completedJobs': serviceprovider.totalJobs ?? 0,
        });
      }

      // Apply sorting
      _applySorting(searchResults);

      if (mounted) {});
      }
    } catch (e) {
      if (mounted) {});
      }
    }
  }

  void _clearSearch() {
    setState(() {});
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterModal(),
    );
  }

  Widget _buildWidget() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Filter content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sorted by',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Button(
                                onPressed: () {
                                  setModalState(() {
                                    _selectedCategories.clear();
                                    _selectedSort = 'Recommended';
                                    _minPriceController.text = '0';
                                    _maxPriceController.text = '500';
                                    _showAllCategories = false;
                                  });
                                  // Don't close modal - let user see the reset happen!
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF1E40AF),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(color: Color(0xFF1E40AF)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Button(
                                onPressed: () async {
                                  // Close modal
                                  Navigator.navigate();
                                  
                                  // Check if user has typed actual search text (not from previous filter search)
                                  final hasRealSearchText = _searchController.text.isNotEmpty &&
                                      _searchController.text != _searchQuery;
                                  
                                  if (hasRealSearchText) {
                                    // User typed something new - perform text search with filters
                                  } else {
                                    // Filter-only search (no new text typed)
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E40AF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'Apply',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Sort options
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _sortOptions.map((sortOption) {
                          return ChoiceChip(
                            label: Text(sortOption),
                            selected: _selectedSort == sortOption,
                            onSelected: (selected) {
                              setModalState(() {
                                _selectedSort = sortOption;
                              });
                            },
                            selectedColor: const Color(0xFF1E40AF),
                            labelStyle: TextStyle(
                              color: _selectedSort == sortOption
                                  ? Colors.white
                                  : Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            backgroundColor: Colors.grey[100],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Category section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Category',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              if (_selectedCategories.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E40AF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${_selectedCategories.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Button(
                            onPressed: () {
                              setModalState(() {
                                _showAllCategories = !_showAllCategories;
                              });
                            },
                            child: Text(
                              _showAllCategories ? 'View less' : 'View more',
                              style: const TextStyle(color: Color(0xFF1E40AF)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            (_showAllCategories
                                    ? _allCategories
                                    : _allCategories.take(6).toList())
                                .map((category) {
                                  // Capitalize first letter for display
                                  final displayName = category == 'All' 
                                      ? category 
                                      : category[0].toUpperCase() + category.substring(1);
                                  
                                  final isSelected = category == 'All' 
                                      ? _selectedCategories.isEmpty 
                                      : _selectedCategories.contains(category);
                                  
                                  return FilterChip(
                                    label: Text(displayName),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setModalState(() {
                                        if (category == 'All') {
                                          // Clicking "All" clears all selections
                                          _selectedCategories.clear();
                                        } else {
                                          if (selected) {
                                            // Add to selection
                                            _selectedCategories.add(category);
                                          } else {
                                            // Remove from selection
                                            _selectedCategories.remove(category);
                                          }
                                        }
                                      });
                                    },
                                    selectedColor: const Color(0xFF1E40AF),
                                    checkmarkColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  );
                                })
                                .toList(),
                      ),

                      const SizedBox(height: 24),

                      // Price Range section
                      const Text(
                        'Price Range',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // MIN input field
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'MIN',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    controller: _minPriceController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: '0',
                                      prefixText: '₱ ',
                                      prefixStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 16,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setModalState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Dash separator
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              '—',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          // MAX input field
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'MAX',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    controller: _maxPriceController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: '500',
                                      prefixText: '₱ ',
                                      prefixStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 16,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setModalState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Add bottom padding to prevent overflow
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: _performSearch,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[600]),
                          onPressed: _clearSearch,
                        )
                      : GestureDetector(
                          onTap: _showFilterModal,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E40AF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onChanged: (value) {
                  // Only update UI to show/hide clear button
                  setState(() {});
                },
              ),
            ),
          ),

          // Content
          Expanded(
            child: _showResults
                ? _buildSearchResults()
                : _buildRecentSearches(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildWidget() {
    if (_isLoadingHistory) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_recentSearches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No recent searches',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start searching for serviceproviders',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Button(
                onPressed: () async {
                  if (mounted) {}
                },
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Color(0xFF1E40AF), fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recent searches list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentSearches.length,
                  itemBuilder: (context, index) {
                    final search = _recentSearches[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.history,
                        color: Colors.grey,
                      ),
                      title: Text(
                        search,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        onPressed: () async {
                        },
                      ),
                      onTap: () {
                        _searchController.text = search;
                        _performSearch(search);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    if (_searchResults.isEmpty) {
      return _buildNoResults();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Results for "$_searchQuery"',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                '${_searchResults.length} Found',
                style: const TextStyle(fontSize: 14, color: Color(0xFF1E40AF)),
              ),
            ],
          ),
          // Sort indicator chip
          if (_selectedSort != 'Recommended')
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E40AF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF1E40AF).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sort,
                          size: 14,
                          color: Color(0xFF1E40AF),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _selectedSort,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1E40AF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Expanded(
            child: _isSearching
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final serviceprovider = _searchResults[index];
                      return _buildServiceProviderContainer(serviceprovider);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Magnifying glass icon
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/search.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Not Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Sorry, the keyword you entered cannot be found, please check again or search with another keyword.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
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
        selectedItemColor: const Color(0xFF1E40AF),
        unselectedItemColor: Colors.grey[600],
        currentIndex: 1, // Search tab is selected
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigate to home screen
              Navigator.navigate() =>
                      Screen(data: widget.data),
                ),
              );
              break;
            case 1:
              // Already on search screen
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

  Widget _buildServiceProviderContainer(Map serviceprovider) {
    final bool isFavorite = _favoriteServiceProviders.contains(serviceprovider['id']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.navigate() => ServiceProviderProfileScreen(
                  providerData: serviceprovider,
                  data: widget.data,
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
                // Profile Image
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: serviceprovider['profileImageUrl'] != null && serviceprovider['profileImageUrl'].isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            serviceprovider['profileImageUrl'],
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                              _buildInitialsAvatar(serviceprovider['name'] ?? 'U'),
                          ),
                        )
                      : _buildInitialsAvatar(serviceprovider['name'] ?? 'U'),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceprovider['name'] ?? 'Unknown User',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        serviceprovider['profession'] ?? 'General Services',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        serviceprovider['price'] ?? '₱500',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E40AF),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              serviceprovider['location'] ?? 'Philippines',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${(serviceprovider['rating'] ?? 0.0).toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '| ${serviceprovider['reviews'] ?? 0} reviews',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Bookmark/Favorite Icon
                GestureDetector(
                  onTap: () => _toggleFavorite(serviceprovider['id']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isFavorite
                          ? const Color(0xFF1E40AF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isFavorite
                          ? null
                          : Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: Icon(
                      Icons.bookmark,
                      color: isFavorite ? Colors.white : Colors.grey[400],
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(String name) {
    final initials = name.isNotEmpty 
        ? name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join().toUpperCase()
        : 'U';
    
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF1E40AF),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _toggleFavorite(String serviceproviderId) {
    setState(() {
      if (_favoriteServiceProviders.contains(serviceproviderId)) {
        _favoriteServiceProviders.remove(serviceproviderId);
      } else {
        _favoriteServiceProviders.add(serviceproviderId);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }
}

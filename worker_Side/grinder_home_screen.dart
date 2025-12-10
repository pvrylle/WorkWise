class Screen extends StatefulWidget {
  final Map? data;
  final int? initialTabIndex; // Main tab index (0=Dashboard, 1=Jobs, 2=Messages, 3=Profile)
  final int? initialJobTabIndex; // Sub-tab index within Jobs tab (0=Special Requests, 1=My Applications, 2=Active Jobs, 3=Job History)

  const Screen({
    super.key, 
    this.data,
    this.initialTabIndex,
    this.initialJobTabIndex,
  });

  @override
  State<Screen> createState() => _ServiceProviderHomeScreenState();
}

class _ServiceProviderHomeScreenState extends State<Screen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  Map? _providerData;
  bool _isLoading = true;
  TabController? _jobTabController;
  
  // Stream subscriptions to cancel on dispose
  StreamSubscription<List<Map>>? _bookingsSubscription;
  
  bool _isEditingPersonalInfo = false;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  
  final // Image utility removed _imagePicker = // Image utility removed();
  final PhotoUploadService _photoService = PhotoUploadService();
  List<Map> _activeJobs = [];
  List<Map> _pendingRequests = [];
  List<Map> _completedJobs = [];
  Map _performanceMetrics = {};
  List<Map> _specialRequests = [];
  List<Map> _conversations = [];
  int _unreadMessageCount = 0;

  StreamSubscription<User?>? _authStateSubscription;
  
  @override
  void initState() {
    super.initState();
    
    // Set initial tab index if provided
    if (widget.initialTabIndex != null) {
      _currentIndex = widget.initialTabIndex!;
    }
    
    // Initialize job tab controller with initial index
    _jobTabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialJobTabIndex ?? 0,
    );
    
    // Add listener to load special requests when switching job tabs
    _jobTabController?.addListener(() {
      if (_jobTabController?.indexIsChanging ?? false) {
        print('🔄 Job tab changed to: ${_jobTabController?.index}');
        // Force reload special requests when Special Requests tab (index 0) is selected
        if (_jobTabController?.index == 0) {
          _loadSpecialRequestsOnly();
        }
      }
    });
    
    _authStateSubscription = /* FirebaseAuth removed *//* .instance removed */.authStateChanges().listen((user) {
      if (!mounted) return;
      
      if (user == null) {
        print('🔄 User signed out - cleaning up streams and navigating to login');
        // Cancel all subscriptions immediately
        _bookingsSubscription?.cancel();
        _bookingsSubscription = null;
        
        // Navigate to login screen
        // Post-frame callback((_) {
          if (mounted) {}
        });
      }
    });
    
    // Load interstitial ad for job completion
    _loadInterstitialAd();
    
    // Load critical data first, defer non-critical data
    _loadCriticalDataOnly();
    _setupRealTimeUpdates();
    // Load non-critical data ONLY when user navigates to those tabs
  }

  @override
  void dispose() {
    // Cancel all stream subscriptions to prevent permission denied warnings during sign-out
    _bookingsSubscription?.cancel();
    _authStateSubscription?.cancel();
    
    // Dispose text controllers
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    
    // Dispose tab controller
    _jobTabController?.dispose();
    
    super.dispose();
  }

  // Set up optimized real-time updates for dashboard data
  void _setupRealTimeUpdates() {
    final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
    if (user == null) return;

    // Cancel previous /* payment_logic */ if exists
    _bookingsSubscription?.cancel();

    _bookingsSubscription = Service.streamServiceProviderBookings(user.uid).listen(
      (bookings) {
        if (!mounted) return;
        
        // Include both 'active' and 'for_client_review' (payment pending) jobs in Active Jobs
        final activeJobs = bookings/* .where removed */((b) => 
          b['status'] == 'active' || b['status'] == 'for_client_review'
        ).toList();
        final pendingRequests = bookings/* .where removed */((b) => b['status'] == 'pending').toList();
        
        if (activeJobs.length != _activeJobs.length || 
            pendingRequests.length != _pendingRequests.length) {
          PerformanceHelper.logInfo('Data update: ${activeJobs.length} active, ${pendingRequests.length} pending');
          setState(() {});
        }
      },
      onError: (error) {
        PerformanceHelper.logWarning('Error in booking stream: $error');
      },
    );
  }

  // Load only critical data for initial display (profile + metrics)
  Future<void> _loadCriticalDataOnly() async {
    if (!mounted) return;
    
    try {
      final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (user == null) {
        PerformanceHelper.logError('No authenticated user found');
        if (mounted) {}
        return;
      }

      PerformanceHelper.logInfo('📊 Loading critical data for serviceprovider: ${user.uid}');
      
      // Load ONLY profile and metrics (2 queries instead of 9)
        ServiceProviderService/* .get removed */ServiceProviderProfile(user.uid).catchError((e) {
          PerformanceHelper.logWarning('Error loading profile: $e');
          return <String, dynamic>{};
        }),
        ServiceProviderService/* .get removed */PerformanceMetrics(user.uid).catchError((e) {
          PerformanceHelper.logWarning('Error loading metrics: $e');
          return <String, dynamic>{};
        }),
      ]);
      
      if (mounted) {};
          _isLoading = false;
        });
      }

      PerformanceHelper.logSuccess('✅ Critical data loaded');

    } catch (e, stackTrace) {
      PerformanceHelper.logError('Error loading critical data: $e', e, stackTrace);
      if (mounted) {}
    }
  }

  // Load tab-specific data on-demand (lazy loading for smooth tab switching)
  Future<void> _loadTabData(int tabIndex) async {
    print('🔄 _loadTabData() called for tab index: $tabIndex');
    if (!mounted) return;
    
    final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
    if (user == null) {
      print('❌ _loadTabData() No user found');
      return;
    }

    print('👤 _loadTabData() user: ${user.uid}');
    try {
      switch (tabIndex) {
        case 1: // Messages tab
          if (_conversations.isEmpty) {
            PerformanceHelper.logInfo('⏳ Loading conversations for tab');
              PerformanceHelper.logWarning('Error loading conversations: $e');
              return <Map>[];
            });
            if (mounted) {}
          }
          break;
        case 2: // Jobs tab
          // ALWAYS reload special requests to ensure fresh data
          PerformanceHelper.logInfo('⏳ Loading jobs for tab');
            Service/* .get removed */ServiceProviderActiveJobs(user.uid).catchError((e) {
              return <Map>[];
            }),
            Service/* .get removed */ServiceProviderPendingRequests(user.uid).catchError((e) {
              return <Map>[];
            }),
            Service/* .get removed */ServiceProviderCompletedJobs(user.uid).catchError((e) {
              return <Map>[];
            }),
            ServiceProviderService/* .get removed */SpecialRequests(user.uid).catchError((e) {
              return <Map>[];
            }),
          ]);
          if (mounted) {});
          }
          break;
        case 3: // Profile tab
          if (_unreadMessageCount == 0 && _conversations.isEmpty) {
            PerformanceHelper.logInfo('⏳ Loading reviews for tab');
              return <String, dynamic>{'averageRating': 0.0, 'totalReviews': 0};
            });
            if (mounted) {}
          }
          break;
      }
    } catch (e) {
      PerformanceHelper.logWarning('Error loading tab data: $e');
    }
  }

  // Load only special requests when switching to Special Requests tab
  Future<void> _loadSpecialRequestsOnly() async {
    if (!mounted) return;
    
    final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
    if (user == null) return;

    try {
      print('🔄 _loadSpecialRequestsOnly() called for user: ${user.uid}');
        print('❌ ERROR loading special requests: $e');
        return <Map>[];
      });
      
      if (mounted) {} items');
        });
      }
    } catch (e) {
      PerformanceHelper.logWarning('Error loading special requests only: $e');
    }
  }

  /// Load interstitial ad for job completion
  void _loadInterstitialAd() {
    AdMobService.loadInterstitialAd(
      onAdLoaded: () {
        print('✅ Interstitial ad ready for job completion');
      },
      onAdFailedToLoad: (error) {
        print('❌ Failed to load interstitial ad for job completion: ${error.message}');
      },
      onAdDismissed: () {
        print('🔒 Job completion interstitial ad dismissed, reloading new ad');
        // Reload ad for next job completion
        _loadInterstitialAd();
      },
    );
  }

  Future<void> _loadAllData() async {
    print('🚀 _loadAllData() STARTED');
    if (!mounted) return;
    
    try {
      final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (user == null) {
        print('❌ _loadAllData() FAILED: No authenticated user');
        PerformanceHelper.logError('No authenticated user found');
        if (mounted) {}
        return;
      }

      print('👤 _loadAllData() for user: ${user.uid}');
      PerformanceHelper.logInfo('Starting optimized data load for serviceprovider: ${user.uid}');
      
      // Load data in parallel with individual error handling for graceful degradation
        ServiceProviderService/* .get removed */ServiceProviderProfile(user.uid).catchError((e) {
          PerformanceHelper.logWarning('Error loading profile: $e');
          return <String, dynamic>{};
        }),
        ServiceProviderService/* .get removed */PerformanceMetrics(user.uid).catchError((e) {
          PerformanceHelper.logWarning('Error loading metrics: $e');
          return <String, dynamic>{};
        }),
        Service/* .get removed */ServiceProviderActiveJobs(user.uid).catchError((e) {
          PerformanceHelper.logWarning('Error loading active jobs: $e');
          return <Map>[];
        }),
        Service/* .get removed */ServiceProviderPendingRequests(user.uid).catchError((e) {
          PerformanceHelper.logWarning('Error loading pending requests: $e');
          return <Map>[];
        }),
        Service/* .get removed */ServiceProviderCompletedJobs(user.uid).catchError((e) {
          PerformanceHelper.logWarning('Error loading completed jobs: $e');
          return <Map>[];
        }),
        ServiceProviderService/* .get removed */SpecialRequests(user.uid).then((requests) {
          print('✅ ServiceProviderService/* .get removed */SpecialRequests() completed: ${requests.length} requests');
          return requests;
        }).catchError((e) {
          print('❌ ERROR in ServiceProviderService/* .get removed */SpecialRequests(): $e');
          PerformanceHelper.logWarning('Error loading special requests: $e');
          return <Map>[];
        }),
        Service/* .get removed */UserConversations(user.uid).catchError((e) {
          PerformanceHelper.logWarning('Error loading conversations: $e');
          return <Map>[];
        }),
        Service/* .get removed */UnreadMessageCount(user.uid).catchError((e) {
          PerformanceHelper.logWarning('Error loading unread count: $e');
          return 0;
        }),
        _fetchServiceProviderReviews(user.uid) {
          // Implementation removed
        }
        }),
      ]);
      
      if (mounted) {} items');
          _conversations = results[6] as List<Map>;
          _unreadMessageCount = results[7] as int;
          final reviewsData = results[8] as Map;
          _performanceMetrics.addAll(reviewsData); // Add reviews data to performance metrics
          _isLoading = false;
        });
      }

      PerformanceHelper.logSuccess('Data loaded: ${_activeJobs.length} active, ${_pendingRequests.length} pending, ${_conversations.length} conversations');

    } catch (e, stackTrace) {
      PerformanceHelper.logError('Critical error loading serviceprovider data: $e', e, stackTrace);
      
      if (mounted) {},
            ),
          ),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E40AF)),
              ),
              const SizedBox(height: 16),
              Text(
                'Loading your dashboard...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Use SingleChildScrollView or PageView for lazy loading tabs
    // Only build the current tab to avoid performance issues
    Widget currentTab;
    switch (_currentIndex) {
      case 0:
        currentTab = _buildDashboardTab();
        break;
      case 1:
        currentTab = _buildJobsTab();
        break;
      case 2:
        currentTab = _buildMessagesTab();
        break;
      case 3:
        currentTab = _buildProfileTab();
        break;
      default:
        currentTab = _buildDashboardTab();
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: currentTab,
      ),
      floatingActionButton: _currentIndex == 2
          ? GeminiAIFloatingButton(data: widget.data)
          : null,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildWidget() {
    final firstName = _providerData?['user']?['firstName'] ?? 
                      _providerData?['firstName'] ?? 
                      'Data';
    final profession = _providerData?['serviceprovider']?['profession'] ?? 
                       _providerData?['profession'] ?? 
                       'Professional';

    return RefreshIndicator(
      onRefresh: () async {
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          Row(
            children: [
              UserProfileAvatar(
                photoURL: widget.data?['photoURL'],
                firstName: firstName,
                fullName: widget.data?['displayName'],
                userRole: 'serviceprovider',
                radius: 25,
                backgroundColor: const Color(0xFF1E45AD),
                textColor: Colors.white,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning, $firstName!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      profession.toString().toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const NotificationButton(),
            ],
          ),

          const SizedBox(height: 24),

          // Performance Overview Cards
          const Text(
            'Performance Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // First row - Active Jobs and Inquiries
          Row(
            children: [
              Expanded(
                child: _buildPerformanceContainer(
                  title: 'Active Jobs',
                  value: '${_activeJobs.length}',
                  icon: Icons.work_outline,
                  color: const Color(0xFF1E40AF),
                  subtitle: '${_pendingRequests.length} pending',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPerformanceContainer(
                  title: 'This Month Inquiries',
                  value: '${_performanceMetrics['thisMonthInquiries'] ?? 0}',
                  icon: Icons.chat_bubble_outline,
                  color: const Color(0xFF2196F3),
                  subtitle: '${_performanceMetrics['thisWeekInquiries'] ?? 0} this week',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Second row - Jobs Completed and Reviews
          Row(
            children: [
              Expanded(
                child: _buildPerformanceContainer(
                  title: 'Jobs Completed',
                  value: '${_performanceMetrics['completedJobs'] ?? 0}',
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFF4CAF50),
                  subtitle: 'All time',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPerformanceContainer(
                  title: 'Reviews',
                  value: '${_calculateAverageRating()}',
                  icon: Icons.star_outline,
                  color: const Color(0xFFFFC107),
                  subtitle: '${_performanceMetrics['totalReviews'] ?? 0} reviews',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // First row of actions
          Row(
            children: [
              Expanded(
                child: _buildQuickActionContainer(
                  title: 'Add Services',
                  icon: Icons.add_business_outlined,
                  color: const Color(0xFF4CAF50),
                  onTap: () {
                    Navigator.navigate() => const AddServicesScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionContainer(
                  title: 'Edit Profile',
                  icon: Icons.person_outline,
                  color: const Color(0xFF2196F3),
                  onTap: () {
                    // Navigate to Profile tab (index 3)
                    setState(() => _currentIndex = 3);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Second row of actions
          Row(
            children: [
              Expanded(
                child: _buildQuickActionContainer(
                  title: 'Upload Portfolio',
                  icon: Icons.upload_outlined,
                  color: const Color(0xFF8B5CF6),
                  onTap: () {
                    Navigator.navigate() => PortfolioCollapsibleScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionContainer(
                  title: 'View Messages',
                  icon: Icons.message_outlined,
                  color: const Color(0xFF1E40AF),
                  onTap: () {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),



          const SizedBox(height: 24),

          // Recent Job Requests
          const Text(
            'Recent Job Requests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          if (_pendingRequests.isEmpty)
            _buildEmptyState(
              icon: Icons.work_outline,
              title: 'No pending requests',
              subtitle: 'New job requests will appear here',
            )
          else
            ..._pendingRequests.map((request) => EnhancedServiceContainer(
              serviceData: request,
              cardType: 'request',
              onAccept: () => _acceptJobRequest(request),
              onDecline: () => _declineJobRequest(request),
              onInquire: () => _inquireAboutJob(request),
            )),
        ],
        ),
      ),
    );
  }

  Widget _buildWidget() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _jobTabController,
            labelColor: const Color(0xFF1E40AF),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF1E40AF),
            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            tabs: const [
              Tab(text: 'Special Requests'),
              Tab(text: 'My Applications'),
              Tab(text: 'Active Jobs'),
              Tab(text: 'Job History'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _jobTabController,
            children: [
              _buildSpecialRequestsList(),
              _buildMyApplicationsList(),
              _buildActiveJobsList(),
              _buildJobHistoryList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWidget() {
    final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
    if (user == null) {
      return const Center(child: Text('Please log in to view messages'));
    }

    return RefreshIndicator(
      onRefresh: () async {
      },
      child: StreamBuilder<List<Map>>(
        stream: Service.streamUserConversations(user.uid),
        builder: (context, conversationSnapshot) {
          if (conversationSnapshot.hasError) {
            final error = conversationSnapshot.error.toString();
            if (error.contains('permission-denied')) {
              final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
              if (currentUser == null) {
                // User signed out - show appropriate message
                return const Center(
                  child: Text('Please log in to view messages'),
                );
              }
            }
          }
          
          // Get conversations from stream
          final conversations = conversationSnapshot.data ?? _conversations;
          
          return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Messages',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Recent Messages List with real-time data
                    _buildRecentMessagesListStream(conversations),
                  ],
                ),
              );
        },
      ),
    );
  }

  Widget _buildWidget() {
    final photoURL = _providerData?['user']?['photoURL'] ?? _providerData?['photoURL'];
    final firstName = _providerData?['user']?['firstName'] ?? _providerData?['firstName'] ?? '';
    final lastName = _providerData?['user']?['lastName'] ?? _providerData?['lastName'] ?? '';
    final fullName = '$firstName $lastName'.trim();
    final profession = _providerData?['serviceprovider']?['profession'] ?? _providerData?['profession'] ?? 'Professional';
    final isEmailVerified = widget.data?['isEmailVerified'] ?? false;

    return RefreshIndicator(
      onRefresh: () async {
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Profile Header with Gradient Border
            Center(
              child: Stack(
                children: [
                  // Gradient Border with Glow
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF60A5FA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E40AF).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: photoURL != null && photoURL.isNotEmpty && photoURL != 'null' && photoURL != 'No image'
                            ? Image.network(
                                photoURL,
                                width: 122,
                                height: 122,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // If network image fails, show fallback
                                  return Image.asset(
                                    'assets/worker.png',
                                    width: 122,
                                    height: 122,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/worker.png',
                                width: 122,
                                height: 122,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  
                  // Verified Badge
                  if (isEmailVerified)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Name and Profession
            Center(
              child: Column(
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profession.toUpperCase(),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Account Section
            _buildProfileSectionHeader('Account'),
            const SizedBox(height: 12),
            
            _buildProfileMenuItem(
              icon: Icons.person_outline,
              title: 'Personal Information',
              subtitle: 'View and edit your profile',
              onTap: () {
                _showPersonalInfoModal();
              },
            ),

            _buildProfileMenuItem(
              icon: Icons.receipt_long_outlined,
              title: 'Payment History',
              subtitle: 'View your payment transactions',
              onTap: () {
                Navigator.navigate() => PaymentHistoryScreen(
                      data: _providerData,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            _buildProfileMenuItem(
              icon: Icons.money_outlined,
              title: 'Withdrawals',
              subtitle: 'Request and manage withdrawals',
              onTap: () {
                Navigator.navigate() => const WithdrawalScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // My Portfolio Section
            _buildProfileSectionHeader('My Portfolio'),
            const SizedBox(height: 12),
            
            _buildProfileMenuItem(
              icon: Icons.workspace_premium,
              title: 'My Portfolio',
              subtitle: 'View your uploaded documents & credentials',
              onTap: () {
                Navigator.navigate() => PortfolioCollapsibleScreen(
                      data: _providerData,
                      isViewOnly: true,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Support Section
            _buildProfileSectionHeader('Support'),
            const SizedBox(height: 12),
            
            _buildProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'Get help and FAQs',
              onTap: () => ProfileSectionRedesign.showHelpCenter(context),
            ),

            const SizedBox(height: 24),

            // About Section
            _buildProfileSectionHeader('About'),
            const SizedBox(height: 12),
            
            _buildProfileMenuItem(
              icon: Icons.info_outline,
              title: 'About AppName',
              subtitle: 'Learn more about our platform',
              onTap: () => ProfileSectionRedesign.showAbout(context),
            ),

            _buildProfileMenuItem(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Read our terms',
              onTap: () => ProfileSectionRedesign.showPrivacyPolicy(context),
            ),

            _buildProfileMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () => ProfileSectionRedesign.showPrivacyPolicy(context),
            ),

            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Button(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        Button(
                          onPressed: () => Navigator.navigate(),
                          child: const Text('Cancel'),
                        ),
                        Button(
                          onPressed: () async {
                            if (mounted) {}
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Profile Section Header (simple gray text)
  Widget _buildProfileSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Profile Menu Item (white /* payment_logic */ with icon, title, subtitle)
  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1E45AD).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF1E45AD), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Show Personal Info Modal (complete implementation from /* payment_logic */ side)
  void _showPersonalInfoModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return _buildPersonalInfoModal(setModalState);
        },
      ),
    );
  }

  Widget _buildPersonalInfoModal(StateSetter setModalState) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          
          // Header with Edit/Save/Cancel buttons
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1E40AF),
                  const Color(0xFF1E40AF).withOpacity(0.8),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage your personal details',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Edit/Save/Cancel buttons
                if (_isEditingPersonalInfo) ...[
                  // Cancel button
                  TextButton.icon(
                    onPressed: () {
                      setModalState(() {
                        _cancelEditingPersonalInfo();
                      });
                    },
                    icon: const Icon(Icons.close, color: Colors.white, size: 18),
                    label: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Save button
                  TextButton.icon(
                    onPressed: () async {
                      await _savePersonalInfo() {
                        // Implementation removed
                      }
                    },
                    icon: const Icon(Icons.check, color: Color(0xFF1E40AF), size: 18),
                    label: const Text(
                      'Save',
                      style: TextStyle(
                        color: Color(0xFF1E40AF),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ] else ...[
                  // Edit button
                  TextButton.icon(
                    onPressed: () {
                      setModalState(() {
                        _startEditingPersonalInfo();
                      });
                    },
                    icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                    label: const Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.navigate(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildPersonalInfoSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Avatar Section - Enhanced with better visuals
        Center(
          child: Stack(
            children: [
              // Gradient border with glow effect
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1E40AF),
                      const Color(0xFF3B82F6),
                      const Color(0xFF1E40AF).withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E40AF).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: (() {
                    final raw = widget.data?['photoURL'] as String?;
                    final t = raw?.trim();
                    final hasValid = t != null && t.isNotEmpty && t != 'null' && t != 'No image';
                    if (!hasValid) {
                      return SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/worker.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    return UserProfileAvatar(
                      photoURL: t,
                      firstName: widget.data?['firstName'],
                      lastName: widget.data?['lastName'],
                      fullName: widget.data?['displayName'],
                      userRole: 'serviceprovider',
                      radius: 50,
                      textColor: const Color(0xFF1E40AF),
                      fontSize: 32,
                    );
                  })(),
                ),
              ),
              // Edit photo button (only for email/password accounts in edit mode)
              if (_isEditingPersonalInfo && _isEmailPasswordAccount() {
                // Implementation removed
              }

  // Check if user is using email/password authentication
  bool _isEmailPasswordAccount()  {
    // Implementation removed
  }
    return false;
  }

  // Enhanced section label with icon
  Widget _buildEnhancedSectionLabel(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1E40AF).withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedInfoContainer({
    required IconData icon,
    required String label,
    required String value,
    required TextEditingController? controller,
    required bool isEditable,
    required Color iconColor,
    int maxLines = 1,
    String? hint,
    bool isVerified = false,
    bool showAge = false,
  }) {
    final displayValue = value.isEmpty ? 'Not set' : value;
    final isEmptyValue = value.isEmpty;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isEditingPersonalInfo && isEditable
              ? const Color(0xFF1E40AF).withOpacity(0.5)
              : Colors.grey[200]!,
          width: _isEditingPersonalInfo && isEditable ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _isEditingPersonalInfo && isEditable
                ? const Color(0xFF1E40AF).withOpacity(0.1)
                : Colors.black.withOpacity(0.03),
            blurRadius: _isEditingPersonalInfo && isEditable ? 12 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isEditable && _isEditingPersonalInfo && controller != null
              ? () {
                  // Focus the text field when /* payment_logic */ is tapped in edit mode
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: maxLines > 1 
                  ? CrossAxisAlignment.start 
                  : CrossAxisAlignment.center,
              children: [
                // Animated icon with gradient background
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        iconColor.withOpacity(0.15),
                        iconColor.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 22,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label with badge
                      Row(
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              letterSpacing: 0.3,
                            ),
                          ),
                          // Verified badge
                          if (isVerified) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    size: 10,
                                    color: Color(0xFF10B981),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    'Verified',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF10B981),
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Value or TextField
                      if (_isEditingPersonalInfo && isEditable && controller != null)
                        TextField(
                          controller: controller,
                          maxLines: maxLines,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            hintText: hint ?? 'Enter $label',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: iconColor,
                                width: 2,
                              ),
                            ),
                          ),
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                displayValue,
                                maxLines: maxLines,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isEmptyValue 
                                      ? Colors.grey[400] 
                                      : Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            // Show age if date of birth
                            if (showAge && !isEmptyValue && value.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${_calculateAge(value)} years',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFF59E0B),
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Status indicators
                if (!_isEditingPersonalInfo && isEditable)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  )
                else if (!isEditable)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Format phone number to Philippine format
  String _formatPhoneNumber(String phone) {
    if (phone.isEmpty) return phone;
    
    // Remove all non-digit characters
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    // If it starts with +63, format it nicely
    if (cleaned.startsWith('+63') && cleaned.length >= 12) {
      return '+63 ${cleaned.substring(3, 6)} ${cleaned.substring(6, 9)} ${cleaned.substring(9)}';
    }
    
    return phone;
  }

  // Format date of birth with age
  String _formatDateOfBirth(String date) {
    if (date.isEmpty) return date;
    // Return as is, age will be shown separately
    return date;
  }

  // Calculate age from date of birth
  int _calculateAge(String dateOfBirth)  {
    // Implementation removed
  }
  }

  String _getMemberSince() {
    final createdAt = widget.data?['createdAt'];
    if (createdAt == null) return 'N/A';
    
    try {
      DateTime date;
      if (createdAt is /* Timestamp removed */) {
        date = createdAt.toDate();
      } else if (createdAt is String) {
        date = DateTime.parse(createdAt);
      } else {
        return 'N/A';
      }
      
      // Format manually without intl package
      const months = ['January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  String _getSafeStringField(String field) {
    try {
      final value = widget.data?[field];
      
      if (value == null) return '';
      
      // Handle Map objects (like address/location stored as structured data)
      if (value is Map) {
        // Try to extract readable string from common map keys
        if (value.containsKey('address')) {
          return value['address']?.toString() ?? '';
        }
        if (value.containsKey('formatted_address')) {
          return value['formatted_address']?.toString() ?? '';
        }
        if (value.containsKey('description')) {
          return value['description']?.toString() ?? '';
        }
        if (value.containsKey('name')) {
          return value['name']?.toString() ?? '';
        }
        
        // If no known keys, return empty
        return '';
      }
      
      // Handle String values
      return value.toString();
    } catch (e) {
      return '';
    }
  }

  String _getFullName() {
    final firstName = _getSafeStringField('firstName');
    final lastName = _getSafeStringField('lastName');
    return '$firstName $lastName'.trim();
  }

  void _startEditingPersonalInfo() {
    setState(() {});
  }

  void _cancelEditingPersonalInfo() {
    setState(() {});
  }

  Future<void> _savePersonalInfo() async  {
    // Implementation removed
  }
  }

  void _showChangePasswordDialog()  {
    // Implementation removed
  }

  Widget _buildWidget()  {
    // Implementation removed
  }
    );
  }

  // Extract photo URL from various formats (Cloudinary object, Base64, or direct URL)
  String _extractPhotoUrl(dynamic photo) {
    // If photo is a Map (Cloudinary format: {url, publicId, timestamp, type})
    if (photo is Map) {
      if (photo['url'] != null) {
        return photo['url'].toString(); // Cloudinary URL
      } else if (photo['data'] != null) {
        return photo['data'].toString(); // Base64 data
      }
    }
    // If photo is a String (direct URL or Base64)
    if (photo is String) {
      return photo;
    }
    // Fallback: convert to string
    return photo.toString();
  }

  Widget _buildPhotoThumbnail(String photoPath, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 70,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              // Network call removed
                  ? Image.network(
                      photoPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, color: Colors.grey, size: 20),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    )
                  : photoPath.startsWith('data:image') || photoPath.length > 100
                      ? Image.memory(
                          base64Decode(photoPath.contains('base64,') 
                              ? photoPath.split('base64,')[1] 
                              : photoPath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image, color: Colors.grey, size: 20),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, color: Colors.grey, size: 20),
                        ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Enhanced Profile Option
  Widget _buildEnhancedProfileOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobRequestContainer(Map request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request['serviceType'] ?? 'Service Request',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                '₱ ${_formatCurrency((request['totalPrice'] ?? 0).toDouble())}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E45AD),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatLocation(request['location']),
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Button(
                  onPressed: () => _declineJobRequest(request),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Button(
                  onPressed: () => _acceptJobRequest(request),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E45AD),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionContainer({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color ?? const Color(0xFF1E45AD)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceContainer({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    print('🎨 Building Special Requests UI: ${_specialRequests.length} requests available');
    if (_specialRequests.isEmpty) {
      print('⚠️ Special Requests list is EMPTY - showing empty state');
      return _buildEmptyState(
        icon: Icons.search_off,
        title: 'No special requests',
        subtitle: 'Special job requests from customers will appear here',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _specialRequests.length,
        itemBuilder: (context, index) {
          final request = _specialRequests[index];
          return EnhancedServiceContainer(
            serviceData: request,
            cardType: 'special',
            onAccept: () => _acceptSpecialRequest(request),
            onInquire: () => _inquireAboutJob(request),
            onTap: () => _showRequestDetailsDialog(request),
          );
        },
      ),
    );
  }

  Widget _buildWidget() {
    final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
    if (user == null) {
      return _buildEmptyState(
        icon: Icons.person_off,
        title: 'Not logged in',
        subtitle: 'Please log in to view your job applications',
      );
    }

    return FutureBuilder<List<Map>>(
      future: ServiceProviderService/* .get removed */MyApplications(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildEmptyState(
            icon: Icons.error_outline,
            title: 'Error loading applications',
            subtitle: snapshot.error.toString(),
          );
        }

        final applications = snapshot.data ?? [];
        
        if (applications.isEmpty) {
          return _buildEmptyState(
            icon: Icons.inbox_outlined,
            title: 'No applications yet',
            subtitle: 'Jobs you apply for will appear here',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {}); // Trigger rebuild to fetch fresh data
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index];
              return _buildApplicationContainer(application);
            },
          ),
        );
      },
    );
  }

  Widget _buildApplicationContainer(Map application) {
    final status = application['status'] as String? ?? 'pending_approval';
    final statusDisplay = application['statusDisplay'] as String? ?? 'Pending';
    final statusColor = application['statusColor'] as String? ?? 'orange';
    
    // Enhanced status info with icons
    IconData getStatusIcon() {
      switch (status) {
        case 'pending_approval': return Icons.hourglass_empty_rounded;
        case 'accepted':
        case 'active': // Active job = accepted application
          return Icons.check_circle_rounded;
        case 'rejected': return Icons.cancel_rounded;
        case 'cancelled': return Icons.block_rounded;
        case 'completed': return Icons.verified_rounded;
        default: return Icons.help_outline_rounded;
      }
    }
    
    Color getStatusColor() {
      switch (statusColor) {
        case 'green': return const Color(0xFF22C55E);
        case 'red': return const Color(0xFFEF4444);
        case 'orange': return const Color(0xFFF97316);
        case 'blue': return const Color(0xFF3B82F6);
        case 'grey': return const Color(0xFF6B7280);
        default: return const Color(0xFFF97316);
      }
    }

    // Get budget
    final budgetValue = application['pricing'] != null && application['pricing']['totalPrice'] != null
        ? application['pricing']['totalPrice']
        : application['budget'];
    final double amount = budgetValue is num 
        ? budgetValue.toDouble() 
        : double.tryParse(budgetValue?.toString() ?? '0') ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main content
          InkWell(
            onTap: () => _showApplicationDetailsBottomSheet(application),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Status + Date
                  Row(
                    children: [
                      // Status chip with icon
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: getStatusColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              getStatusIcon(),
                              size: 14,
                              color: getStatusColor(),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              statusDisplay,
                              style: TextStyle(
                                color: getStatusColor(),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Date applied with icon
                      if (application['createdAt'] != null)
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 12, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              _formatApplicationDate(application['createdAt']),
                              style: TextStyle(color: Colors.grey[500], fontSize: 11),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  
                  // Job title
                  Text(
                    application['title'] ?? 'Untitled Job',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  
                  // Category badge (if available)
                  if (application['category'] != null || application['serviceType'] != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E40AF).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        (application['category'] ?? application['serviceType'] ?? '').toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E40AF),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  
                  // /* payment_logic */ info row
                  Row(
                    children: [
                      // Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: application['customerAvatar'] != null && application['customerAvatar'].toString().isNotEmpty
                              ? NetworkImage(application['customerAvatar'])
                              : null,
                          backgroundColor: const Color(0xFF1E45AD),
                          child: application['customerAvatar'] == null || application['customerAvatar'].toString().isEmpty
                              ? Text(
                                  (application['customerName'] ?? 'U')[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Name and location
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              application['customerName'] ?? 'Unknown Client',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (application['location'] != null) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 12, color: Colors.grey[500]),
                                  const SizedBox(width: 2),
                                  Expanded(
                                    child: Text(
                                      _formatLocation(application['location']),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[500],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Budget
                      if (amount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '₱ ${_formatCurrency(amount)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF22C55E),
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  // Duration info (if available)
                  if (application['pricing'] != null && application['pricing']['durationValue'] != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.schedule_outlined, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${application['pricing']['durationValue']} ${application['pricing']['durationUnit'] ?? 'hours'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (application['pricing']['rateType'] != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatRateType(application['pricing']['rateType']),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Action buttons based on status
          if (status == 'pending_approval') ...[
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // Withdraw button
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _showWithdrawConfirmation(application),
                      icon: Icon(Icons.undo_rounded, size: 16, color: Colors.grey[600]),
                      label: Text(
                        'Withdraw',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  Container(width: 1, height: 24, color: Colors.grey.shade200),
                  // View details button
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _showApplicationDetailsBottomSheet(application),
                      icon: const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF1E40AF)),
                      label: const Text(
                        'View Details',
                        style: TextStyle(
                          color: Color(0xFF1E40AF),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (status == 'accepted' || status == 'active') ...[
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withOpacity(0.05),
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 14, color: const Color(0xFF22C55E)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'You\'ve been accepted for this job!',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showApplicationDetailsBottomSheet(application),
                    icon: const Icon(Icons.visibility_outlined, size: 14, color: Color(0xFF22C55E)),
                    label: const Text(
                      'View Details',
                      style: TextStyle(
                        color: Color(0xFF22C55E),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (status == 'rejected') ...[
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.05),
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'This application was not accepted. Keep looking for other opportunities!',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Format rate type for display
  String _formatRateType(String? rateType) {
    switch (rateType) {
      case 'per_hour': return 'Per Hour';
      case 'per_day': return 'Per Day';
      case 'fixed_price': return 'Fixed Price';
      default: return rateType ?? '';
    }
  }

  /// Show withdraw application confirmation
  void _showWithdrawConfirmation(Map application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Withdraw Application?'),
          ],
        ),
        content: Text(
          'Are you sure you want to withdraw your application for "${application['title']}"?\n\nThis action cannot be undone.',
        ),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Cancel'),
          ),
          Button(
            onPressed: () async {
              Navigator.navigate();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  /// Withdraw application
  Future<void> _withdrawApplication(Map application) async {
    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text('Withdrawing application...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

          // Database operation removed
          // Database operation removed
          /* .update removed */({
        'status': 'cancelled',
        'interestedServiceProvider': /* FieldValue removed *//* .delete removed */(),
        'cancelledAt': /* FieldValue removed */.server/* Timestamp removed */(),
        'cancelReason': 'Withdrawn by serviceprovider',
      });

      // Refresh
      if (mounted) {});
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application withdrawn successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {}
    }
  }

  /// Show application details in bottom sheet (better UX than dialog)
  void _showApplicationDetailsBottomSheet(Map application) {
    final status = application['status'] as String? ?? 'pending_approval';
    final statusDisplay = application['statusDisplay'] as String? ?? 'Pending';
    
    Color getStatusColor() {
      switch (application['statusColor']) {
        case 'green': return const Color(0xFF22C55E);
        case 'red': return const Color(0xFFEF4444);
        case 'orange': return const Color(0xFFF97316);
        case 'blue': return const Color(0xFF3B82F6);
        case 'grey': return const Color(0xFF6B7280);
        default: return const Color(0xFFF97316);
      }
    }

    // Get budget
    final budgetValue = application['pricing'] != null && application['pricing']['totalPrice'] != null
        ? application['pricing']['totalPrice']
        : application['budget'];
    final double amount = budgetValue is num 
        ? budgetValue.toDouble() 
        : double.tryParse(budgetValue?.toString() ?? '0') ?? 0.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            status == 'pending_approval' ? Icons.hourglass_empty_rounded
                                : (status == 'accepted' || status == 'active') ? Icons.check_circle_rounded
                                : status == 'rejected' ? Icons.cancel_rounded
                                : Icons.help_outline_rounded,
                            color: getStatusColor(),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  statusDisplay,
                                  style: TextStyle(
                                    color: getStatusColor(),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  _getStatusExplanation(status),
                                  style: TextStyle(
                                    color: getStatusColor().withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Job title
                    Text(
                      application['title'] ?? 'Untitled Job',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Category
                    if (application['category'] != null || application['serviceType'] != null)
                      _buildDetailRow(
                        Icons.category_outlined,
                        'Category',
                        (application['category'] ?? application['serviceType'] ?? '').toString(),
                      ),
                    
                    // Description
                    if (application['description'] != null) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        application['description'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                          height: 1.5,
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 16),
                    
                    // Job details section
                    const Text(
                      'JOB DETAILS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Budget
                    if (amount > 0)
                      _buildDetailRow(
                        Icons.payments_outlined,
                        'Total Budget',
                        '₱ ${_formatCurrency(amount)}',
                        valueColor: const Color(0xFF22C55E),
                      ),
                    
                    // Duration
                    if (application['pricing'] != null && application['pricing']['durationValue'] != null)
                      _buildDetailRow(
                        Icons.schedule_outlined,
                        'Duration',
                        '${application['pricing']['durationValue']} ${application['pricing']['durationUnit'] ?? 'hours'}',
                      ),
                    
                    // Rate type
                    if (application['pricing'] != null && application['pricing']['rateType'] != null)
                      _buildDetailRow(
                        Icons.price_change_outlined,
                        'Rate Type',
                        _formatRateType(application['pricing']['rateType']),
                      ),
                    
                    // Location
                    if (application['location'] != null)
                      _buildDetailRow(
                        Icons.location_on_outlined,
                        'Location',
                        _formatLocation(application['location']),
                      ),
                    
                    // Applied date
                    if (application['createdAt'] != null)
                      _buildDetailRow(
                        Icons.calendar_today_outlined,
                        'Applied',
                        _formatApplicationDate(application['createdAt']),
                      ),
                    
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 16),
                    
                    // Client section
                    const Text(
                      'CLIENT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Client info /* payment_logic */
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: application['customerAvatar'] != null && application['customerAvatar'].toString().isNotEmpty
                                ? NetworkImage(application['customerAvatar'])
                                : null,
                            backgroundColor: const Color(0xFF1E45AD),
                            child: application['customerAvatar'] == null || application['customerAvatar'].toString().isEmpty
                                ? Text(
                                    (application['customerName'] ?? 'U')[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  application['customerName'] ?? 'Unknown Client',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                if (application['customerEmail'] != null && application['customerEmail'].toString().isNotEmpty)
                                  Text(
                                    application['customerEmail'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Action buttons
                    if (status == 'pending_approval') ...[
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.navigate();
                            _showWithdrawConfirmation(application);
                          },
                          icon: const Icon(Icons.undo_rounded),
                          label: const Text('Withdraw Application'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build detail row for bottom sheet
  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[500]),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? const Color(0xFF1F2937),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  /// Get status explanation text
  String _getStatusExplanation(String status) {
    switch (status) {
      case 'pending_approval':
        return 'Waiting for the client to review your application';
      case 'accepted':
      case 'active': // Active job = accepted application
        return 'Congratulations! The client has accepted you for this job';
      case 'rejected':
        return 'The client chose a different service provider';
      case 'cancelled':
        return 'This application has been cancelled';
      case 'completed':
        return 'This job has been completed successfully';
      default:
        return '';
    }
  }

  String _formatApplicationDate(dynamic timestamp) {
    try {
      DateTime date;
      if (timestamp is /* Timestamp removed */) {
        date = timestamp.toDate();
      } else if (timestamp is DateTime) {
        date = timestamp;
      } else {
        return 'Unknown date';
      }
      
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays == 0) {
        return 'Applied today';
      } else if (difference.inDays == 1) {
        return 'Applied yesterday';
      } else if (difference.inDays < 7) {
        return 'Applied ${difference.inDays} days ago';
      } else {
        return 'Applied ${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Unknown date';
    }
  }

  Widget _buildWidget() {
    if (_activeJobs.isEmpty) {
      return _buildEmptyState(
        icon: Icons.work_outline,
        title: 'No active jobs',
        subtitle: 'Accepted jobs will appear here. Pull down to refresh.',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh active jobs data
        // Also force refresh the real-time stream
        final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
        if (user != null) {
          if (mounted) {});
          }
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _activeJobs.length,
        itemBuilder: (context, index) {
          final job = _activeJobs[index];
          return _buildEnhancedActiveJobContainer(job);
        },
      ),
    );
  }

  Widget _buildSpecialRequestContainer(Map request) {
    // Handle urgency from job data
    final urgency = request['urgency']?.toString().toLowerCase() ?? 'normal';
    final urgencyColor = urgency == 'urgent' 
        ? Colors.red
        : urgency == 'high'
        ? Colors.orange
        : urgency == 'normal'
        ? Colors.blue
        : Colors.green;

    // Handle created date properly
    final createdAt = request['createdAt'];
    DateTime? postedDate;
    if (createdAt is /* Timestamp removed */) {
      postedDate = createdAt.toDate();
    } else {
      postedDate = DateTime.now();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E40AF).withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with urgency badge
          Row(
            children: [
              Expanded(
                child: Text(
                  request['title'] ?? 
                  request['serviceType'] ?? 
                  request['category'] ?? 
                  'Special Request',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: urgencyColor.withOpacity(0.1),
                  border: Border.all(color: urgencyColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${urgency.toUpperCase()} Priority',
                  style: TextStyle(
                    color: urgencyColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Category and /* payment_logic */ info
          Row(
            children: [
              Icon(Icons.category_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                request['category']?.toString().toUpperCase() ?? 'GENERAL',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1E40AF),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  request['customerName'] ?? 'Anonymous',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Posted time and duration
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                'Posted ${_formatTimeAgo(postedDate)}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (request['duration'] != null && request['duration'].toString().isNotEmpty) ...[
                const SizedBox(width: 16),
                Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  request['duration'].toString(),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            request['description'] ?? 'No description provided',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),

          // Required Skills
          if (request['requiredSkills'] != null && (request['requiredSkills'] as List).isNotEmpty) ...[
            const Text(
              'Required Skills:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: (request['requiredSkills'] as List)
                  .map((skill) => skill.toString())
                  .map(
                    (skill) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Bottom info and actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _formatLocation(request['location']),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '₱ ${_formatBudget(request['pricing']['totalPrice'])}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action buttons
          Column(
            children: [
              // First row - View Details button (full width)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showRequestDetailsDialog(request);
                  },
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text(
                    'View Details',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E40AF),
                    side: const BorderSide(
                      color: Color(0xFF1E40AF),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Second row - Message and Accept buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _inquireAboutJob(request);
                      },
                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                      label: const Text(
                        'Inquire',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(
                          color: Colors.orange,
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _acceptSpecialRequest(request);
                      },
                      icon: const Icon(Icons.check_circle, size: 18),
                      label: const Text(
                        'Accept',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedActiveJobContainer(Map job) {
    final progress = job['progress'] ?? 0;
    final statusColor = job['status'] == 'In Progress'
        ? Colors.orange
        : job['status'] == 'Starting Soon'
        ? Colors.blue
        : Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    job['clientAvatar'],
                    style: const TextStyle(
                      color: Color(0xFF1E40AF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['serviceType'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      job['clientName'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  job['status'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Job details
          Text(
            job['description'],
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),

          const SizedBox(height: 12),

          // Location and date
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                _formatLocation(job['location']),
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(Icons.schedule_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _formatStartDate(job['scheduledDate']),
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar (if in progress)
          if (job['status'] == 'In Progress') ...[
            Row(
              children: [
                Text(
                  'Progress: $progress%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                Text(
                  '$progress/100',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF1E40AF),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 💳 Payment status display
          if (job['status'] == 'for_client_review')  {
            // Implementation removed
          }
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Photos section
          const Text(
            'Work Progress Photos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // OPTIMIZATION: Verbose debug prints removed - they were causing ~2 seconds of lag per job /* payment_logic */ render
                
                // Try to load actual photos from job data
                if (job['beforePhotos'] != null && job['beforePhotos'] is List && (job['beforePhotos'] as List).isNotEmpty)
                  ...(job['beforePhotos'] as List).map(
                    (photo) => _buildPhotoThumbnail(_extractPhotoUrl(photo), 'Before'),
                  ),
                if (job['workInProgressPhotos'] != null && job['workInProgressPhotos'] is List && (job['workInProgressPhotos'] as List).isNotEmpty)
                  ...(job['workInProgressPhotos'] as List).map(
                    (photo) => _buildPhotoThumbnail(_extractPhotoUrl(photo), 'Proof'),
                  ),

                // Display progressPhotos (can be Base64 or Cloudinary)
                if (job['progressPhotos'] != null && job['progressPhotos'] is List && (job['progressPhotos'] as List).isNotEmpty)
                  ...(job['progressPhotos'] as List).map(
                    (photo) => _buildPhotoThumbnail(_extractPhotoUrl(photo), 'Proof'),
                  ),

                if (job['afterPhotos'] != null && job['afterPhotos'] is List && (job['afterPhotos'] as List).isNotEmpty)
                  ...(job['afterPhotos'] as List).map(
                    (photo) => _buildPhotoThumbnail(_extractPhotoUrl(photo), 'After'),
                  ),
                
                if (_hasNoPhotos(job)) ...[
                  _buildNoPhotosPlaceholder(),
                ],
                
                // Add photo button
                _buildAddJobPhotoButton(job),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Photo progress indicator
          _buildPhotoProgressIndicator(job),
          const SizedBox(height: 16),

          // Bottom row with price and actions
          Row(
            children: [
              Text(
                '₱ ${_formatCurrency((job['totalPrice'] ?? 0).toDouble())}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E40AF),
                ),
              ),
              const Spacer(),
              if (job['status'] == 'active') ...[
                // Job completion button (requires 3+ photos)
                _buildJobCompletionButton(job),
              ] else if (job['status'] == 'In Progress') ...[
                ElevatedButton.icon(
                  onPressed: () => _updateJobProgress(job),
                  icon: const Icon(Icons/* .update removed */, size: 16),
                  label: const Text('Update Progress'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ] else ...[
                ElevatedButton.icon(
                  onPressed: () => _viewJobDetails(job),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobHistoryContainer(Map job) {
    // Generate client avatar from /* payment_logic */ name (real data)
    final customerName = job['customerName'] ?? 'Client';
    final clientAvatar = customerName.isNotEmpty ? customerName[0].toUpperCase() : 'C';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with completion badge
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    clientAvatar,
                    style: const TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['serviceType'] ?? 'Service Completed',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      customerName,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'COMPLETED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Job details
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _formatLocation(job['location']),
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.schedule_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                job['duration'] ?? 'Duration',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Job completion info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600], size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Job completed successfully',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (job['totalPrice'] != null)
                  Text(
                    '₱ ${_formatCurrency((job['totalPrice'] ?? 0).toDouble())}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Project photos from real database
          // Always show project photos section
          const Text(
            'Project Photos',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 75,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Load actual photos from all photo arrays (supports Cloudinary URLs and Base64)
                if (job['beforePhotos'] != null && job['beforePhotos'] is List && (job['beforePhotos'] as List).isNotEmpty)
                  ...(job['beforePhotos'] as List).map(
                    (photo) => _buildPhotoThumbnail(_extractPhotoUrl(photo), 'Before'),
                  ),
                if (job['workInProgressPhotos'] != null && job['workInProgressPhotos'] is List && (job['workInProgressPhotos'] as List).isNotEmpty)
                  ...(job['workInProgressPhotos'] as List).map(
                    (photo) => _buildPhotoThumbnail(_extractPhotoUrl(photo), 'Proof'),
                  ),
                if (job['afterPhotos'] != null && job['afterPhotos'] is List && (job['afterPhotos'] as List).isNotEmpty)
                  ...(job['afterPhotos'] as List).map(
                    (photo) => _buildPhotoThumbnail(_extractPhotoUrl(photo), 'After'),
                  ),
                // Add support for progressPhotos array
                if (job['progressPhotos'] != null && job['progressPhotos'] is List && (job['progressPhotos'] as List).isNotEmpty)
                  ...(job['progressPhotos'] as List).map(
                    (photo) => _buildPhotoThumbnail(_extractPhotoUrl(photo), 'Proof'),
                  ),
                
                if (_hasNoPhotos(job)) ...[
                  _buildNoPhotosPlaceholder(),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Bottom row with completion date and additional info
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Completed: ${_formatDate(job['completedAt'] ?? DateTime.now())}',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const Spacer(),
              if (job['duration'] != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    job['duration'],
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
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
    // Use real completed jobs data from database
    if (_completedJobs.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: 'No job history',
        subtitle: 'Completed jobs will appear here. Pull down to refresh.',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh completed jobs data
        // Also force refresh the completed jobs
        final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
        if (user != null) {
          if (mounted) {});
          }
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _completedJobs.length,
        itemBuilder: (context, index) {
          final job = _completedJobs[index];
          print('🎯 Building job history /* payment_logic */ $index: ${job['serviceType']} (ID: ${job['id']})');
          return _buildJobHistoryContainer(job);
        },
      ),
    );
  }

  Widget _buildRecentMessagesListStream(List<Map> conversations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AppName Support Section at Top
        _buildServiceProviderSupportSection(),
        
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Conversations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Debug UI to show conversation count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: conversations.isNotEmpty ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: conversations.isNotEmpty ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: Text(
                'Live: ${conversations.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: conversations.isNotEmpty ? Colors.green[700] : Colors.red[700],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Display real conversations from real-time stream
        if (conversations.isNotEmpty)
          ...conversations.map((conversation) {
            // Extract participant info inline
            final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
            final participantDetails = conversation['participantDetails'] as Map? ?? {};
            
            String otherParticipantName = 'Unknown User';
            String otherParticipantAvatar = '';
            
            if (user != null) {
              for (final participantId in participantDetails.keys) {
                if (participantId != user.uid) {
                  final participant = participantDetails[participantId];
                  otherParticipantName = participant['name'] ?? 'Unknown User';
                  otherParticipantAvatar = participant['photoURL'] ?? participant['avatar'] ?? '';
                  break;
                }
              }
            }
            
            return ConversationContainer(
              currentUserId: user?.uid, // Pass current user ID
              conversation: {
                'id': conversation['id'] ?? 'unknown',
                'otherUserName': otherParticipantName,
                'otherUserPhotoURL': otherParticipantAvatar,
                'lastMessage': conversation['lastMessage'] ?? 'No messages yet',
                'lastMessageTime': conversation['lastMessageTime'] is /* Timestamp removed */
                    ? (conversation['lastMessageTime'] as /* Timestamp removed */).toDate()
                    : conversation['lastMessageTime'] as DateTime?,
                'unreadCount': conversation['unreadCount'] ?? {},
              },
              onTap: () {
                Navigator.navigate() => ConversationScreen(
                      conversationId: conversation['id'] ?? 'unknown',
                      clientName: otherParticipantName,
                      clientAvatar: otherParticipantAvatar,
                      serviceType: conversation['serviceType'] ?? 'General Service',
                    ),
                  ),
                );
              },
            );
          }).toList(),
        
        // Show helpful message if no conversations exist
        if (conversations.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No conversations yet',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'When customers contact you, their messages will appear here',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Build add photo button specific to jobs
  Widget _buildAddJobPhotoButton(Map job) {
    return GestureDetector(
      onTap: () => _showPhotoOptions(job),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF1E40AF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF1E40AF),
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              color: Color(0xFF1E40AF),
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              'Add Photo',
              style: TextStyle(
                color: Color(0xFF1E40AF),
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Build photo progress indicator
  Widget _buildPhotoProgressIndicator(Map job) {
    final totalPhotos = _getTotalPhotosCount(job);
    final minRequired = 3;
    
    // Debug: Print progress indicator status
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: totalPhotos >= minRequired 
            ? Colors.green.withOpacity(0.1) 
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: totalPhotos >= minRequired ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            totalPhotos >= minRequired ? Icons.check_circle : Icons.photo_camera,
            color: totalPhotos >= minRequired ? Colors.green : Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            totalPhotos >= minRequired 
                ? 'Ready for completion ($totalPhotos photos)'
                : 'Need ${minRequired - totalPhotos} more photos to complete job',
            style: TextStyle(
              color: totalPhotos >= minRequired ? Colors.green[700] : Colors.orange[700],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Build job completion button (shows when 3+ photos uploaded)
  Widget _buildJobCompletionButton(Map job) {
    final totalPhotos = _getTotalPhotosCount(job);
    final canComplete = totalPhotos >= 3;
    
    // Debug: Print completion button status
    return ElevatedButton.icon(
      onPressed: canComplete ? () => _markJobComplete(job) : null,
      icon: Icon(
        canComplete ? Icons.check_circle : Icons.photo_camera,
        size: 16,
      ),
      label: Text(
        canComplete ? 'Mark Complete' : 'Need ${3 - totalPhotos} photos',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: canComplete ? const Color(0xFF059669) : Colors.grey,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey[300],
        disabledForegroundColor: Colors.grey[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  // Get total photos count
  int _getTotalPhotosCount(Map job) {
    int count = 0;
    if (job['beforePhotos'] is List) count += (job['beforePhotos'] as List).length;
    if (job['workInProgressPhotos'] is List) count += (job['workInProgressPhotos'] as List).length;
    if (job['afterPhotos'] is List) count += (job['afterPhotos'] as List).length;
    if (job['progressPhotos'] is List) count += (job['progressPhotos'] as List).length;
    
    // Debug: Print total count for verification
    print('   Before: ${(job['beforePhotos'] as List?)?.length ?? 0}');
    print('   WIP: ${(job['workInProgressPhotos'] as List?)?.length ?? 0}');
    print('   After: ${(job['afterPhotos'] as List?)?.length ?? 0}');
    print('   Progress: ${(job['progressPhotos'] as List?)?.length ?? 0}');
    
    return count;
  }

  // Check if job has no photos
  bool _hasNoPhotos(Map job) {
    final beforePhotos = job['beforePhotos'] as List? ?? [];
    final wipProgressPhotos = job['workInProgressPhotos'] as List? ?? [];
    final afterPhotos = job['afterPhotos'] as List? ?? [];
    final progressPhotos = job['progressPhotos'] as List? ?? [];
    
    // Debug: Print photo arrays for debugging
    print('   Before photos: $beforePhotos (length: ${beforePhotos.length})');
    print('   WIP Progress photos: $wipProgressPhotos (length: ${wipProgressPhotos.length})');
    print('   After photos: $afterPhotos (length: ${afterPhotos.length})');
    print('   Progress photos: $progressPhotos (length: ${progressPhotos.length})');
    return beforePhotos.isEmpty && wipProgressPhotos.isEmpty && afterPhotos.isEmpty && progressPhotos.isEmpty;
  }

  Widget _buildImageWidget(String photoPath) {
    if (photoPath.isEmpty) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[300],
        child: const Icon(Icons.image, color: Colors.grey, size: 24),
      );
    }

    // Check if it's a Base64 string
    if (photoPath.startsWith('data:image/') || _isBase64String(photoPath)) {
      try {
        late Uint8List imageBytes;
        
        if (photoPath.startsWith('data:image/')) {
          // Handle data URL format: "data:image/jpeg;base64,/9j/4AAQSkZJRgABA..."
          final base64String = photoPath.split(',').last;
          imageBytes = base64Decode(base64String);
        } else {
          // Handle raw Base64 string
          imageBytes = base64Decode(photoPath);
        }

        return Image.memory(
          imageBytes,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.error, color: Colors.grey, size: 20),
          ),
        );
      } catch (e) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error, color: Colors.grey, size: 20),
        );
      }
    }

    // Check if it's an HTTP URL
    // Network call removed
      return CachedNetworkImage(
        imageUrl: photoPath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error, color: Colors.grey, size: 20),
        ),
      );
    }

    // Default fallback for invalid paths
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
      child: const Icon(Icons.image, color: Colors.grey, size: 24),
    );
  }

  // Helper method to check if a string is Base64 encoded
  bool _isBase64String(String str) {
    try {
      // Basic validation: Base64 strings should be divisible by 4 when padded
      final normalizedStr = str.replaceAll(RegExp(r'[^A-Za-z0-9+/=]'), '');
      if (normalizedStr.length % 4 != 0) return false;
      
      // Try to decode a small portion to validate
      base64Decode(normalizedStr.substring(0, math.min(normalizedStr.length, 8).clamp(4, normalizedStr.length)));
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildFullScreenImageWidget(String imageUrl) {
    // Check if it's a Base64 string
    if (imageUrl.startsWith('data:image/') || _isBase64String(imageUrl)) {
      try {
        late Uint8List imageBytes;
        
        if (imageUrl.startsWith('data:image/')) {
          // Handle data URL format: "data:image/jpeg;base64,/9j/4AAQSkZJRgABA..."
          final base64String = imageUrl.split(',').last;
          imageBytes = base64Decode(base64String);
        } else {
          // Handle raw Base64 string
          imageBytes = base64Decode(imageUrl);
        }

        return Image.memory(
          imageBytes,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.white, size: 48),
                SizedBox(height: 16),
                Text(
                  'Failed to load image',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      } catch (e) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.white, size: 48),
              SizedBox(height: 16),
              Text(
                'Invalid Base64 image',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      }
    }

    // Check if it's an HTTP URL
    // Network call removed
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.white, size: 48),
              SizedBox(height: 16),
              Text(
                'Failed to load image',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    // Default fallback for invalid URLs
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, color: Colors.white, size: 48),
          SizedBox(height: 16),
          Text(
            'Unsupported image format',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<Map> _fetchServiceProviderReviews(String serviceproviderId) async  {
    // Implementation removed
  }
  }

  // Calculate average rating for display
  String _calculateAverageRating()  {
    // Implementation removed
  }
    if (rating == null || rating == 0.0) {
      return '0.0';
    }
    return rating.toStringAsFixed(1);
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Date not available';
    
    DateTime? dateTime;
    if (date is /* Timestamp removed */) {
      dateTime = date.toDate();
    } else if (date is DateTime) {
      dateTime = date;
    } else if (date is String) {
      dateTime = DateTime.tryParse(date);
    }
    
    if (dateTime == null) return 'Date not available';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    }
  }

  String _formatBudget(dynamic budget) {
    if (budget == null) return '0';
    
    if (budget is String) {
      // Try to parse the string as a number
      final parsed = double.tryParse(budget);
      if (parsed != null) {
        return _formatCurrency(parsed);
      }
      return budget; // Return as-is if can't parse
    } else if (budget is num) {
      return _formatCurrency(budget.toDouble());
    }
    
    return budget.toString();
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  String _formatStartDate(dynamic startDate) {
    if (startDate == null) return 'Not specified';
    
    DateTime? date;
    if (startDate is /* Timestamp removed */) {
      date = startDate.toDate();
    } else if (startDate is DateTime) {
      date = startDate;
    } else if (startDate is String) {
      date = DateTime.tryParse(startDate);
    }
    
    if (date == null) return 'Not specified';
    
    // Format as date: "Nov 15, 2025"
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }
  
  // Helper to get month name from month number
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _formatLocation(dynamic location) {
    if (location == null) return 'Location not specified';
    
    if (location is String) {
      return location;
    } else if (location is Map) {
      // Handle location as a map with city, barangay, etc.
      final city = location['city'] ?? '';
      final barangay = location['barangay'] ?? '';
      final address = location['streetAddress'] ?? location['address'] ?? '';
      
      List<String> parts = [];
      if (address.isNotEmpty) parts.add(address);
      if (barangay.isNotEmpty) parts.add(barangay);
      if (city.isNotEmpty) parts.add(city);
      
      return parts.isNotEmpty ? parts.join(', ') : 'Location not specified';
    } else {
      return location.toString();
    }
  }

  void _showRequestDetailsDialog(Map request) {
    // Track job view when details are opened (silent operation)
    final jobId = request['id'];
    final serviceproviderId = /* FirebaseAuth removed *//* .instance removed */.currentUser?.uid;
    if (jobId != null && serviceproviderId != null) {
      ServiceProviderService.trackJobView(jobId, serviceproviderId);
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // CLEAN HEADER - Readable without gradient
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Badge in one row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              request['title'] ?? request['serviceType'] ?? 'Job Details',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              border: Border.all(color: Colors.blue[200]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              (request['urgency']?.toString() ?? 'normal').toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E40AF),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // /* payment_logic */ name
                      Row(
                        children: [
                          Icon(Icons.person_outline, 
                            color: Colors.grey[600], 
                            size: 16
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Requested by ${request['customerName'] ?? 'Anonymous'}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // MAIN CONTENT
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 14,
                    children: [
                      // 💰 Budget & Duration /* payment_logic */
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          border: Border.all(color: Colors.blue[200]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Budget',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₱ ${_formatBudget(request['pricing']?['totalPrice'] ?? request['budget'] ?? 0)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E40AF),
                                  ),
                                ),
                              ],
                            ),
                            if (request['duration'] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Duration',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    request['duration'].toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      // 📍 Location & Category
                      Row(
                        children: [
                          Expanded(
                            child: _buildSimpleDetailContainer(
                              icon: Icons.location_on_outlined,
                              label: 'Location',
                              value: _formatLocation(request['location']),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildSimpleDetailContainer(
                              icon: Icons.category_outlined,
                              label: 'Category',
                              value: request['category'] ?? 'General',
                            ),
                          ),
                        ],
                      ),

                      // 📝 Description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            request['description'] ?? 'No description provided',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),

                      // 🎯 Skills
                      if (request['requiredSkills'] != null &&
                          (request['requiredSkills'] as List).isNotEmpty) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Required Skills',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: (request['requiredSkills'] as List).map((skill) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    border: Border.all(color: Colors.blue[200]!),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    skill.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1E40AF),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ],

                      // 👁️ Stats
                      Row(
                        children: [
                          Expanded(
                            child: _buildSimpleStatChip(
                              icon: Icons.visibility_outlined,
                              label: '${request['views'] ?? 0} Views',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildSimpleStatChip(
                              icon: Icons.people_outline,
                              label: '${request['applicants'] ?? 0} Applicants',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // ACTION BUTTONS
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.navigate();
                            _acceptSpecialRequest(request);
                          },
                          icon: const Icon(Icons.check_circle_outline, size: 18),
                          label: const Text('Accept Job'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.navigate();
                            _startNewConversation(request);
                          },
                          icon: const Icon(Icons.message_outlined, size: 18),
                          label: const Text('Send Message'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            side: const BorderSide(color: Colors.orange, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Button(
                          onPressed: () => Navigator.navigate(),
                          child: Text(
                            'Close',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleDetailContainer({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStatChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _acceptSpecialRequest(Map request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Special Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Accept the special request for "${request['title']}"?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Client: ${request['customerName']}'),
                  Text('Budget: ₱ ${_formatBudget(request['pricing']?['totalPrice'])}'),
                  Text('Location: ${_formatLocation(request['location'])}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'By accepting, this request will be sent to the client for their approval.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.navigate();
            },
            icon: const Icon(Icons.check, size: 16),
            label: const Text('Accept Job'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Handle the actual special request acceptance with backend integration
  Future<void> _handleAcceptSpecialRequest(Map request) async {
    try {
      final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to accept requests')),
        );
        return;
      }

      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text('Accepting special request...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Get the job ID from the request
      final jobId = request['id'];
      if (jobId == null) {
        throw Exception('Job ID not found in request');
      }


      // Show success message
      if (mounted) {} for approval!',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View Status',
              textColor: Colors.white,
              onPressed: () {
                // Switch to messages tab to check status
                setState(() {});
              },
            ),
          ),
        );

        // Refresh data to reflect changes
      }

    } catch (e) {
      if (mounted) {}
    }
  }

  // New method to handle job inquiries properly
  Future<void> _inquireAboutJob(Map request) async {
    final TextEditingController messageController = TextEditingController();
    messageController.text = 'Hi! I\'m interested in your ${request['title']} request. I have experience in ${request['category']} and would like to discuss the details with you.';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            UserProfileAvatar(
              photoURL: request['customerPhotoURL'],
              firstName: request['customerName'],
              userRole: '/* payment_logic */',
              radius: 20,
              backgroundColor: const Color(0xFF1E40AF),
              textColor: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Inquire about Job',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'To: ${request['customerName'] ?? 'Job /* payment_logic */'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E40AF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.work_outline,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          request['title'] ?? 
                          request['serviceType'] ?? 
                          request['category'] ?? 
                          'Special Request',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Text(request['category'] ?? 'General Service'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Text(_formatLocation(request['location'])),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      Text(
                        'Budget: ${_formatBudget(request['pricing']?['totalPrice'] ?? request['budget'])}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'Your inquiry message',
                hintText: 'Introduce yourself and express interest in the job...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final message = messageController.text.trim();
              if (message.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a message')),
                );
                return;
              }

              Navigator.navigate();
            },
            icon: const Icon(Icons.send, size: 16),
            label: const Text('Send Inquiry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E40AF),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Method to actually send the inquiry and create conversation
  Future<void> _sendInquiryMessage(Map request, String message) async {
    try {
      final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to send inquiries')),
        );
        return;
      }

      // Show loading
      if (mounted) {}

      // Debug: Print the entire request structure safely
      print('   Keys: ${request.keys.toList()}');
      
      // Safe debug printing
      try {
        for (final key in request.keys) {
          final value = request[key];
          print('   $key: $value (${value.runtimeType})');
          if (value is Map) {
            try {
              print('     Map keys: ${value.keys.toList()}');
            } catch (e) {
            }
          }
        }
      } catch (e) {
      }
      
      // Get /* payment_logic */ ID with robust handling
      String? customerId;
      
      // List of possible field names for /* payment_logic */ ID
      final possibleFields = ['customerId', 'postedBy', 'userId'];
      
      for (final fieldName in possibleFields) {
        if (request.containsKey(fieldName)) {
          final value = request[fieldName];
          print('   Checking $fieldName: $value (${value.runtimeType})');
          
          if (value is String && value.isNotEmpty) {
            customerId = value;
            break;
          } else if (value is Map) {
            // Try to extract ID from nested map
            if (value.containsKey('id') && value['id'] is String) {
              customerId = value['id'] as String;
              break;
            }
          }
        }
      }
      if (customerId == null || customerId.isEmpty) {
        request.forEach((k, v) => print('     $k: ${v.toString().length > 100 ? '${v.toString().substring(0, 100)}...' : v}'));
        throw Exception('/* payment_logic */ ID not found in job request. Tried fields: $possibleFields');
      }

      // Create or get conversation
        customerId: customerId,
        serviceproviderId: user.uid,
        serviceType: request['category'] ?? 'Service Request',
      );

      // Send the inquiry message
        conversationId: conversationId,
        message: message,
      );
      // Refresh conversations and show success

      if (mounted) {}!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                // Switch to messages tab
                setState(() {});
              },
            ),
          ),
        );
      }

    } catch (e) {
      if (mounted) {}
    }
  }

  void _startNewConversation(Map request) {
    // Redirect to the new inquiry method
    _inquireAboutJob(request);
  }



  void _updateJobProgress(Map job)  {
    // Implementation removed
  }
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Progress percentage (0-100)',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Progress notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
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
                  content: Text('Progress updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _viewJobDetails(Map job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(job['serviceType']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Client: ${job['clientName']}'),
              const SizedBox(height: 8),
              Text('Location: ${job['location']}'),
              const SizedBox(height: 8),
              Text('Scheduled: ${_formatStartDate(job['scheduledDate'])}'),
              const SizedBox(height: 8),
              Text('Status: ${job['status']}'),
              const SizedBox(height: 8),
              Text('Price: ₱ ${_formatCurrency((job['totalPrice'] ?? 0).toDouble())}'),
              if (job['description'] != null) ...[
                const SizedBox(height: 12),
                const Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(job['description']),
              ],
              if (job['notes'] != null) ...[
                const SizedBox(height: 12),
                const Text(
                  'Notes:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(job['notes']),
              ],
            ],
          ),
        ),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Method to show full-screen image viewer
  void _showFullScreenImage(String imageUrl, String label) {
    if (imageUrl.isEmpty) return;
    
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: _buildFullScreenImageWidget(imageUrl),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
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
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {});
          // Load tab-specific data on-demand (lazy loading for smooth tab switching)
          _loadTabData(index);
          
          // Force reload special requests when Jobs tab is clicked
          if (index == 1) {
            _loadSpecialRequestsOnly();
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1E45AD),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }



  // Accept a job request
  Future<void> _acceptJobRequest(Map request) async {
    try {
      final bookingId = request['id'];
      if (bookingId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid booking ID')),
        );
        return;
      }

      
      if (mounted) {}
    } catch (e) {
      if (mounted) {}
    }
  }

  // Decline a job request
  Future<void> _declineJobRequest(Map request) async {
    try {
      final bookingId = request['id'];
      if (bookingId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid booking ID')),
        );
        return;
      }

      // Show reason dialog
      if (reason == null) return; // User cancelled

      
      if (mounted) {}
    } catch (e) {
      if (mounted) {}
    }
  }

  // Show dialog to get decline reason
  Future<String?> _showDeclineReasonDialog() async {
    final TextEditingController reasonController = TextEditingController();
    
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline Job Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for declining this job:'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Enter reason...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel'),
          ),
          Button(
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) {
                Navigator.of(context).pop(reasonController.text.trim());
              }
            },
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }

  // ========== PHOTO CAPTURE AND JOB COMPLETION METHODS ==========

  // Show photo options dialog
  void _showPhotoOptions(Map job) {
    final photoType = _determinePhotoType(job);
    final photoTypeDisplay = photoType == 'progress' ? 'Progress' : 
                           photoType == 'before' ? 'Before' : 'After';
    
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
            Text(
              'Add $photoTypeDisplay Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This will be saved as a $photoTypeDisplay photo',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPhotoOptionContainer(
                  icon: Icons.camera_alt,
                  title: 'Camera',
                  subtitle: 'Take a photo',
                  onTap: () {
                    Navigator.navigate();
                    _takePicture(job, ImageSource.camera);
                  },
                ),
                _buildPhotoOptionContainer(
                  icon: Icons.photo_library,
                  title: 'Gallery',
                  subtitle: 'Choose from gallery',
                  onTap: () {
                    Navigator.navigate();
                    _takePicture(job, ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Take clear photos showing your work progress. Minimum 3 photos needed to complete the job.',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build photo option /* payment_logic */
  Widget _buildPhotoOptionContainer({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF1E40AF)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Take picture method
  Future<void> _takePicture(Map job, ImageSource source) async {
    try {
      File? imageFile;
      if (source == ImageSource.camera) {
      } else {
      }

      if (imageFile != null) {
        // Show loading
        if (mounted) {}

        // Determine photo type based on job status
        String photoType = _determinePhotoType(job);
        
          imageFile: imageFile,
          jobId: job['id'] ?? '',
          photoType: photoType,
        );
        
        if (mounted) {}
      }
    } catch (e) {
      if (mounted) {}
    }
  }

  // Determine photo type based on job status and existing photos
  String _determinePhotoType(Map job) {
    final status = job['status']?.toString().toLowerCase() ?? '';
    
    // Check existing photos to determine what type is needed next
    final beforePhotos = job['beforePhotos'] as List? ?? [];
    final workInProgressPhotos = job['workInProgressPhotos'] as List? ?? [];
    final afterPhotos = job['afterPhotos'] as List? ?? [];
    
    // If no before photos and job hasn't started yet, take before photo
    if (beforePhotos.isEmpty && (status == 'pending' || status == 'assigned')) {
      return 'before';
    }
    
    // If job is in progress and no progress photos, take work in progress photo
    if (status == 'in_progress' && workInProgressPhotos.isEmpty) {
      return 'workInProgress';
    }
    
    // If job is completed and no after photos, take after photo
    if (status == 'completed' && afterPhotos.isEmpty) {
      return 'after';
    }
    
    // Default to work in progress photos during active work
    if (status == 'in_progress' || status == 'active') {
      return 'workInProgress';
    }
    
    // If job is completed, default to after photos
    if (status == 'completed') {
      return 'after';
    }
    
    // Default fallback
    return 'workInProgress';
  }

  Future<void> _markJobComplete(Map job) async {
    final totalPhotos = _getTotalPhotosCount(job);
    
    // Show confirmation dialog
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Color(0xFF059669), size: 28),
            SizedBox(width: 12),
            Text('Mark as Complete?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You have uploaded $totalPhotos photo${totalPhotos != 1 ? 's' : ''}.',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: const Text(
                '💡 Once marked complete, the client will be notified to review your work and release payment.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.navigate(),
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Mark Complete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
    
    if (confirmed != true) return;
    
    // Show loading
    if (mounted) {}
    
    try {
      final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (user == null) return;
      
        jobId: job['id'],
        customerId: job['customerId'] ?? '',
        serviceproviderId: user.uid,
      );
      
      if (mounted) {}
            });
          } else {
            print('⚠️ Interstitial ad not ready, refreshing data immediately');
            // Refresh data immediately if ad not ready
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed: ${result['error'] ?? 'Unknown error'}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {}
    }
  }

  // Build placeholder when no photos exist
  Widget _buildWidget() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),  
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library, color: Colors.grey[400], size: 20),
          const SizedBox(height: 4),
          Text(
            'No photos',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // 📸 IMAGE PICKER METHODS
  
  void _show// Image utility removedModal() {
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _build// Image utility removedOption(
                  icon: Icons.photo_camera,
                  label: 'Camera',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _build// Image utility removedOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _build// Image utility removedOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.navigate();
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
      }
    } catch (e) {
      if (mounted) {}
    }
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    if (!mounted) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (user == null) throw Exception('No user logged in');

        imageFile: imageFile,
        userId: user.uid,
        userType: 'serviceprovider',
      );

      final photoURL = response.secureUrl;

          // Database operation removed
          // Database operation removed
          /* .update removed */({'photoURL': photoURL});

      if (mounted) {}
        });

        Navigator.navigate(); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Profile photo updated successfully!'),
              ],
            ),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {}
    }
  }

  Widget _buildWidget() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SupportModal(
            onMessageSupport: _startSupportConversation,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orange.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.headset_mic,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AppName Support',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Need help? Chat with our team about portfolio, payments & more',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    );
  }

  // Start support conversation with admin
  Future<void> _startSupportConversation() async {
    try {
      final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to contact support'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

        userId: user.uid,
        userType: 'serviceprovider',
        issue: 'General Support',
      );

      if (mounted) {}
    } catch (e) {
      if (mounted) {}
    }
  }
}

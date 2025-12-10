class PostJobScreen extends StatefulWidget {
  final Map? data;
  final Map? editingJob;

  const PostJobScreen({super.key, this.data, this.editingJob});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Form controllers
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();

  // Form variables
  String _selectedJobCategory = '';
  String _selectedPriceType = 'per_hour'; // per_hour, per_day, fixed_price
  String _selectedUrgency = 'normal'; // low, normal, high, urgent
  DateTime? _preferredStartDate;
  final List<String> _requiredSkills = []; // Limited to 3 skills
  
  // Duration fields
  final TextEditingController _durationNumberController = TextEditingController();
  String _selectedDurationType = 'days'; // hours, days, weeks
  
  // Location fields (copying from address_confirm_screen.dart)
  String? _selectedBarangay;
  final TextEditingController _streetAddressController = TextEditingController();
  bool _isPosting = false;
  bool _isNavigating = false; // Add navigation lock

  // Performance optimization variables
  Timer? _skillSelectionDebouncer;
  Timer? _navigationDebouncer;

  // UI optimization variables
  final int _maxVisibleSkills = 15; // Limit initial visible skills
  bool _showAllSkills = false;

  final Set<Timer> _activeTimers = {};
  bool _isDisposed = false; // Job categories
  final List<Map> _jobCategories = [
    {
      'name': 'Construction',
      'icon': Icons.construction,
      'color': Colors.orange,
    },
    {'name': 'Plumbing', 'icon': Icons.plumbing, 'color': Colors.blue},
    {
      'name': 'Electrical',
      'icon': Icons.electrical_services,
      'color': Colors.yellow[700],
    },
    {'name': 'Mechanical', 'icon': Icons.engineering, 'color': Colors.red},
    {
      'name': 'Cleaning',
      'icon': Icons.cleaning_services,
      'color': Colors.purple,
    },
    {'name': 'Painting', 'icon': Icons.format_paint, 'color': Colors.pink},
    {'name': 'Carpentry', 'icon': Icons.handyman, 'color': Colors.brown},
    {'name': 'Landscaping', 'icon': Icons.grass, 'color': Colors.green},
    {'name': 'Welding', 'icon': Icons.build_circle, 'color': Colors.grey[700]},
    {'name': 'Other', 'icon': Icons.work_outline, 'color': Colors.blueGrey},
  ];

  // List of all barangays in Olongapo City (copied from address_confirm_screen.dart)
  final List<String> _olongapoBarangays = [
    'Asinan Poblacion',
    'Banicain',
    'Baretto',
    'Barretto',
    'East Bajac-Bajac',
    'East Tapinac',
    'Gordon Heights',
    'Kalaklan',
    'Mabayuan',
    'New Asinan',
    'New Banicain',
    'New Cabalan',
    'New Ilalim',
    'New Kababae',
    'New Kalalake',
    'Old Asinan',
    'Old Cabalan',
    'Pag-asa',
    'Santa Rita',
    'West Bajac-Bajac',
    'West Tapinac',
  ];

  // Skills suggestions
  final List<String> _skillSuggestions = [
    'Concrete Work',
    'Tile Installation',
    'Roofing',
    'Demolition',
    'Pipe Installation',
    'Leak Repair',
    'Drain Cleaning',
    'Fixture Installation',
    'Wiring',
    'Panel Installation',
    'Light Fixture',
    'Outlet Installation',
    'Engine Repair',
    'Maintenance',
    'Troubleshooting',
    'Equipment Operation',
    'Deep Cleaning',
    'Window Cleaning',
    'Carpet Cleaning',
    'Sanitization',
    'Interior Painting',
    'Exterior Painting',
    'Wall Preparation',
    'Color Consultation',
    'Furniture Assembly',
    'Cabinet Installation',
    'Door Installation',
    'Trim Work',
    'Garden Design',
    'Tree Trimming',
    'Lawn Care',
    'Irrigation',
    'Arc Welding',
    'MIG Welding',
    'Metal Fabrication',
    'Repair Work',
    'Others',
  ];

  @override
  void initState() {
    super.initState();
    // Auto-fetch phone number from user data
    _initializeContactInfo();
    // If editing an existing job, populate the form fields
    if (widget.editingJob != null) {
      _populateEditingJobData();
    }
    // Load interstitial ad for showing after successful job posting
    _loadInterstitialAd();
  }

  /// Load interstitial ad for showing after successful job posting
  void _loadInterstitialAd() {
    AdMobService.loadInterstitialAd(
      onAdLoaded: () {
        print('✅ Interstitial ad ready for job posting');
      },
      onAdFailedToLoad: (error) {
        print('❌ Failed to load interstitial ad: ${error.message}');
      },
      onAdDismissed: () {
        print('🔒 Interstitial ad dismissed, navigating back');
        // Navigate back after ad is dismissed
        if (mounted && !_isDisposed) {
          Navigator.navigate();
        }
      },
    );
  }
  
  // Populate form fields when editing an existing job
  void _populateEditingJobData() {
    if (widget.editingJob == null) return;
    
    final job = widget.editingJob!;
    _jobTitleController.text = job['title']?.toString() ?? '';
    _jobDescriptionController.text = job['description']?.toString() ?? '';
    _locationController.text = job['location']?.toString() ?? '';
    _budgetController.text = job['budget']?.toString() ?? '';
    _durationController.text = job['duration']?.toString() ?? '';
    _contactInfoController.text = job['contactInfo']?.toString() ?? '';
    
    // Set other form fields
    if (job['urgency'] != null) {
      _selectedUrgency = job['urgency'].toString();
    }
  }
  
  // Initialize contact info by fetching from multiple sources
  Future<void> _initializeContactInfo() async {
    if (mounted) {});
    }
  }
  
  // Helper method to get /* payment_logic */'s phone number from various possible sources
  Future<String> _getCustomerPhoneNumber() async {
    try {
      if (widget.data != null) {
        final phoneFromWidget = _extractPhoneFromUserData(widget.data!);
        if (phoneFromWidget.isNotEmpty) {
          return phoneFromWidget;
        }
      }
      
      final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (currentUser != null) {
        try {
              // Database operation removed
              // Database operation removed
              /* .get removed */();
          
          if (userDoc.exists) {
            final data = userDoc.data() as Map;
            final phoneFromFirestore = _extractPhoneFromUserData(data);
            if (phoneFromFirestore.isNotEmpty)  {
              // Implementation removed
            }
          }
        } catch (e) {
        }
      }
      
      if (currentUser?.phoneNumber != null && currentUser!.phoneNumber!.isNotEmpty) {
        return currentUser.phoneNumber!;
      }
      return '';
      
    } catch (e) {
      return '';
    }
  }
  
  // Extract phone number from user data map, trying multiple field names
  String _extractPhoneFromUserData(Map data) {
    // Try multiple possible field names for phone number
    final possibleFields = [
      'phoneNumber',
      'phone',
      'contactNumber', 
      'mobileNumber',
      'mobile',
      'contact',
      'phoneNum',
      'registeredPhone'
    ];
    
    for (final field in possibleFields) {
      final value = data[field];
      if (value != null && value.toString().trim().isNotEmpty) {
        final cleanPhone = value.toString().trim();
        // Basic validation - check if it looks like a phone number
        if (_isValidPhoneFormat(cleanPhone)) {
          return cleanPhone;
        }
      }
    }
    
    return '';
  }
  
  // Basic phone number format validation
  bool _isValidPhoneFormat(String phone) {
    // Remove common formatting characters
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    
    // Check if it contains only digits and is reasonable length
    if (RegExp(r'^\d{10,13}$').hasMatch(cleanPhone)) {
      return true;
    }
    
    // Check for Philippine format specifically
    if (RegExp(r'^(\+63|63|0)?[0-9]{10,11}$').hasMatch(phone)) {
      return true;
    }
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisposed) {
      return const Scaffold(
        body: Center(child: Text('Screen is being disposed...')),
      );
    }

    try {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: _isPosting || _isNavigating
                ? null
                : () {
                    if (!_isDisposed && mounted) {
                      Navigator.navigate();
                    }
                  },
          ),
          title: Text(
            widget.editingJob != null ? 'Edit Job' : 'Post a Job',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(),

            // Form content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBasicInfoStep(),
                  _buildJobDetailsStep(),
                  _buildBudgetLocationStep(),
                  _buildReviewStep(),
                ],
              ),
            ),

            _buildNavigationButtons(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      );
    } catch (e) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.navigate(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'An error occurred while loading the form',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                e.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              Button(
                onPressed: () => Navigator.navigate(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: index <= _currentStep ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What job do you need help with?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Provide a clear title and category for your job',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Job Title
            const Text(
              'Job Title',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _jobTitleController,
              decoration: InputDecoration(
                hintText: 'e.g., Kitchen Renovation, Plumbing Repair',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a job title';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Job Category
            const Text(
              'Job Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _jobCategories.length,
              itemBuilder: (context, index) {
                final category = _jobCategories[index];
                final isSelected = _selectedJobCategory == category['name'];

                return GestureDetector(
                  onTap: () {
                    if (!mounted || _isDisposed) return;

                    final categoryName = category['name']?.toString();
                    if (categoryName != null && categoryName.isNotEmpty) {
                      setState(() {});
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category['icon'] as IconData? ?? Icons.work_outline,
                          color: isSelected
                              ? Colors.blue
                              : (category['color'] as Color? ?? Colors.grey),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category['name']?.toString() ?? 'Unknown',
                          style: TextStyle(
                            color: isSelected ? Colors.blue : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Job Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Describe your job requirements clearly',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          // Job Description
          const Text(
            'Job Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _jobDescriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText:
                  'Describe the work needed, materials required, timeline, and any specific requirements...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please provide a job description';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Required Skills
          const Text(
            'Required Skills',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select skills that are most relevant to your job',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          _buildOptimizedSkillsSection(),
          const SizedBox(height: 24),

          // Urgency Level
          const Text(
            'Urgency Level',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildUrgencyOption('low', 'Low Priority', Colors.green),
              _buildUrgencyOption('normal', 'Normal', Colors.blue),
              _buildUrgencyOption('high', 'High Priority', Colors.orange),
              _buildUrgencyOption('urgent', 'Urgent', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUrgencyOption(String value, String label, Color color) {
    final isSelected = _selectedUrgency == value;
    return GestureDetector(
      onTap: () {
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? color : Colors.grey[300]!),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? color : Colors.black,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget & Location',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set your budget and location details',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          // Price Type Selection
          const Text(
            'Payment Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPriceTypeOption('per_hour', 'Per Hour', Icons.access_time),
              const SizedBox(width: 8),
              _buildPriceTypeOption('per_day', 'Per Day', Icons.today),
              const SizedBox(width: 8),
              _buildPriceTypeOption(
                'fixed_price',
                'Fixed Price',
                Icons.attach_money,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Budget
          const Text(
            'Budget Amount',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _budgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: _selectedPriceType == 'per_hour'
                  ? 'Enter amount'
                  : _selectedPriceType == 'per_day'
                  ? 'Enter amount'
                  : 'Enter amount',
              prefixText: '₱ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your budget';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Duration
          const Text(
            'Expected Duration',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Duration number field
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _durationNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter Duration',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter duration';
                    }
                    final number = int.tryParse(value.trim());
                    if (number == null || number <= 0) {
                      return 'Enter valid number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Duration type dropdown
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  value: _selectedDurationType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'hours', child: Text('Hours')),
                    DropdownMenuItem(value: 'days', child: Text('Days')),
                    DropdownMenuItem(value: 'weeks', child: Text('Weeks')),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Location (copied from address_confirm_screen.dart)
          const Text(
            'Job Location',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // City field (fixed to Olongapo)
          const Text(
            'City',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Olongapo City',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 16),

          // Barangay dropdown
          const Text(
            'Barangay',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          DropdownButtonFormField<String>(
            value: _selectedBarangay,
            decoration: InputDecoration(
              hintText: 'Select barangay',
              filled: true,
              fillColor: const Color(0xFFF5F8FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            items: _olongapoBarangays.map((String barangay) {
              return DropdownMenuItem<String>(
                value: barangay,
                child: Text(barangay),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {});
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select barangay';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Street address field
          const Text(
            'Street name, building, house no.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          TextFormField(
            controller: _streetAddressController,
            decoration: InputDecoration(
              hintText: 'Enter street name, building, house no.',
              filled: true,
              fillColor: const Color(0xFFF5F8FF),
              prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter street address';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Preferred Start Date
          const Text(
            'Preferred Start Date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() {});
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 12),
                  Text(
                    _preferredStartDate != null
                        ? '${_preferredStartDate!.day}/${_preferredStartDate!.month}/${_preferredStartDate!.year}'
                        : 'Select preferred start date',
                    style: TextStyle(
                      color: _preferredStartDate != null
                          ? Colors.black
                          : Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Contact Information
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _contactInfoController,
            decoration: InputDecoration(
              hintText: 'Phone number or email',
              prefixIcon: const Icon(Icons.contact_phone, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please provide contact information';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceTypeOption(String value, String label, IconData icon) {
    final isSelected = _selectedPriceType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey[300]!,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue : Colors.grey[600],
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidget() {
    try {
      // Calculate pricing based on current inputs
      final budget = double.tryParse(_budgetController.text.trim()) ?? 0;
      
      // Handle both integer and decimal inputs (e.g., "5" or "5.5")
      final durationText = _durationNumberController.text.trim();
      final durationValue = (double.tryParse(durationText) ?? 1.0).toInt();

      late final Map pricing;
      try {
        pricing = PricingService.calculateJobPrice(
          rateAmount: budget,
          priceType: _selectedPriceType,
          durationValue: durationValue,
          durationUnit: _selectedDurationType,
          isUrgent: _selectedUrgency == 'urgent',
        );
      } catch (e) {
        // If calculation fails, show basic info
        pricing = {
          'rateAmount': budget,
          'totalPrice': budget,
          'type': _selectedPriceType,
        };
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review Your Job Post',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please review all details before posting',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // ✅ NEW: Payment Summary Box (Highlighted)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💰 Payment Summary',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Rate display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rate:',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${PricingService.formatPrice(pricing['rateAmount'] ?? 0)} ${PricingService/* .get removed */PriceTypeDisplay(_selectedPriceType)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Duration display - show actual hours/days/weeks breakdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Duration:',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        _buildDurationBreakdown(pricing, durationValue),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  if (_selectedPriceType != 'fixed_price') ...[
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    // Show hours calculation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estimated Hours:',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${pricing['estimatedHours']?.toStringAsFixed(1) ?? '0'} hrs',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Note about 8-hour max per day
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '(Max 8 hrs per day - no overtime)',
                          style: TextStyle(
                            color: Colors.orange[600],
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Base price calculation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Base Price:',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          PricingService.formatPrice(pricing['basePrice'] ?? 0),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if ((pricing['urgentFee'] ?? 0) > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Urgent Fee (10%):',
                          style: TextStyle(
                            color: Colors.orange[600],
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          PricingService.formatPrice(pricing['urgentFee'] ?? 0),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.orange[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Budget:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          PricingService.formatPrice(
                            pricing['totalPrice'] ?? 0,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Job Summary /* payment_logic */
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    _jobTitleController.text.isEmpty
                        ? 'No Title'
                        : _jobTitleController.text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _selectedJobCategory.isEmpty
                              ? 'No Category'
                              : _selectedJobCategory,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getUrgencyColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _selectedUrgency.toUpperCase(),
                          style: TextStyle(
                            color: _getUrgencyColor(),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Description:',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _jobDescriptionController.text.isEmpty
                        ? 'No description provided'
                        : _jobDescriptionController.text,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),

                  // Location & Start Date Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location:',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _buildLocationDisplay(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (_preferredStartDate != null) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Starts:',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('MMM d').format(_preferredStartDate!),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  if (_requiredSkills.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Required Skills:',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _requiredSkills
                          .map(
                            (skill) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Text(
                                skill,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ✅ NEW: Important Notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Details',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedPriceType == 'fixed_price'
                              ? 'This is a fixed-price job. Payment is ${PricingService.formatPrice(pricing['totalPrice'] ?? 0)} total.'
                              : 'Payment is calculated as ${PricingService.formatPrice(pricing['rateAmount'] ?? 0)} ${PricingService/* .get removed */PriceTypeDisplay(_selectedPriceType)}, estimated ${PricingService.formatPrice(pricing['totalPrice'] ?? 0)} total for ${pricing['estimatedDays']?.toStringAsFixed(0) ?? '0'} days.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      );
    } catch (e) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text('Error: $e'),
        ),
      );
    }
  }

  Widget _buildWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: Button(
                onPressed: (_isPosting || _isNavigating || _isDisposed)
                    ? null
                    : () async {
                        if (_isPosting || _isNavigating || _isDisposed) return;

                        try {
                          setState(() {});

                          if (!mounted || _isDisposed) return;

                          setState(() {});

                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } catch (e) {
                          if (mounted && !_isDisposed) {
                            _showValidationError(
                              'Navigation error occurred. Please try again.',
                            );
                          }
                        } finally {
                          final timer = Timer(
                            const Duration(milliseconds: 300),
                            () {
                              if (mounted && !_isDisposed) {
                                setState(() {});
                              }
                            },
                          );
                          _activeTimers.add(timer);
                        }
                      },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Previous',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: Button(
              onPressed: (_isPosting || _isNavigating || _isDisposed)
                  ? null
                  : () async {
                      // Prevent multiple rapid taps
                      if (_isPosting || _isNavigating || _isDisposed) return;

                      try {
                        setState(() {});

                        _navigationDebouncer?.cancel();

                        if (_currentStep < 3) {
                          if (_validateCurrentStep() {
                            // Implementation removed
                          }

                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        } else {
                        }
                      } catch (e) {
                        if (mounted && !_isDisposed) {
                          _showValidationError(
                            'Navigation error occurred. Please try again.',
                          );
                        }
                      } finally {
                        _navigationDebouncer = Timer(
                          const Duration(milliseconds: 500),
                          () {
                            if (mounted && !_isDisposed) {
                              setState(() {});
                            }
                          },
                        );
                        _activeTimers.add(_navigationDebouncer!);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isPosting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _currentStep < 3 ? 'Next' : 'Post Job',
                      style: const TextStyle(
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

  bool _validateCurrentStep()  {
    // Implementation removed
  }
  }

  bool _isValidContact(String contact) {
    try {
      // Check if it's a valid email
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      if (emailRegex.hasMatch(contact)) return true;

      // Check if it's a valid phone number (Philippine format)
      final phoneRegex = RegExp(r'^(\+63|0)?[0-9]{10,11}$');
      final cleanPhone = contact.replaceAll(RegExp(r'[\s\-\(\)]'), '');
      if (phoneRegex.hasMatch(cleanPhone)) return true;

      return false;
    } catch (e) {
      return false;
    }
  }

  void _showValidationError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildWidget() {
    final skillsToShow = _showAllSkills
        ? _skillSuggestions
        : _skillSuggestions.take(_maxVisibleSkills).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skillsToShow.map((skill) {
            final isSelected = _requiredSkills.contains(skill);
            return GestureDetector(
              onTap: () {
                _debouncedSkillSelection(skill, isSelected);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.black,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        // Show more/less button
        if (_skillSuggestions.length > _maxVisibleSkills)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Center(
              child: Button(
                onPressed: () {
                  setState(() {});
                },
                child: Text(
                  _showAllSkills
                      ? 'Show Less Skills'
                      : 'Show More Skills (${_skillSuggestions.length - _maxVisibleSkills} more)',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _debouncedSkillSelection(String skill, bool isCurrentlySelected) {
    // Cancel previous timer if it exists
    _skillSelectionDebouncer?.cancel();

    // Immediately update UI for responsiveness
    if (!mounted) return;

    setState(() {
      if (isCurrentlySelected) {
        _requiredSkills.remove(skill);
      } else {
        // Limit skills to 3 maximum
        if (_requiredSkills.length < 3) {
          _requiredSkills.add(skill);
        } else {
          _showValidationError('Maximum 3 skills can be selected');
          return; // Don't set the debouncer if we hit the limit
        }
      }
    });

    // Set a debouncer for any additional processing if needed
    _skillSelectionDebouncer = Timer(const Duration(milliseconds: 100), () {
      // Any additional processing can go here
      if (mounted) {}
    });
  }

  Color _getUrgencyColor() {
    switch (_selectedUrgency) {
      case 'low':
        return Colors.green;
      case 'normal':
        return Colors.blue;
      case 'high':
        return Colors.orange;
      case 'urgent':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _buildLocationDisplay() {
    if (_selectedBarangay == null && _streetAddressController.text.isEmpty) {
      return 'No location set';
    }
    
    List<String> locationParts = [];
    if (_streetAddressController.text.isNotEmpty) {
      locationParts.add(_streetAddressController.text);
    }
    if (_selectedBarangay != null) {
      locationParts.add(_selectedBarangay!);
    }
    locationParts.add('Olongapo City'); // City is always Olongapo City
    
    return locationParts.join(', ');
  }

  Future<void> _postJob() async {
    // Final validation before posting
    if (!_validateAllSteps() {
      // Implementation removed
    }

    try {
      final currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (currentUser == null) {
        throw Exception('User authentication required. Please log in again.');
      }

      // Sanitize and prepare job data
      final sanitizedJobData = _prepareSanitizedJobData(currentUser);

      // Validate job data before submission
      _validateJobData(sanitizedJobData) {
        // Implementation removed
      }

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text(widget.editingJob != null 
                  ? 'Job updated successfully!' 
                  : 'Job posted successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Wait a moment before showing ad to ensure user sees success message
      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {} else {
          // If ad is not ready, navigate normally
          print('⚠️ Interstitial ad not ready, navigating without ad');
          Navigator.navigate(); // Return true to indicate success
        }
      }
    } on TimeoutException {
      _handlePostJobError(
        'Request timed out. Please check your internet connection and try again.',
      );
    } on FormatException catch (e) {
      _handlePostJobError('Invalid data format: ${e.message}');
    } on FirebaseException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'permission-denied':
          errorMessage =
              'You don\'t have permission to post jobs. Please contact support.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your internet connection and try again.';
          break;
        case 'unavailable':
          errorMessage =
              'Service temporarily unavailable. Please try again later.';
          break;
        case 'quota-exceeded':
          errorMessage = 'Service quota exceeded. Please try again later.';
          break;
        default:
          errorMessage = 'Failed to post job: ${e.message ?? 'Unknown error'}';
      }
      _handlePostJobError(errorMessage);
    } catch (e) {
      String errorMessage = 'An unexpected error occurred: ';
      if (e.toString().contains('connection')) {
        errorMessage =
            'Connection error. Please check your internet and try again.';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'Request timed out. Please try again.';
      } else {
        errorMessage += e.toString();
      }
      _handlePostJobError(errorMessage);
    } finally {
      if (mounted) {});
      }
    }
  }

  bool _validateAllSteps()  {
    // Implementation removed
  }
  }

  Map _prepareSanitizedJobData(User currentUser) {
    try {
      // Sanitize text inputs
      final title = _sanitizeText(_jobTitleController.text);
      final description = _sanitizeText(_jobDescriptionController.text);
      final contactInfo = _sanitizeText(_contactInfoController.text);
      
      // Prepare location data
      final location = {
        'city': 'Olongapo City',
        'barangay': _selectedBarangay ?? '',
        'streetAddress': _sanitizeText(_streetAddressController.text),
        'fullAddress': '${_sanitizeText(_streetAddressController.text)}, ${_selectedBarangay ?? ''}, Olongapo City',
      };
      
      // Prepare duration data
      final durationNumber = int.tryParse(_durationNumberController.text.trim()) ?? 0;
      final duration = '$durationNumber $_selectedDurationType';

      // Parse and validate budget
      final budget = double.tryParse(_budgetController.text.trim()) ?? 0;

      // Sanitize skills array
      final sanitizedSkills = _requiredSkills
          .map((skill) => _sanitizeText(skill))
          /* .where removed */((skill) => skill.isNotEmpty)
          .toList();

      final posterName = _sanitizeText(
        widget.data?['firstName'] ?? 
        currentUser.displayName?.split(' ').first ?? 
        'Anonymous',
      );
      final posterEmail = currentUser.email ?? widget.data?['email'] ?? '';

      Map pricing = {};
      List<Map> paymentMilestones = [];
      
      try {
        pricing = PricingService.calculateJobPrice(
          rateAmount: budget,
          priceType: _selectedPriceType,
          durationValue: durationNumber,
          durationUnit: _selectedDurationType,
          isUrgent: _selectedUrgency == 'urgent',
        );

        // Create payment milestones only if we have a preferred start date
        if (_preferredStartDate != null) {
          paymentMilestones = PricingService.createPaymentMilestones(
            totalPrice: pricing['totalPrice'] ?? budget,
            preferredStartDate: _preferredStartDate!,
            estimatedDays: (pricing['estimatedDays'] ?? durationNumber).toInt(),
          );
        }
      } catch (e) {
        // If pricing calculation fails, use budget as total and skip milestones
        pricing = {
          'type': _selectedPriceType,
          'rateAmount': budget,
          'totalPrice': budget,
          'basePrice': budget,
          'urgentFee': 0,
          'estimatedHours': 0,
          'estimatedDays': durationNumber,
        };
        paymentMilestones = [];
      }

      return {
        // Keep old fields for backward compatibility
        'title': title,
        'description': description,
        'category': _selectedJobCategory,
        'location': location,
        'budget': budget,
        'priceType': _selectedPriceType,
        'duration': duration.isNotEmpty ? duration : null,
        'urgency': _selectedUrgency,
        'requiredSkills': sanitizedSkills,
        'preferredStartDate': _preferredStartDate,
        'contactInfo': contactInfo,
        'postedBy': currentUser.uid,  // Use Firebase Auth UID
        'posterName': posterName,
        'posterEmail': posterEmail,
        'status': 'open',
        'createdAt': /* FieldValue removed */.server/* Timestamp removed */(),
        'updatedAt': /* FieldValue removed */.server/* Timestamp removed */(),
        'applicants': 0,
        'views': 0,
        'isActive': true,
        
        // ✅ NEW: Add calculated pricing object
        'pricing': {
          'type': pricing['type'],
          'rateAmount': pricing['rateAmount'],
          'duration': {
            'value': durationNumber,
            'unit': _selectedDurationType,
            'estimatedHours': pricing['estimatedHours'],
            'estimatedDays': pricing['estimatedDays'],
          },
          'basePrice': pricing['basePrice'],
          'urgentFee': pricing['urgentFee'],
          'totalPrice': pricing['totalPrice'],
        },
        
        // ✅ NEW: Add payment milestones
        'paymentMilestones': paymentMilestones,
      };
    } catch (e) {
      throw Exception('Failed to prepare job data: ${e.toString()}');
    }
  }

  String _sanitizeText(String input) {
    try {
      return input
          .trim()
          .replaceAll(
            RegExp(r'[<>"]'),
            '',
          ) // Remove potentially harmful characters
          .replaceAll(RegExp(r"'"), '') // Remove single quotes separately
          .replaceAll(RegExp(r'\s+'), ' '); // Normalize whitespace
    } catch (e) {
      return '';
    }
  }

  /// ✅ NEW: Build duration breakdown showing actual hours/days/weeks
  /// Shows how duration converts to hours for calculation purposes
  String _buildDurationBreakdown(Map pricing, int durationValue) {
    if (_selectedPriceType == 'fixed_price') {
      return 'N/A (fixed price)';
    }

    final estimatedHours = pricing['estimatedHours'] as num?;
    final estimatedDays = pricing['estimatedDays'] as num?;

    // Show breakdown based on selected unit
    switch (_selectedDurationType.toLowerCase()) {
      case 'hours':
        final days = durationValue / 8.0;
        if (durationValue <= 8) {
          return '$durationValue hrs';
        } else {
          // Show how many days this equals
          return '$durationValue hrs (≈ ${days.toStringAsFixed(1)} days @ 8 hrs/day)';
        }
      case 'days':
        return '$durationValue days (= ${(estimatedHours ?? 0).toStringAsFixed(0)} hrs @ 8 hrs/day)';
      case 'weeks':
        return '$durationValue weeks (= ${(estimatedDays ?? 0).toStringAsFixed(0)} days / ${(estimatedHours ?? 0).toStringAsFixed(0)} hrs)';
      default:
        return '${(estimatedDays ?? 0).toStringAsFixed(1)} days';
    }
  }

  void _validateJobData(Map jobData)  {
    // Implementation removed
  }
    if (jobData['description'].toString().isEmpty) {
      throw Exception('Job description cannot be empty');
    }
    if (jobData['location'] == null || (jobData['location'] as Map)['fullAddress'].toString().isEmpty) {
      throw Exception('Job location cannot be empty');
    }
    if (jobData['budget'] <= 0) {
      throw Exception('Budget must be greater than zero');
    }
    if (jobData['postedBy'].toString().isEmpty) {
      throw Exception('User authentication required');
    }
  }

  void _handlePostJobError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {
            if (!_isPosting) {
              _postJob();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Mark as disposed to prevent further operations
    _isDisposed = true;

    // Clean up resources to prevent memory leaks
    try {
      // Cancel all active timers
      for (final timer in _activeTimers) {
        timer.cancel();
      }
      _activeTimers.clear();

      // Cancel specific timers
      _skillSelectionDebouncer?.cancel();
      _navigationDebouncer?.cancel();

      // Dispose controllers
      _jobTitleController.dispose();
      _jobDescriptionController.dispose();
      _locationController.dispose();
      _budgetController.dispose();
      _durationController.dispose();
      _contactInfoController.dispose();
      _pageController.dispose();
      _durationNumberController.dispose();
      _streetAddressController.dispose();
      
      // Dispose AdMob interstitial ad
      AdMobService.disposeInterstitialAd();
    } catch (e) {
      // Ignore disposal errors but ensure they don't crash the app
    }
    super.dispose();
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
        currentIndex: 2, // Post tab is selected
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
              // Navigate to search screen
              Navigator.navigate() => SearchScreen(data: widget.data),
                ),
              );
              break;
            case 2:
              // Already on post job screen
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
  void deactivate() {
    _isNavigating = false;
    _navigationDebouncer?.cancel();
    super.deactivate();
  }
}

class BookingDetailsScreen extends StatefulWidget {
  final Map providerData;

  const BookingDetailsScreen({super.key, required this.providerData});

  @override
  State<Widget> createState() => _State();

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  String _selectedDuration = '1 hour';
  String? _selectedServiceType; // NEW: Service dropdown
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isUrgent = false;
  bool _provideTools = false;
  bool _cleanupRequired = true;
  bool _isLoadingBooking = false;

  final List<String> _timeSlotOptions = [
    '7:00 AM', '8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM',
    '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM',
  ];

  final List<String> _durationOptions = [
    '1 hour',
    '2 hours',
    '3 hours',
    '4 hours',
    'Half day (4 hours)',
    'Full day (8 hours)',
  ];
  
  List<String> get _availableServices {
    try {
      final providerDataObj = widget.providerData['serviceprovider'] ?? widget.providerData;
      final services = _getServiceProviderField(providerDataObj, 'services', 'specialties');
      if (services is List) {
        return services.cast<String>()/* .where removed */((s) => s.isNotEmpty).toList();
      }
      final profession = _getServiceProviderField(providerDataObj, 'profession');
      return profession != null ? [profession.toString()] : ['General Service'];
    } catch (e) {
      return ['General Service'];
    }
  }

  // ========== RESPONSIVE HELPERS ==========
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;

  double _getResponsivePadding(BuildContext context) {
    return _isMobile(context) ? 16.0 : 24.0;
  }

  double _getResponsiveFontSize(double baseSize, BuildContext context) {
    return _isMobile(context) ? baseSize : baseSize * 1.05;
  }

  EdgeInsets _getResponsiveMargin(BuildContext context) {
    final padding = _getResponsivePadding(context);
    return EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2);
  }

  @override
  void initState() {
    super.initState();
    if (_availableServices.isNotEmpty) {
      _selectedServiceType = _availableServices.first;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);
    final padding = _getResponsivePadding(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Colors.black,
            ),
          ),
          onPressed: () => Navigator.navigate(),
        ),
        title: Text(
          'Book Service',
          style: TextStyle(
            color: Colors.black,
            fontSize: _getResponsiveFontSize(20, context),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildServiceProviderInfoContainer(isMobile),
          Expanded(
            child: SingleChildScrollView(
              padding: _getResponsiveMargin(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('📅 Select Date', 'Choose your preferred date', context),
                  const SizedBox(height: 16),
                  _buildDateSelector(context),
                  SizedBox(height: padding),
                  _buildSectionHeader('🔧 Select Service', 'What service do you need?', context),
                  const SizedBox(height: 16),
                  _buildServiceDropdown(context),
                  SizedBox(height: padding),
                  _buildSectionHeader('⏰ Choose Time', 'Pick your preferred time slot', context),
                  const SizedBox(height: 16),
                  _buildTimeDropdown(context),
                  SizedBox(height: padding),
                  _buildSectionHeader('⏱️ Duration', 'How long do you need the service?', context),
                  const SizedBox(height: 16),
                  _buildDurationSelector(context),
                  SizedBox(height: padding),
                  _buildSectionHeader('📍 Work Location', 'Where should the work be done?', context),
                  const SizedBox(height: 16),
                  _buildLocationInput(context),
                  SizedBox(height: padding),
                  _buildSectionHeader('⚙️ Additional Options', 'Customize your service', context),
                  const SizedBox(height: 16),
                  _buildAdditionalOptions(context),
                  SizedBox(height: padding),
                  _buildSectionHeader('📝 Special Instructions', 'Any specific requirements?', context),
                  const SizedBox(height: 16),
                  _buildNotesInput(context),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBookingBar(context),
    );
  }

  Widget _buildServiceProviderInfoContainer(bool isMobile) {
    final providerDataObj = widget.providerData['serviceprovider'] ?? widget.providerData;
    final data = widget.providerData['user'] ?? providerDataObj;
    
    // Get real values with fallbacks
    final profileImageUrl = _getServiceProviderField(providerDataObj, 'profileImageUrl', 'photoURL') ?? 
                            _getServiceProviderField(data, 'profileImageUrl', 'photoURL');
    final firstName = _getServiceProviderField(providerDataObj, 'firstName') ?? 
                      _getServiceProviderField(data, 'firstName') ?? 'Professional';
    final lastName = _getServiceProviderField(providerDataObj, 'lastName') ?? 
                     _getServiceProviderField(data, 'lastName') ?? '';
    final rating = _getServiceProviderField(providerDataObj, 'rating') ?? 4.8;
    final totalReviews = _getServiceProviderField(providerDataObj, 'totalReviews', 'reviewCount') ?? 0;
    final hourlyRate = _getServiceProviderField(providerDataObj, 'hourlyRate') ?? 750;
    
    List<String> services = [];
    try {
      final servicesField = _getServiceProviderField(providerDataObj, 'services', 'specialties');
      if (servicesField is List) {
        services = servicesField.cast<String>()/* .where removed */((s) => s.isNotEmpty).toList();
      }
    } catch (e) {}
    
    final profession = services.isNotEmpty ? services.first : (_getServiceProviderField(providerDataObj, 'profession') ?? 'Worker');
    
    return Container(
      margin: EdgeInsets.all(isMobile ? 12 : 16),
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: isMobile ? 22 : 28,
            backgroundImage: profileImageUrl != null && profileImageUrl.toString().isNotEmpty
                ? NetworkImage(profileImageUrl.toString())
                : null,
            backgroundColor: const Color(0xFF1E40AF).withOpacity(0.1),
            child: profileImageUrl == null || profileImageUrl.toString().isEmpty
                ? SvgPicture.asset(
                    'assets/serviceprovider.svg',
                    width: isMobile ? 32 : 40,
                    height: isMobile ? 32 : 40,
                    fit: BoxFit.contain,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$firstName $lastName'.trim(),
                  style: TextStyle(
                    fontSize: isMobile ? 15 : 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 3),
                Text(
                  profession,
                  style: TextStyle(fontSize: isMobile ? 11 : 12, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 12),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        '${(rating is num ? rating : 4.8).toStringAsFixed(1)} ($totalReviews reviews)',
                        style: TextStyle(fontSize: isMobile ? 10 : 11, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 10, vertical: isMobile ? 4 : 5),
            decoration: BoxDecoration(
              color: const Color(0xFF1E40AF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              '₱${(hourlyRate is num ? hourlyRate : 750).toInt()}/hr',
              style: TextStyle(
                color: const Color(0xFF1E40AF),
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 11 : 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  dynamic _getServiceProviderField(dynamic data, String primaryKey, [String? fallbackKey]) {
    if (data == null) return null;
    
    try {
      // Try as Map first
      if (data is Map) {
        return data[primaryKey] ?? (fallbackKey != null ? data[fallbackKey] : null);
      }
      // Try as object
      final field = data.runtimeType.toString().contains('Data')
          ? (data as dynamic).toMap()[primaryKey]
          : null;
      return field ?? (fallbackKey != null && data is Map ? data[fallbackKey] : null);
    } catch (e) {
      return fallbackKey != null && data is Map ? data[fallbackKey] : null;
    }
  }

  // ========== RESPONSIVE SECTION HEADER ==========
  Widget _buildSectionHeader(String title, String subtitle, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: _getResponsiveFontSize(17, context),
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: _getResponsiveFontSize(13, context),
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ========== RESPONSIVE DATE SELECTOR ==========
  Widget _buildDateSelector(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Date',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(15, context),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              GestureDetector(
                onTap: () async {
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() => _selectedDate = picked);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text('Change',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? 11 : 12,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isMobile ? 12 : 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E40AF).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF1E40AF).withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.today, color: Color(0xFF1E40AF), size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(14, context),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E40AF),
                        ),
                      ),
                      Text(
                        _getWeekday(_selectedDate.weekday),
                        style: TextStyle(
                          fontSize: isMobile ? 11 : 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekday(int weekday) {
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return weekdays[weekday - 1];
  }

  Widget _buildServiceDropdown(BuildContext context) {
    final isMobile = _isMobile(context);
    
    // Fallback initialization if somehow not set
    if (_selectedServiceType == null && _availableServices.isNotEmpty) {
      _selectedServiceType = _availableServices.first;
    }

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedServiceType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: isMobile ? 12 : 14),
          hintText: 'Select service',
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF1E40AF), width: 2),
          ),
          prefixIcon: const Icon(Icons.build, color: Color(0xFF1E40AF)),
        ),
        items: _availableServices
            .map((service) => DropdownMenuItem(
                  value: service,
                  child: Text(service, style: const TextStyle(fontSize: 14)),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedServiceType = value);
          }
        },
      ),
    );
  }

  // ========== TIME DROPDOWN ==========
  Widget _buildTimeDropdown(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedTimeSlot,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: isMobile ? 12 : 14),
          hintText: 'Select time slot',
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF1E40AF), width: 2),
          ),
          prefixIcon: const Icon(Icons.access_time, color: Color(0xFF1E40AF)),
        ),
        items: _timeSlotOptions
            .map((time) => DropdownMenuItem(
                  value: time,
                  child: Text(time, style: const TextStyle(fontSize: 14)),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedTimeSlot = value);
          }
        },
      ),
    );
  }

  // ========== RESPONSIVE DURATION SELECTOR ==========
  Widget _buildDurationSelector(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Duration',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(15, context),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  _selectedDuration,
                  style: TextStyle(
                    color: const Color(0xFF1E40AF),
                    fontWeight: FontWeight.w600,
                    fontSize: isMobile ? 11 : 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: isMobile ? 6 : 8,
            runSpacing: isMobile ? 6 : 8,
            children: _durationOptions
                .map((duration) => GestureDetector(
                      onTap: () => setState(() => _selectedDuration = duration),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 10 : 12,
                          vertical: isMobile ? 8 : 10,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedDuration == duration
                              ? const Color(0xFF1E40AF)
                              : Colors.grey[50],
                          border: Border.all(
                            color: _selectedDuration == duration
                                ? const Color(0xFF1E40AF)
                                : Colors.grey[200]!,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          duration,
                          style: TextStyle(
                            fontSize: isMobile ? 11 : 12,
                            fontWeight: FontWeight.w500,
                            color:
                                _selectedDuration == duration ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ========== RESPONSIVE LOCATION INPUT ==========
  Widget _buildLocationInput(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFF1E40AF), size: 18),
              const SizedBox(width: 8),
              Text(
                'Work Data',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(15, context),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'Enter your complete address...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
              prefixIcon: const Icon(Icons.home_work, color: Color(0xFF1E40AF), size: 18),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF1E40AF), width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: isMobile ? 12 : 14),
            ),
            maxLines: 2,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ========== RESPONSIVE ADDITIONAL OPTIONS ==========
  Widget _buildAdditionalOptions(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildOptionTile(
            icon: Icons.flash_on,
            title: 'Urgent Service',
            subtitle: 'Need service ASAP (+₱100)',
            value: _isUrgent,
            onChanged: (val) => setState(() => _isUrgent = val),
            isMobile: isMobile,
          ),
          const Divider(height: 24),
          _buildOptionTile(
            icon: Icons.construction,
            title: 'Provide Tools',
            subtitle: 'Worker brings their own tools',
            value: _provideTools,
            onChanged: (val) => setState(() => _provideTools = val),
            isMobile: isMobile,
          ),
          const Divider(height: 24),
          _buildOptionTile(
            icon: Icons.cleaning_services,
            title: 'Cleanup Required',
            subtitle: 'Clean up after work completion',
            value: _cleanupRequired,
            onChanged: (val) => setState(() => _cleanupRequired = val),
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required bool isMobile,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E40AF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF1E40AF), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: isMobile ? 11 : 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF1E40AF),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }

  // ========== RESPONSIVE NOTES INPUT ==========
  Widget _buildNotesInput(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note, color: Color(0xFF1E40AF), size: 18),
              const SizedBox(width: 8),
              Text(
                'Additional Notes',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(15, context),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              hintText: 'Any specific requirements, materials needed, or special instructions...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF1E40AF), width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: isMobile ? 12 : 14),
            ),
            maxLines: 4,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ========== RESPONSIVE BOTTOM BOOKING BAR ==========
  Widget _buildBottomBookingBar(BuildContext context) {
    final isMobile = _isMobile(context);
    final hourlyRate = _getHourlyRateAsDouble();
    final duration = _getDurationHours(_selectedDuration);
    
    final providerDataObj = widget.providerData['serviceprovider'] ?? widget.providerData;
    final existingPricing = providerDataObj['pricing'];
    
    Map pricing;
    
    if (existingPricing != null && 
        existingPricing['totalPrice'] != null && 
        existingPricing['type'] != null) {
      // Use existing calculated pricing if available and matches our criteria
      pricing = Map.from(existingPricing);
      
      // Recalculate urgent fee if needed
      if (_isUrgent && (pricing['urgentFee'] == null || pricing['urgentFee'] == 0)) {
        final basePrice = pricing['basePrice'] ?? pricing['totalPrice'] ?? 0;
        final urgentFee = basePrice * 0.10; // 10% surcharge
        pricing['urgentFee'] = urgentFee;
        pricing['totalPrice'] = basePrice + urgentFee;
      } else if (!_isUrgent && pricing['urgentFee'] != null && pricing['urgentFee'] > 0) {
        // Remove urgent fee if not needed
        final basePrice = pricing['basePrice'] ?? (pricing['totalPrice'] - pricing['urgentFee']);
        pricing['urgentFee'] = 0;
        pricing['totalPrice'] = basePrice;
      }
    } else {
      pricing = PricingService.calculateJobPrice(
        rateAmount: hourlyRate,
        priceType: 'per_hour',
        durationValue: duration.round(),
        durationUnit: 'hours',
        isUrgent: _isUrgent,
      );
    }
    
    final basePrice = pricing['basePrice']?.round() ?? 0;
    final urgentFee = pricing['urgentFee']?.round() ?? 0;
    final totalPrice = pricing['totalPrice']?.round() ?? 0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getResponsivePadding(context),
        vertical: isMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 12 : 14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Base Rate',
                    '₱${basePrice.toString()}',
                    isMobile,
                  ),
                  const SizedBox(height: 8),
                  if (_isUrgent) ...[
                    _buildDetailRow('Urgent Fee', '₱100', isMobile),
                    const SizedBox(height: 8),
                  ],
                  Divider(height: isMobile ? 16 : 20, color: Colors.grey[300]),
                  _buildDetailRow(
                    'Total',
                    '₱${totalPrice.toString()}',
                    isMobile,
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: isMobile ? 48 : 52,
              child: Button(
                onPressed: _canProceedBooking() && !_isLoadingBooking
                    ? () => _bookService()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E40AF),
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoadingBooking)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    else
                      const Icon(Icons.check_circle_outline, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      _isLoadingBooking ? 'Data...' : 'Book Now',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isMobile, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 12 : 13,
            color: Colors.grey[700],
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isMobile ? 12 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? const Color(0xFF1E40AF) : Colors.black87,
          ),
        ),
      ],
    );
  }

  bool _canProceedBooking() {
    return _selectedTimeSlot != null && 
           _locationController.text.isNotEmpty &&
           _selectedServiceType != null;
  }

  double _getDurationHours(String duration) {
    switch (duration) {
      case '1 hour':
        return 1;
      case '2 hours':
        return 2;
      case '3 hours':
        return 3;
      case '4 hours':
        return 4;
      case 'Half day (4 hours)':
        return 4;
      case 'Full day (8 hours)':
        return 8;
      default:
        return 1;
    }
  }

  double _getHourlyRateAsDouble() {
    // First check if there's calculated pricing data
    final providerDataObj = widget.providerData['serviceprovider'] ?? widget.providerData;
    
    if (providerDataObj['pricing'] != null) {
      final pricing = providerDataObj['pricing'];
      if (pricing['rateAmount'] != null) {
        final rateAmount = pricing['rateAmount'];
        if (rateAmount is String) {
          return double.tryParse(rateAmount) ?? 750.0;
        } else if (rateAmount is num) {
          return rateAmount.toDouble();
        }
      }
    }
    
    final hourlyRateValue = _getServiceProviderField(providerDataObj, 'hourlyRate') ?? 
                           widget.providerData['hourlyRate'] ?? 750;
    if (hourlyRateValue is String) {
      return double.tryParse(hourlyRateValue) ?? 750.0;
    } else if (hourlyRateValue is num) {
      return hourlyRateValue.toDouble();
    }
    return 750.0;
  }

  Future<void> _bookService() async  {
    // Implementation removed
  }
  }

  void _showBookingConfirmation(String bookingId, int totalPrice) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Data Confirmed!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your service has been successfully booked',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('Data ID', bookingId, false),
                      const SizedBox(height: 10),
                      _buildDetailRow('Date & Time',
                          '${_selectedDate.day}/${_selectedDate.month} at $_selectedTimeSlot', false),
                      const SizedBox(height: 10),
                      _buildDetailRow('Total Amount', '₱$totalPrice', false, isBold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Button(
                    onPressed: () {
                      Navigator.navigate(); // Close dialog
                      Navigator.navigate(); // Go back to previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Back to Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text('Data Failed', style: TextStyle(color: Colors.red)),
            ],
          ),
          content: Text(message, style: const TextStyle(fontSize: 14)),
          actions: [
            Button(
              onPressed: () => Navigator.navigate(),
              child: const Text('OK', style: TextStyle(color: Color(0xFF1E40AF))),
            ),
          ],
        );
      },
    );
  }
}

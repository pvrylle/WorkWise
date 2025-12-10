/// Responsive helper class for adaptive UI


class CustomerProfileScreen extends StatefulWidget {
  final Map? data;
  final bool showJobPostings; // If true, automatically show the job postings modal

  const CustomerProfileScreen({
    super.key, 
    this.data,
    this.showJobPostings = false,
  });

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final // Image utility removed _imagePicker = // Image utility removed();

  List<Map> _userJobs = [];
  List _groupedJobs = []; // Grouped jobs for better UI
  List<Map> _userReviews = [];
  List<Map> _pendingApprovals = [];
  bool _isLoadingJobs = true;
  bool _isLoadingReviews = true;
  bool _isLoadingApprovals = true;
  Map<String, bool> _jobReviewStatus = {}; // Track which jobs have been reviewed
  bool _showingPendingApprovals = false; // Track which tab is selected

  // Controllers for editable fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  bool _isEditingPersonalInfo = false;

  @override
  void initState() {
    super.initState();

    // Delay data loading to prevent blocking UI thread
    // Post-frame callback((_) {
      if (mounted) {}
          });
        }
      }
    });
  }

  // Safe data loading with error boundaries
  Future<void> _loadUserDataSafely() async {
    try {
      if (mounted) {}
      if (mounted) {}
      if (mounted) {}
      
    } catch (e) {
      if (mounted) {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile data. Please try again.'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _loadUserDataSafely,
            ),
          ),
        );
      }
    }
  }

  // Add comprehensive refresh method
  Future<void> _refreshUserData() async {
    try {
      // Show loading indicator
      if (mounted) {});
      }
      
      // Force reload all data
      if (mounted) {}
      if (mounted) {}
      if (mounted) {}
    } catch (e) {
      if (mounted) {}
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    // Safety check to prevent crashes
    if (widget.data == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: const Color(0xFF1E40AF),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            'No user data available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // Initialize responsive helper
    final responsive = ResponsiveHelper(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: responsive.titleFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: responsive.iconSize),
          onPressed: () => Navigator.navigate(),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.horizontalPadding,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Profile Header
            Center(
              child: Column(
                children: [
                  Stack(
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
                            child: (() {
                              final photoURL = widget.data?['photoURL'] as String?;
                              if (photoURL != null && photoURL.isNotEmpty && photoURL != 'null' && photoURL != 'No image') {
                                return Image.network(
                                  photoURL,
                                  width: 122,
                                  height: 122,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // If network image fails, show /* payment_logic */ fallback
                                    return Image.asset(
                                      'assets//* payment_logic */.png',
                                      width: 122,
                                      height: 122,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                );
                              } else {
                                return Image.asset(
                                  'assets//* payment_logic */.png',
                                  width: 122,
                                  height: 122,
                                  fit: BoxFit.cover,
                                );
                              }
                            })()
                          ),
                        ),
                      ),
                      
                      // Verified Badge
                      if (widget.data?['isEmailVerified'] == true)
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
                  
                  const SizedBox(height: 16),
                  
                  // Name and Role
                  Column(
                    children: [
                      Text(
                        '${widget.data?['firstName'] ?? ''} ${widget.data?['lastName'] ?? ''}'.trim().isNotEmpty
                            ? '${widget.data?['firstName'] ?? ''} ${widget.data?['lastName'] ?? ''}'.trim()
                            : widget.data?['displayName'] ?? 'User',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SERVICE CUSTOMER',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Account Section
            _buildAccountSection(),

            SizedBox(height: responsive.verticalSpacing * 0.75),

            // Privacy & Security Section
            _buildPrivacySection(),

            SizedBox(height: responsive.verticalSpacing * 0.75),

            // Support Section
            _buildSupportSection(),

            SizedBox(height: responsive.verticalSpacing * 0.75),

            // About Section
            _buildAboutSection(),

            SizedBox(height: responsive.verticalSpacing),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: responsive.buttonHeight,
              child: Button(
                onPressed: _showLogoutDialog,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: responsive.bodyFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }



  // Account Section
  Widget _buildWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Account'),
        _buildMenuItem(
          icon: Icons.person_outline,
          title: 'Personal Information',
          subtitle: 'View and edit your profile',
          onTap: _showPersonalInfo,
        ),
        _buildMenuItem(
          icon: Icons.work_outline,
          title: 'My Job Postings',
          subtitle: 'Manage your job requests',
          onTap: _showJobPostings,
          trailing: _isLoadingJobs 
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : _userJobs.isNotEmpty 
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_groupedJobs.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
        _buildMenuItem(
          icon: Icons.payment,
          title: 'Payment History',
          subtitle: 'View all your transactions',
          onTap: () {
            Navigator.navigate() => PaymentHistoryScreen(data: widget.data),
              ),
            );
          },
        ),
        _buildMenuItem(
          icon: Icons.star_outline,
          title: 'My Reviews',
          subtitle: 'View reviews you\'ve given',
          onTap: _showMyReviews,
          trailing: _isLoadingReviews 
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show pending reviews badge
                  if (_getPendingReviewsCount() > 0)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_getPendingReviewsCount()} pending',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  // Show total reviews badge
                  if (_userReviews.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_userReviews.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
        ),
      ],
    );
  }

  // Privacy & Security Section
  Widget _buildWidget() {
    // Hide entire section for Google/OAuth accounts
    if (!_isEmailPasswordAccount() {
      // Implementation removed
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Privacy & Security'),
        // Show Change Password only for email/password accounts
        _buildMenuItem(
          icon: Icons.lock_outline,
          title: 'Change Password',
          subtitle: 'Update your account password',
          onTap: _showChangePasswordDialog,
        ),
      ],
    );
  }

  // Support Section
  Widget _buildWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Support'),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Help Center',
          subtitle: 'Get help and FAQs',
          onTap: _showHelpCenter,
        ),
      ],
    );
  }

  // About Section
  Widget _buildWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('About'),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: 'About AppName',
          subtitle: 'Learn more about our platform',
          onTap: () => ProfileSectionRedesign.showAbout(context),
        ),
        _buildMenuItem(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          subtitle: 'Read our terms',
          onTap: _showTermsOfService,
        ),
        _buildMenuItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          onTap: _showPrivacyPolicy,
        ),
      ],
    );
  }

  // General Section (kept for backward compatibility)
  Widget _buildWidget() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Manage notification preferences',
          onTap: _showNotificationSettings,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
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
            if (trailing != null)
              trailing
            else
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Sign Out Button
  Widget _buildWidget() {
    return Center(
      child: TextButton.icon(
        onPressed: _showLogoutDialog,
        icon: const Icon(Icons.logout, color: Colors.red, size: 20),
        label: const Text(
          'Sign Out',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  // Personal Info Modal
  void _showPersonalInfo() {
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
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Modern handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Modern Header with gradient background
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
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Title
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
                
                // Action buttons
                if (_isEditingPersonalInfo) ...[
                  // Cancel button
                  Material(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        _cancelEditingPersonalInfo();
                        setModalState(() {});
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Save button
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () async {
                        await _savePersonalInfo() {
                          // Implementation removed
                        }
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Color(0xFF1E40AF),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else
                  // Edit button
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        _startEditingPersonalInfo();
                        setModalState(() {});
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.edit_outlined,
                              color: Color(0xFF1E40AF),
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: Color(0xFF1E40AF),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildPersonalInfoSection(),
                  const SizedBox(height: 24),
                ],
              ),
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: (() {
                      final photoURL = widget.data?['photoURL'] as String?;
                      if (photoURL != null && photoURL.isNotEmpty && photoURL != 'null' && photoURL != 'No image') {
                        return Image.network(
                          photoURL,
                          width: 106,
                          height: 106,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // If network image fails, show /* payment_logic */ fallback
                            return Image.asset(
                              'assets//* payment_logic */.png',
                              width: 106,
                              height: 106,
                              fit: BoxFit.cover,
                            );
                          },
                        );
                      } else {
                        return Image.asset(
                          'assets//* payment_logic */.png',
                          width: 106,
                          height: 106,
                          fit: BoxFit.cover,
                        );
                      }
                    })()
                  ),
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
  
  // Show change password dialog
  
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
  
  // Modern section label (keep for compatibility)
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF6B7280),
        letterSpacing: 0.5,
      ),
    );
  }
  
  // Enhanced info /* payment_logic */ with better visuals and interactions
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
  
  // Modern info /* payment_logic */ with icon and better styling
  Widget _buildModernInfoContainer({
    required IconData icon,
    required String label,
    required String value,
    required TextEditingController? controller,
    required bool isEditable,
    int maxLines = 1,
    Color? statusColor,
  }) {
    final displayValue = value.isEmpty ? 'Not set' : value;
    final isEmptyValue = value.isEmpty;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isEditingPersonalInfo && isEditable
              ? const Color(0xFF1E40AF).withOpacity(0.3)
              : Colors.grey[200]!,
          width: _isEditingPersonalInfo && isEditable ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor?.withOpacity(0.1) ?? const Color(0xFF1E40AF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: statusColor ?? const Color(0xFF1E40AF),
              size: 22,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    letterSpacing: 0.2,
                  ),
                ),
                
                const SizedBox(height: 6),
                
                // Value or TextField
                if (_isEditingPersonalInfo && isEditable && controller != null)
                  TextField(
                    controller: controller,
                    maxLines: maxLines,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      hintText: 'Enter $label',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF1E40AF),
                          width: 2,
                        ),
                      ),
                    ),
                  )
                else
                  Text(
                    displayValue,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isEmptyValue ? Colors.grey[400] : Colors.black87,
                      height: 1.4,
                    ),
                  ),
              ],
            ),
          ),
          
          // Edit indicator
          if (!_isEditingPersonalInfo && isEditable)
            Icon(
              Icons.edit_outlined,
              size: 18,
              color: Colors.grey[400],
            ),
          
          // Status badge for non-editable fields with status
          if (!isEditable && statusColor != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                widget.data?['isVerified'] == true
                    ? Icons.check_circle
                    : Icons.pending,
                size: 16,
                color: statusColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableInfoContainer(
    String label,
    String value,
    TextEditingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: _isEditingPersonalInfo
                ? TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Personal Info Editing Methods
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

  // Job Postings Modal
  void _showJobPostings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildJobPostingsModal(),
    );
  }

  Widget _buildWidget() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter modalSetState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E40AF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.work_outline,
                        color: const Color(0xFF1E40AF),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'My Job Postings',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.navigate(),
                      icon: const Icon(Icons.close),
                      tooltip: 'Close',
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          modalSetState(() {
                            _showingPendingApprovals = false;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          child: _buildJobTabWithoutCount(
                            'Regular Jobs',
                            !_showingPendingApprovals, // isSelected
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          modalSetState(() {
                            _showingPendingApprovals = true;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          child: _buildJobTab(
                            'Pending Approvals',
                            _pendingApprovals.length,
                            _showingPendingApprovals, // isSelected
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Content - Using AnimatedSwitcher for smooth transitions
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: _showingPendingApprovals
                      ? (_isLoadingApprovals
                          ? const Center(
                              key: ValueKey('loading_approvals'),
                              child: CircularProgressIndicator()
                            )
                          : _pendingApprovals.isEmpty
                              ? RefreshIndicator(
                                  onRefresh: () async {
                                  },
                                  child: SingleChildScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    child: Container(
                                      key: const ValueKey('empty_approvals'),
                                      height: MediaQuery.of(context).size.height * 0.5,
                                      child: _buildEmptyPendingApprovalsState(),
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: () async {
                                  },
                                  child: ListView.builder(
                                    key: const ValueKey('approvals_list'),
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    itemCount: _pendingApprovals.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: _buildPendingApprovalContainer(_pendingApprovals[index]),
                                      );
                                    },
                                  ),
                                ))
                      : (_isLoadingJobs
                          ? const Center(
                              key: ValueKey('loading_jobs'),
                              child: CircularProgressIndicator()
                            )
                          : _groupedJobs.isEmpty
                              ? RefreshIndicator(
                                  onRefresh: () async {
                                    // Auto-fix after refresh
                                  },
                                  child: SingleChildScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    child: Container(
                                      key: const ValueKey('empty_jobs'),
                                      height: MediaQuery.of(context).size.height * 0.5,
                                      child: _buildEmptyJobsState(),
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    // Auto-fix after refresh
                                  },
                                  child: ListView.builder(
                                    key: const ValueKey('jobs_list'),
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    itemCount: _groupedJobs.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: _buildGroupedJobContainer(_groupedJobs[index], modalSetState),
                                      );
                                    },
                                  ),
                                ))
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Reviews Modal
  void _showMyReviews() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildReviewsModal(),
    );
  }

  Widget _buildWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  'My Reviews',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.navigate(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoadingReviews
                ? const Center(child: CircularProgressIndicator())
                : _userReviews.isEmpty
                ? _buildEmptyReviewsState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _userReviews.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildReviewContainer(_userReviews[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade600, Colors.blue.shade800],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60), // Space for app bar
          // Profile Image
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: (() {
                    final photoURL = widget.data?['photoURL'] as String?;
                    if (photoURL != null && photoURL.isNotEmpty && photoURL != 'null' && photoURL != 'No image') {
                      return Image.network(
                        photoURL,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // If network image fails, show /* payment_logic */ fallback
                          return Image.asset(
                            'assets//* payment_logic */.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          );
                        },
                      );
                    } else {
                      return Image.asset(
                        'assets//* payment_logic */.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      );
                    }
                  })()
                ),
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _changeProfilePicture,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            _getFullName(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Job /* payment_logic */',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Job Groups', _groupedJobs.length.toString()),
              _buildStatItem('Reviews', _userReviews.length.toString()),
              _buildStatItem('Member Since', _getMemberSince()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }

  Widget _buildWidget() {
    // Debug data structure
    debugPrint('📱 Personal Info - data keys: ${widget.data?.keys.toList()}');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection('Personal Information', [
            _buildInfoRow(Icons.person, 'Full Name', _getFullName()),
            _buildInfoRow(Icons.email, 'Email', _getSafeStringField('email')),
            _buildInfoRow(
              Icons.phone,
              'Phone',
              _getSafeStringField('phoneNumber').isEmpty 
                  ? _getSafeStringField('phone') 
                  : _getSafeStringField('phoneNumber'),
            ),
            _buildInfoRow(
              Icons.location_on,
              'Data',
              _getSafeStringField('address').isEmpty 
                  ? _getSafeStringField('location') 
                  : _getSafeStringField('address'),
            ),
            _buildInfoRow(
              Icons.cake,
              'Date of Birth',
              _getSafeStringField('dateOfBirth').isEmpty 
                  ? _getSafeStringField('birthDate') 
                  : _getSafeStringField('dateOfBirth'),
            ),
            // Add a prominent edit button inside the section as well
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _editProfile();
                },
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ]),

          const SizedBox(height: 24),

          _buildInfoSection('About Me', [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.data?['bio'] ??
                    'No bio available. Edit your profile to add a bio.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ]),

          const SizedBox(height: 24),

          _buildInfoSection('Account Information', [
            _buildInfoRow(
              Icons.verified_user,
              'Account Status',
              widget.data?['isVerified'] == true
                  ? 'Verified'
                  : 'Not Verified',
            ),
            _buildInfoRow(Icons.security, 'Member Since', _getMemberSince()),
            _buildInfoRow(
              Icons.star,
              'Rating',
              '${widget.data?['rating']?.toStringAsFixed(1) ?? '0.0'} stars',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Jobs Summary
          Row(
            children: [
              Expanded(
                child: _buildJobStatContainer(
                  'Total Jobs',
                  _groupedJobs.length.toString(),
                  Colors.blue,
                  Icons.work,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildJobStatContainer(
                  'Active Jobs',
                  _userJobs
                      /* .where removed */((job) => job['status'] == 'active')
                      .length
                      .toString(),
                  Colors.green,
                  Icons.trending_up,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Jobs List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Job Postings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Navigate to post job screen
                  Navigator.pushNamed(context, '/post-job');
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Post Job'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (_isLoadingJobs || _isLoadingApprovals)
            const Center(child: CircularProgressIndicator())
          else if (!_showingPendingApprovals) 
            // Regular Jobs Tab
            _userJobs/* .where removed */((job) => job['status'] != 'pending_approval').isEmpty
                ? _buildEmptyJobsState()
                : Column(
                    children: _groupedJobs
                        .map((jobGroup) => _buildGroupedJobContainer(jobGroup, null))
                        .toList(),
                  )
          else 
            // Pending Approvals Tab
            _pendingApprovals.isEmpty
                ? _buildEmptyPendingApprovalsState()
                : Column(
                    children: _pendingApprovals
                        .map((approval) => _buildPendingApprovalContainer(approval))
                        .toList(),
                  ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviews Summary
          Container(
            padding: const EdgeInsets.all(20),
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.star, color: Colors.orange, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.data?['rating']?.toStringAsFixed(1) ?? '0.0'}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        '${_userReviews.length} reviews',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Recent Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 16),

          if (_isLoadingReviews)
            const Center(child: CircularProgressIndicator())
          else if (_userReviews.isEmpty)
            _buildEmptyReviewsState()
          else
            ..._userReviews.map((review) => _buildReviewContainer(review)),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings & Support',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 24),

          // Settings Options
          _buildSettingsSection('Account', [
            _buildSettingsTile(
              Icons.edit,
              'Edit Profile',
              'Update your personal information',
              () => _editProfile(),
            ),
            _buildSettingsTile(
              Icons.lock_outline,
              'Change Password',
              'Update your account password',
              () => _showChangePasswordDialog(),
            ),
          ]),

          const SizedBox(height: 24),

          _buildSettingsSection('Notifications', [
            _buildSettingsTile(
              Icons.notifications_active,
              'Notification Preferences',
              'Manage email and push notifications',
              () => _showNotificationSettings(),
            ),
          ]),

          const SizedBox(height: 24),

          _buildSettingsSection('Support & Feedback', [
            _buildSettingsTile(
              Icons.help_center_outlined,
              'Help Center',
              'Get answers to common questions',
              () => _showHelpCenter(),
            ),
            _buildSettingsTile(
              Icons.feedback_outlined,
              'Send Feedback',
              'Share your thoughts and suggestions',
              () => _showFeedbackDialog(),
            ),
            _buildSettingsTile(
              Icons.report_problem_outlined,
              'Report a Problem',
              'Report bugs or technical issues',
              () => _showReportProblemDialog(),
            ),
          ]),

          const SizedBox(height: 24),

          _buildSettingsSection('Legal', [
            _buildSettingsTile(
              Icons.description,
              'Terms of Service',
              'Read our terms and conditions',
              () => _showTermsOfService(),
            ),
            _buildSettingsTile(
              Icons.privacy_tip,
              'Privacy Policy',
              'Understand how we protect your data',
              () => _showPrivacyPolicy(),
            ),
          ]),

          const SizedBox(height: 32),

          // Logout Button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: TextButton.icon(
              onPressed: _showLogoutDialog,
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // Add edit button only for Personal Information section
              if (title == 'Personal Information')
                GestureDetector(
                  onTap: () {
                    _editProfile();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.blue[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobStatContainer(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPendingApprovalContainer(Map approval) {
    final String title = approval['title'] ?? 'Job Request';
    final String description = approval['description'] ?? '';
      // ✅ Use calculated totalPrice from pricing if available, otherwise fallback to budget
    final dynamic budget = approval['pricing'] != null && approval['pricing']['totalPrice'] != null
        ? approval['pricing']['totalPrice']
        : approval['budget'] ?? 0;
    final serviceprovider = approval['interestedServiceProvider'];
    final String serviceproviderName = serviceprovider?['serviceproviderName'] ?? 'Unknown Data';
    final double serviceproviderRating = (serviceprovider?['serviceproviderRating'] as num?)?.toDouble() ?? 0.0;
    final String createdAt = _formatDate(approval['createdAt']);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with pending badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.pending_actions,
                      size: 16,
                      color: Colors.orange[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'PENDING APPROVAL',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                createdAt,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Job Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          if (description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: 12),

          Row(
            children: [
              ClipOval(
                child: (() {
                  final photoURL = serviceprovider?['photoURL'] ?? serviceprovider?['serviceproviderAvatar'];
                  if (photoURL != null && photoURL.toString().isNotEmpty && photoURL.toString() != 'null' && photoURL.toString() != 'No image') {
                    return Image.network(
                      photoURL.toString(),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/worker.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  } else {
                    return Image.asset(
                      'assets/worker.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    );
                  }
                })()
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceproviderName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (serviceproviderRating > 0)
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < serviceproviderRating.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 14,
                              color: Colors.amber,
                            );
                          }),
                          const SizedBox(width: 4),
                          Text(
                            serviceproviderRating.toStringAsFixed(1),
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
              if (budget > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '₱$budget',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: Button(
                  onPressed: () => _approveSpecialRequest(
                    approval['id'],
                    approval,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Approve',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Button(
                  onPressed: () => _declineSpecialRequest(
                    approval['id'],
                    {
                      'name': serviceproviderName,
                      'approvalId': approval['id'],
                    },
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedJobContainer(Data jobGroup, [StateSetter? modalSetState]) {
    final primaryJob = jobGroup.primaryJob;
    final String jobTitle = primaryJob['title'] ?? 'Untitled Job';
    final String description = primaryJob['description']?.toString() ?? 'No description';
    final String location = _formatLocation(primaryJob['location']) ?? 'No location';
    // ✅ Use calculated total price from pricing object if available, otherwise raw budget
    final dynamic budget = primaryJob['pricing'] != null && primaryJob['pricing']['totalPrice'] != null
        ? primaryJob['pricing']['totalPrice']
        : primaryJob['budget'];
    final String postedDate = _formatDate(primaryJob['createdAt']);
    final String source = primaryJob['source'] ?? 'jobs';
    final List<String> statuses = jobGroup.allStatuses;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with source icon and entry count
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Source icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    source == 'jobs' ? Icons.work_outline : Icons.book_online,
                    color: const Color(0xFF1E40AF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        source == 'jobs' ? 'Job Post' : 'Service Data',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Multiple entries badge
                if (jobGroup.hasMultipleJobs)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF2563EB).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.layers,
                          size: 14,
                          color: const Color(0xFF2563EB),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${jobGroup.jobs.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badges row
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: statuses.map((status) {
                    return _buildCompactStatusChip(status);
                  }).toList(),
                ),
                
                const SizedBox(height: 12),
                
                // Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 16),
                
                // Info row (location, date, budget)
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    // Location
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.4,
                          ),
                          child: Text(
                            location,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    // Date
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          postedDate,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // Budget (if available)
                if (budget != null && budget > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF059669).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.payments_outlined,
                          size: 16,
                          color: Color(0xFF059669),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Budget: ₱$budget',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Expandable history section (only if multiple jobs)
          if (jobGroup.hasMultipleJobs) ...[
            Material(
              color: Colors.grey[50],
              child: InkWell(
                onTap: () {
                  if (modalSetState != null) {
                    modalSetState(() {
                      jobGroup.isExpanded = !jobGroup.isExpanded;
                    });
                  } else {
                    setState(() {});
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        jobGroup.isExpanded 
                          ? Icons.keyboard_arrow_up 
                          : Icons.keyboard_arrow_down,
                        color: const Color(0xFF2563EB),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          jobGroup.isExpanded 
                            ? 'Hide Timeline' 
                            : 'View Timeline (${jobGroup.jobs.length} entries)',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.history,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Expanded history timeline
            if (jobGroup.isExpanded)
              _buildJobHistory(jobGroup),
          ],
          
          // Action buttons footer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Edit button (only for active/open jobs)
                if (statuses.any((s) => ['active', 'open'].contains(s.toLowerCase())))
                  _buildJobActionButton(
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    color: const Color(0xFF2563EB),
                    onPressed: () => _editJob(primaryJob, modalSetState),
                  ),
                
                // Spacing between buttons
                if (statuses.any((s) => ['active', 'open'].contains(s.toLowerCase())))
                  const SizedBox(width: 8),
                
                // Review button (only for completed jobs without review)
                if (_hasCompletedStatus(statuses) && !_hasJobBeenReviewed(primaryJob)) ...[
                  _buildJobActionButton(
                    icon: Icons.star_border,
                    label: 'Review',
                    color: const Color(0xFFD97706),
                    onPressed: () => _showReviewDialog(primaryJob),
                  ),
                  const SizedBox(width: 8),
                ],
                
                // Delete button (always available)
                _buildJobActionButton(
                  icon: Icons/* .delete removed */_outline,
                  label: 'Delete',
                  color: const Color(0xFFDC2626),
                  onPressed: () => _deleteJob(primaryJob, modalSetState),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Compact status chip for grouped cards
  Widget _buildCompactStatusChip(String status) {
    Color color;
    Color bgColor;
    IconData icon;
    String label;
    
    switch (status.toLowerCase()) {
      case 'completed':
        color = const Color(0xFF059669);
        bgColor = const Color(0xFFD1FAE5);
        icon = Icons.check_circle;
        label = 'Completed';
        break;
      case 'active':
      case 'open':
        color = const Color(0xFF2563EB);
        bgColor = const Color(0xFFDCEBFF);
        icon = Icons.schedule;
        label = 'Active';
        break;
      case 'in_progress':
        color = const Color(0xFFD97706);
        bgColor = const Color(0xFFFEF3C7);
        icon = Icons.work;
        label = 'In Progress';
        break;
      case 'assigned':
        color = const Color(0xFF7C3AED);
        bgColor = const Color(0xFFEDE9FE);
        icon = Icons.person;
        label = 'Assigned';
        break;
      case 'cancelled':
      case 'paused':
        color = const Color(0xFFDC2626);
        bgColor = const Color(0xFFFFE4E6);
        icon = Icons.cancel;
        label = 'Cancelled';
        break;
      default:
        color = const Color(0xFF6B7280);
        bgColor = const Color(0xFFF3F4F6);
        icon = Icons.help_outline;
        label = status.toUpperCase();
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    MaterialColor color;
    IconData icon;
    String displayText;

    switch (status.toLowerCase()) {
      case 'active':
      case 'open':
        color = Colors.blue;
        icon = Icons.radio_button_checked;
        displayText = 'Active';
        break;
      case 'completed':
        color = Colors.green;
        icon = Icons.check_circle;
        displayText = 'Completed';
        break;
      case 'assigned':
        color = Colors.purple;
        icon = Icons.person;
        displayText = 'Assigned';
        break;
      case 'in_progress':
        color = Colors.orange;
        icon = Icons.hourglass_empty;
        displayText = 'In Progress';
        break;
      case 'paused':
        color = Colors.amber;
        icon = Icons.pause_circle;
        displayText = 'Paused';
        break;
      case 'cancelled':
        color = Colors.red;
        icon = Icons.cancel;
        displayText = 'Cancelled';
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
        displayText = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color[600]),
          const SizedBox(width: 4),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 12,
              color: color[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobHistory(Data jobGroup) {
    // Sort jobs by creation date
    final sortedJobs = List<Map>.from(jobGroup.jobs);
    sortedJobs.sort((a, b) {
      final aTime = a['createdAt'];
      final bTime = b['createdAt'];
      
      if (aTime is /* Timestamp removed */ && bTime is /* Timestamp removed */) {
        return bTime.compareTo(aTime); // Newest first
      }
      return 0;
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          // Timeline header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.timeline, color: Colors.blue.shade600, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Job Timeline',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
          // Timeline entries
          ...sortedJobs.asMap().entries.map((entry) {
            final index = entry.key;
            final job = entry.value;
            final isLast = index == sortedJobs.length - 1;
            
            return _buildTimelineEntry(job, !isLast);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineEntry(Map job, bool showConnector) {
    final String status = job['status']?.toString().toLowerCase() ?? 'unknown';
    final String source = job['source']?.toString() ?? 'unknown';
    
    MaterialColor statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'active':
      case 'open':
        statusColor = Colors.blue;
        statusIcon = Icons.radio_button_checked;
        break;
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.circle;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: statusColor[100],
                  border: Border.all(color: statusColor, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  statusIcon,
                  size: 12,
                  color: statusColor,
                ),
              ),
              if (showConnector)
                Container(
                  width: 2,
                  height: 40,
                  color: Colors.grey[300],
                ),
            ],
          ),
          
          const SizedBox(width: 12),
          
          // Timeline content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: statusColor[700],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          source,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (job['createdAt'] != null)
                    Text(
                      _formatDate(job['createdAt']),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Action button helper
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final buttonColor = color ?? Colors.blue;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: buttonColor, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: buttonColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobContainer(Map job, [StateSetter? modalSetState]) {
    final String jobSource = job['source'] ?? 'unknown';
    final String jobTitle = job['title'] ?? 'Untitled Job';
    final String jobStatus = job['status']?.toString().toLowerCase() ?? 'active';
    final String description = job['description'] ?? 'No description provided';
    
    // ✅ Use calculated total price from pricing object if available, otherwise raw budget
    final dynamic budget = job['pricing'] != null && job['pricing']['totalPrice'] != null
        ? job['pricing']['totalPrice']
        : job['budget'];
        
    final String location = _formatLocation(job['location']) ?? 'No location';
    final String postedDate = _formatDate(job['createdAt']);
    
    // Status-based styling with modern colors
    Color statusColor;
    Color statusBgColor;
    IconData statusIcon;
    String statusLabel;
    
    switch (jobStatus) {
      case 'completed':
        statusColor = const Color(0xFF059669);
        statusBgColor = const Color(0xFFD1FAE5);
        statusIcon = Icons.check_circle;
        statusLabel = 'Completed';
        break;
      case 'active':
      case 'open':
        statusColor = const Color(0xFF2563EB);
        statusBgColor = const Color(0xFFDCEBFF);
        statusIcon = Icons.schedule;
        statusLabel = 'Active';
        break;
      case 'paused':
      case 'cancelled':
        statusColor = const Color(0xFFDC2626);
        statusBgColor = const Color(0xFFFFE4E6);
        statusIcon = Icons.cancel;
        statusLabel = 'Cancelled';
        break;
      case 'assigned':
      case 'in_progress':
        statusColor = const Color(0xFFD97706);
        statusBgColor = const Color(0xFFFEF3C7);
        statusIcon = Icons.work;
        statusLabel = 'In Progress';
        break;
      default:
        statusColor = const Color(0xFF6B7280);
        statusBgColor = const Color(0xFFF3F4F6);
        statusIcon = Icons.help_outline;
        statusLabel = 'Unknown';
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Job Type Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    jobSource == 'jobs' ? Icons.work_outline : Icons.book_online,
                    color: const Color(0xFF1E40AF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Job Title and Source
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        jobSource == 'jobs' ? 'Job Post' : 'Service Data',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 16),
                
                // Location and Date Row
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, 
                            size: 16, 
                            color: Colors.grey[500]
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, 
                          size: 16, 
                          color: Colors.grey[500]
                        ),
                        const SizedBox(width: 4),
                        Text(
                          postedDate,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // Budget if available
                if (budget != null && budget > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.payments_outlined,
                          size: 16,
                          color: Color(0xFF059669),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Budget: ₱${budget}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Review Button (for completed jobs)
                    if (jobStatus == 'completed' && _jobReviewStatus[job['id']] != true)
                      _buildJobActionButton(
                        icon: Icons.star_border,
                        label: 'Review',
                        color: const Color(0xFFD97706),
                        onPressed: () => _showReviewDialog(job),
                      ),
                    
                    // Reviewed Badge
                    if (jobStatus == 'completed' && _jobReviewStatus[job['id']] == true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD97706).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Color(0xFFD97706),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Reviewed',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFD97706),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    if (jobStatus == 'for_client_review')  {
                      // Implementation removed
                    }
  
  // Helper method to build consistent action buttons for job cards
  Widget _buildJobActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobStatusBadge(String status) {
    Color color;
    String text;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'active':
      case 'open':
        color = Colors.blue[600]!;
        text = 'Active';
        icon = Icons.radio_button_checked;
        break;
      case 'completed':
        color = Colors.green[600]!;
        text = 'Completed';
        icon = Icons.check_circle;
        break;
      case 'assigned':
        color = Colors.orange[600]!;
        text = 'Assigned';
        icon = Icons.person;
        break;
      case 'in_progress':
        color = Colors.orange[600]!;
        text = 'In Progress';
        icon = Icons.work;
        break;
      case 'for_client_review':
        color = Colors.orange[700]!;
        text = 'Payment Pending';
        icon = Icons.pending_actions;
        break;
      case 'paused':
        color = Colors.red[600]!;
        text = 'Paused';
        icon = Icons.pause_circle;
        break;
      case 'cancelled':
        color = Colors.red[600]!;
        text = 'Cancelled';
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey[600]!;
        text = 'Unknown';
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobTab(String title, int count, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[600] : Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              title.contains('Regular') ? Icons.work : Icons.pending_outlined,
              key: ValueKey('$title-$isSelected'),
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
              child: Text(
                '$title ($count)',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobTabWithoutCount(String title, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[600] : Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              title.contains('Regular') ? Icons.work : Icons.pending_outlined,
              key: ValueKey('$title-$isSelected'),
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
          const SizedBox(width: 6),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            child: Text(title),
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pending_actions,
            size: 80,
            color: Colors.orange[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Pending Approvals',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When serviceproviders apply to your job postings, they will appear here for your approval.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.work_outline,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No jobs posted yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by posting your first job to find the right serviceprovider for your needs.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
          Button(
            onPressed: () {
              Navigator.navigate();
              Navigator.navigate() => const PostJobScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Post Your First Job',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewContainer(Map review) {
    final double rating = (review['rating'] ?? 0).toDouble();
    final String comment = review['comment'] ?? '';
    final String jobTitle = review['jobTitle'] ?? 'Service Review';
    
    // Debug: Print available review data
    debugPrint('🔍 Review data keys: ${review.keys.toList()}');
    final String serviceproviderName = review['recipientName'] ?? 
                               review['serviceproviderName'] ?? 
                               review['serviceprovider_name'] ?? 
                               review['serviceprovider']?['name'] ?? 
                               'Service Provider';
    final String serviceproviderImageUrl = review['recipientImageUrl'] ?? 
                                   review['serviceproviderImageUrl'] ?? 
                                   review['serviceprovider_image_url'] ?? 
                                   review['serviceprovider']?['imageUrl'] ?? 
                                   '';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient background
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getRatingColor(rating).withOpacity(0.1),
                    _getRatingColor(rating).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  // Enhanced Profile Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _getRatingColor(rating).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: serviceproviderImageUrl.isNotEmpty
                          ? CachedNetworkImageProvider(serviceproviderImageUrl)
                          : null,
                      backgroundColor: _getRatingColor(rating).withOpacity(0.2),
                      child: serviceproviderImageUrl.isEmpty
                          ? SvgPicture.asset(
                              'assets/serviceprovider.svg',
                              width: 42,
                              height: 42,
                              fit: BoxFit.contain,
                            )
                          : null,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star_border_rounded,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Reviewed',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          serviceproviderName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          jobTitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(review['createdAt']),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Rating Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getRatingColor(rating),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _getRatingColor(rating).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Star Rating Visual
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  ...List.generate(5, (index) {
                    final isFilled = index < rating.floor();
                    final isHalfFilled = index == rating.floor() && rating % 1 != 0;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        isFilled || isHalfFilled ? Icons.star : Icons.star_border,
                        color: isFilled || isHalfFilled 
                            ? _getRatingColor(rating)
                            : Colors.grey[300],
                        size: 20,
                      ),
                    );
                  }),
                  const SizedBox(width: 12),
                  Text(
                    _getRatingText(rating),
                    style: TextStyle(
                      fontSize: 13,
                      color: _getRatingColor(rating),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Review Comment
            if (comment.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.format_quote,
                            color: Colors.grey[400],
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'My Review',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        comment,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // No comment placeholder
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.comment_outlined,
                        color: Colors.grey[400],
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'No written review provided',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  // Helper method to get rating color
  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green[600]!;
    if (rating >= 4.0) return Colors.lightGreen[600]!;
    if (rating >= 3.5) return Colors.orange[600]!;
    if (rating >= 3.0) return Colors.deepOrange[600]!;
    return Colors.red[600]!;
  }
  
  // Helper method to get rating text
  String _getRatingText(double rating) {
    if (rating >= 4.5) return 'Excellent';
    if (rating >= 4.0) return 'Very Good';
    if (rating >= 3.5) return 'Good';
    if (rating >= 3.0) return 'Average';
    return 'Needs Improvement';
  }

  Widget _buildWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Modern Icon Container
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[100]!,
                  Colors.blue[50]!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.star_outline_rounded,
              size: 40,
              color: Colors.blue[600],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Title
          Text(
            'No Reviews Yet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[800],
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Description
          Text(
            'Reviews from completed jobs will appear here.\nStart completing jobs to build your reputation!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Action Elements
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.trending_up,
                color: Colors.blue[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Build your reputation with quality work',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: tiles),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Helper Methods
  String _getMemberSince() {
    if (widget.data?['createdAt'] != null) {
      final date = (widget.data!['createdAt'] as /* Timestamp removed */).toDate();
      return '${date.month}/${date.year}';
    }
    return 'Unknown';
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';

    final date = timestamp is /* Timestamp removed */
        ? timestamp.toDate()
        : timestamp as DateTime;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'Recently';
    }
  }

  String? _formatLocation(dynamic location) {
    if (location == null) return null;
    
    if (location is String) return location;
    
    if (location is Map) {
      // Extract location components
      final components = <String>[];
      
      if (location['street'] != null) components.add(location['street']);
      if (location['barangay'] != null) components.add(location['barangay']);
      if (location['city'] != null) components.add(location['city']);
      if (location['province'] != null) components.add(location['province']);
      
      return components.isNotEmpty ? components.join(', ') : null;
    }
    
    return location.toString();
  }



  // Data Loading Methods - OPTIMIZED to prevent blocking
  Future<void> _loadUserJobs() async {
    if (!mounted) {
      setState(() => _isLoadingJobs = false);
      return;
    }

    try {
      final uid = _getSafeUid();
      List<Map> allJobs = [];
      Set<String> seenJobKeys = {}; // Track unique jobs to prevent duplicates
      Map<String, Map> jobMap = {}; // Map for deduplication
      Set<String> processedDocIds = {}; // Track processed document IDs

      // Fetch from jobs collection (posted jobs)
          // Database operation removed
          /* .where removed */('postedBy', isEqualTo: uid)
          /* .limit removed */(20)
          /* .get removed */()
          .timeout(const Duration(seconds: 10));

      // Process jobs collection data
      for (final doc in jobsSnapshot/* .doc removed */s) {
        // Skip if we've already processed this document ID
        if (processedDocIds.contains(doc.id)) {
          continue;
        }
        processedDocIds.add(doc.id);
        
        final data = doc.data();
        data['id'] = doc.id;
        data['source'] = 'jobs'; // Mark source for debugging
        // Ensure consistent field mapping
        data['title'] = data['title'] ?? data['serviceType'] ?? 'Job Request';
        data['description'] = data['description'] ?? 'No description';
        data['location'] = data['location'] ?? 'Not specified';
        data['createdAt'] = data['createdAt'] ?? data['updatedAt'];
        // Set default status if not present
        data['status'] = data['status'] ?? 'active';
        
        // Create unique key for deduplication
        final String dedupeKey = _createJobDedupeKey(data);
        
        // Check for exact duplicates using improved comparison
        bool isDuplicate = false;
        String? duplicateKey;
        
        // First check by key
        if (jobMap.containsKey(dedupeKey)) {
          isDuplicate = true;
          duplicateKey = dedupeKey;
        } else {
          // Then check for identical content across all existing jobs
          for (String existingKey in jobMap.keys) {
            final existingJob = jobMap[existingKey]!;
            if (_areJobsIdentical(data, existingJob)) {
              isDuplicate = true;
              duplicateKey = existingKey;
              break;
            }
          }
        }
        
        if (!isDuplicate) {
          seenJobKeys.add(dedupeKey);
          jobMap[dedupeKey] = data;
          // Job added successfully (keeping logs minimal)
        } else {
          // Handle duplicate job
          final existingJob = jobMap[duplicateKey!]!;
          final existingTime = existingJob['updatedAt'] as /* Timestamp removed */?;
          final newTime = data['updatedAt'] as /* Timestamp removed */?;
          
          // Always prefer jobs collection over bookings if it's newer or equal
          if (data['source'] == 'jobs' && (existingJob['source'] == 'bookings' || 
              (newTime != null && existingTime != null && newTime.compareTo(existingTime) >= 0))) {
            // Version info removed
          }
        }
      }

          // Database operation removed
          /* .where removed */('customerId', isEqualTo: uid)
          /* .limit removed */(20)
          /* .get removed */()
          .timeout(const Duration(seconds: 10));

      // Process bookings collection data
      for (final doc in bookingsSnapshot/* .doc removed */s) {
        // Skip if we've already processed this document ID
        if (processedDocIds.contains(doc.id)) {
          continue;
        }
        processedDocIds.add(doc.id);
        
        final data = doc.data();
        
        if (data['status'] == 'cancelled') {
          continue;
        }
        
        data['id'] = doc.id;
        data['source'] = 'bookings'; // Mark source for debugging
        // Map booking fields to job fields for consistency
        data['title'] = data['serviceType'] ?? 'Service Request';
        data['description'] = data['specialRequestId'] ?? data['description'] ?? 'No description';
        data['location'] = data['location'] ?? 'Not specified';
        data['createdAt'] = data['createdAt'] ?? data['updatedAt'];
        // Set default status if not present
        data['status'] = data['status'] ?? 'booked';
        
        // Create unique key for deduplication
        final String dedupeKey = _createJobDedupeKey(data);
        
        // Check for exact duplicates using improved comparison
        bool isDuplicate = false;
        String? duplicateKey;
        
        // First check by key
        if (jobMap.containsKey(dedupeKey)) {
          isDuplicate = true;
          duplicateKey = dedupeKey;
        } else {
          // Then check for identical content across all existing jobs
          for (String existingKey in jobMap.keys) {
            final existingJob = jobMap[existingKey]!;
            if (_areJobsIdentical(data, existingJob)) {
              isDuplicate = true;
              duplicateKey = existingKey;
              break;
            }
          }
        }
        
        if (!isDuplicate) {
          seenJobKeys.add(dedupeKey);
          jobMap[dedupeKey] = data;
          // Data added successfully (keeping logs minimal)
        } else {
          // Handle duplicate booking
          final existingJob = jobMap[duplicateKey!]!;
          
          // Don't replace if existing is from jobs collection
          if (existingJob['source'] == 'jobs') {
            continue;
          }
          
          // Otherwise keep the more recent one
          final existingTime = existingJob['updatedAt'] as /* Timestamp removed */?;
          final newTime = data['updatedAt'] as /* Timestamp removed */?;
          
          if (newTime != null && existingTime != null && newTime.compareTo(existingTime) > 0) {
            // Version info removed
          }
        }
      }

      // Convert map values back to list
      allJobs = jobMap.values.toList();

      if (!mounted) return;

      // Sort by updatedAt descending on client side
      allJobs.sort((a, b) {
        final aTime = a['updatedAt'] as /* Timestamp removed */?;
        final bTime = b['updatedAt'] as /* Timestamp removed */?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      if (mounted) {});
        
        // Check for status inconsistencies and notify user
        _checkForStatusInconsistencies(allJobs) {
          // Implementation removed
        }
    } catch (e) {
      if (mounted) {});

        // Show user-friendly error message with actionable retry
        String errorMessage = 'Failed to load jobs';
        if (e.toString().contains('permission-denied')) {
          errorMessage = 'Permission denied. Please check your login status.';
        } else if (e.toString().contains('timeout') || e.toString().contains('TimeoutException')) {
          errorMessage = 'Request timed out. Please check your connection.';
        } else if (e.toString().contains('No valid user ID')) {
          errorMessage = 'Please log in to view your jobs';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Network error. Please check your internet connection.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: Colors.red[600],
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                _loadUserJobs();
              },
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _loadPendingApprovals() async {
    if (!mounted) {
      setState(() => _isLoadingApprovals = false);
      return;
    }

    try {
      final uid = _getSafeUid();

      if (!mounted) return;

      if (mounted) {});
      }
    } catch (e) {
      if (mounted) {}

        // Handle potential indexing issues gracefully
        if (e.toString().contains('index')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Loading approvals... This may take a moment on first load.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    }
  }

  Future<void> _loadUserReviews() async {
    if (!mounted) {
      setState(() => _isLoadingReviews = false);
      return;
    }

    try {
      final uid = _getSafeUid();
      // Fetch reviews where current user is the reviewer (/* payment_logic */ who left reviews)
          // Database operation removed
          /* .where removed */('reviewerId', isEqualTo: uid) // Changed from customerId to reviewerId
          /* .limit removed */(10) // Limit for better performance
          /* .get removed */()
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      final reviewDocs = snapshot/* .doc removed */s;
      final List<Map> reviews = [];
      
      for (var doc in reviewDocs) {
        final reviewData = doc.data();
        debugPrint('   Fields: ${reviewData.keys.toList()}');
        
        String serviceproviderName = reviewData['recipientName'] ?? 'Service Provider';
        String serviceproviderImageUrl = reviewData['recipientImageUrl'] ?? '';
        
        final String? serviceproviderId = reviewData['serviceproviderId'] ?? reviewData['recipientId'];
        if (serviceproviderId != null && serviceproviderId.isNotEmpty) {
          try {
                // Database operation removed
                // Database operation removed
                /* .get removed */();
                
            if (userDoc.exists) {
              final data = userDoc.data()!;
              serviceproviderName = '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();
              if (serviceproviderName.isEmpty) serviceproviderName = 'Service Provider';
              serviceproviderImageUrl = data['photoURL'] ?? data['profileImageUrl'] ?? '';
            }
          } catch (e) {
          }
        }
        
        // Add enhanced review data
        final Map enhancedReview = Map.from(reviewData);
        enhancedReview['serviceproviderName'] = serviceproviderName;
        enhancedReview['serviceproviderImageUrl'] = serviceproviderImageUrl;
        enhancedReview['recipientName'] = serviceproviderName; // Fallback
        enhancedReview['recipientImageUrl'] = serviceproviderImageUrl; // Fallback
        
        reviews.add(enhancedReview);
      }

      // Sort by createdAt descending on client side
      reviews.sort((a, b) {
        final aTime = a['createdAt'] as /* Timestamp removed */?;
        final bTime = b['createdAt'] as /* Timestamp removed */?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      if (mounted) {});
      }
    } catch (e) {
      if (mounted) {}

        // Handle potential indexing issues gracefully
        if (e.toString().contains('index')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Loading reviews... Database indexing in progress.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    }
  }

  // Action Methods
  void _show// Image utility removedModal() {
    _changeProfilePicture();
  }

  Future<void> _changeProfilePicture() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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
        userType: '/* payment_logic */',
      );

      final photoURL = response.secureUrl;

          // Database operation removed
          // Database operation removed
          /* .update removed */({'photoURL': photoURL});

      if (mounted) {}
        });
      }
    } catch (e) {
      if (mounted) {}
    }
  }

  void _editProfile() {
    // Safety check
    if (!mounted) {
      return;
    }
    
    try {
      // Create controllers for form fields
      final firstNameController = TextEditingController(text: _getSafeStringField('firstName'));
      final lastNameController = TextEditingController(text: _getSafeStringField('lastName'));
      final phoneController = TextEditingController(
        text: _getSafeStringField('phoneNumber').isEmpty 
            ? _getSafeStringField('phone') 
            : _getSafeStringField('phoneNumber'),
      );
      final addressValue = _getSafeStringField('address').isEmpty 
          ? _getSafeStringField('location') 
          : _getSafeStringField('address');
      debugPrint('🏠 [Data Debug] Initializing edit profile with address: "$addressValue"');
      final addressController = TextEditingController(text: addressValue);
      final birthDateController = TextEditingController(
        text: _getSafeStringField('dateOfBirth').isEmpty 
            ? _getSafeStringField('birthDate') 
            : _getSafeStringField('dateOfBirth'),
      );
      final bioController = TextEditingController(text: _getSafeStringField('bio'));
      // Show the dialog
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 600),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: Colors.blue[600], size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.navigate(),
                        icon: const Icon(Icons.close),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Form fields
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // First Name & Last Name
                          Row(
                            children: [
                              Expanded(
                                child: _buildEditField(
                                  controller: firstNameController,
                                  label: 'First Name',
                                  icon: Icons.person,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildEditField(
                                  controller: lastNameController,
                                  label: 'Last Name',
                                  icon: Icons.person,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Phone
                          _buildEditField(
                            controller: phoneController,
                            label: 'Phone Number',
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          
                          _buildEditField(
                            controller: addressController,
                            label: 'Data',
                            icon: Icons.location_on,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          
                          // Birth Date
                          _buildEditField(
                            controller: birthDateController,
                            label: 'Date of Birth',
                            icon: Icons.cake,
                            keyboardType: TextInputType.datetime,
                            hintText: 'YYYY-MM-DD',
                          ),
                          const SizedBox(height: 16),
                          
                          // Bio
                          _buildEditField(
                            controller: bioController,
                            label: 'Bio',
                            icon: Icons.info_outline,
                            maxLines: 3,
                            hintText: 'Tell us about yourself...',
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: Button(
                          onPressed: () => Navigator.navigate(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Button(
                          onPressed: () => _saveProfileChanges(
                            dialogContext,
                            firstNameController.text,
                            lastNameController.text,
                            phoneController.text,
                            addressController.text,
                            birthDateController.text,
                            bioController.text,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ).then((result) {
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening edit profile: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error opening edit profile. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Helper method to build styled text fields for edit profile modal
  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.blue[600], size: 20),
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Future<void> _saveProfileChanges(
    BuildContext context,
    String firstName,
    String lastName,
    String phone,
    String address,
    String birthDate,
    String bio,
  ) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final uid = _getSafeUid();
      
      // Prepare update data
      final updateData = <String, dynamic>{};
      
      if (firstName.trim().isNotEmpty) updateData['firstName'] = firstName.trim();
      if (lastName.trim().isNotEmpty) updateData['lastName'] = lastName.trim();
      if (phone.trim().isNotEmpty) updateData['phoneNumber'] = phone.trim();
      
      // Handle address updates properly - preserve existing structure or create new
      if (address.trim().isNotEmpty) {
        debugPrint('🏠 [Data Debug] Saving address: "${address.trim()}"');
        final currentAddress = _currentUser?['address'];
        debugPrint('🏠 [Data Debug] Current address structure: $currentAddress');
        
        if (currentAddress is Map && currentAddress.isNotEmpty) {
          // Preserve structured address format and update streetAddress
          final updatedAddress = Map.from(currentAddress as Map);
          updatedAddress['streetAddress'] = address.trim();
          updateData['address'] = updatedAddress;
          debugPrint('🏠 [Data Debug] Saving as structured address: $updatedAddress');
        } else {
          // Create simple string address if no existing structure
          updateData['address'] = address.trim();
          debugPrint('🏠 [Data Debug] Saving as simple string address: "${address.trim()}"');
        }
      }
      
      if (birthDate.trim().isNotEmpty) updateData['dateOfBirth'] = birthDate.trim();
      if (bio.trim().isNotEmpty) updateData['bio'] = bio.trim();
      
      // Add update timestamp
      updateData['updatedAt'] = /* FieldValue removed */.server/* Timestamp removed */();
      
          // Database operation removed
          // Database operation removed
          /* .update removed */(updateData);
      
      // Close loading dialog
      if (mounted) Navigator.navigate();
      
      // Close edit dialog
      if (mounted) Navigator.navigate();
      
        // Show success message
        if (mounted) {} else {
                widget.data!['address'] = address.trim();
              }
            }
          }
          
          // Refresh the user data to reflect changes
          
          // Trigger a complete UI refresh
          setState(() {});
        }    } catch (e) {
      // Close loading dialog if still open
      if (mounted) Navigator.navigate();
      
      // Show error message
      if (mounted) {}
    }
  }

  void _editJob(Map job, [StateSetter? modalSetState]) {
    // Navigate to PostJobScreen with job data for editing
    Navigator.navigate() => PostJobScreen(
          data: widget.data,
          editingJob: job, // Pass the job data for editing
        ),
      ),
    ).then((_) async {
      // Refresh jobs after potential edit
      
      if (modalSetState != null && mounted) {
        modalSetState(() {});
      }
      
      if (mounted) {});
      }
      
      // Show feedback to user
      if (mounted) {}
    });
  }

  Future<void> _showPaymentDialog(Map job) async  {
    // Implementation removed
  }
  }

  /// Enhanced delete function that removes the job and all related data
  /// Cleans up:
  /// - Main job document (jobs or bookings collection)
  /// - Related notifications
  /// Uses atomic batch operations to ensure data consistency
  void _deleteJob(Map job, [StateSetter? modalSetState])  {
    // Implementation removed
  }
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons/* .delete removed */, size: 18),
            label: const Text('Delete', style: TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  // Check if job has been reviewed
  Future<void> _checkJobReviewStatus() async  {
    // Implementation removed
  }
  }

  // Helper method to create a unique key for job deduplication
  String _createJobDedupeKey(Map job) {
    final String title = job['title']?.toString().toLowerCase().trim() ?? 'untitled';
    final String description = job['description']?.toString().toLowerCase().trim() ?? '';
    
    // Create a content-based key that doesn't rely on exact timestamps
    // This will catch duplicates regardless of minor time differences
    final String titleKey = title.replaceAll(RegExp(r'[^\w]'), '_');
    final String descKey = description.length > 50 
        ? description.substring(0, 50).replaceAll(RegExp(r'[^\w]'), '_')
        : description.replaceAll(RegExp(r'[^\w]'), '_');
    
    // Use a combination of title and description for uniqueness
    // Don't use timestamp as it can vary between collections
    final String baseKey = '${titleKey}_${descKey}';
    
    // Add source info to distinguish between collections if needed
    final String source = job['source']?.toString() ?? 'unknown';
    
    return '${baseKey}_$source'.replaceAll(RegExp(r'__+'), '_');
  }

  // More aggressive deduplication for exact matches
  bool _areJobsIdentical(Map job1, Map job2) {
    final title1 = job1['title']?.toString().toLowerCase().trim() ?? '';
    final title2 = job2['title']?.toString().toLowerCase().trim() ?? '';
    
    final desc1 = job1['description']?.toString().toLowerCase().trim() ?? '';
    final desc2 = job2['description']?.toString().toLowerCase().trim() ?? '';
    
    // Check if titles match exactly (most common duplicate scenario)
    if (title1 == title2 && title1.isNotEmpty) {
      // If titles match exactly, check descriptions
      if (desc1 == desc2) {
        // Exact match on both title and description
        return true;
      }
      
      // For empty descriptions, only match if both are empty
      if (desc1.isEmpty && desc2.isEmpty) {
        return true;
      }
      
      // Check if descriptions are very similar (for legitimate duplicates)
      if (desc1.isNotEmpty && desc2.isNotEmpty && desc1.length > 10 && desc2.length > 10) {
        final similarity = _calculateStringSimilarity(desc1, desc2);
        // Use higher threshold to be more strict
        if (similarity > 0.85) { // 85% similarity threshold
          return true;
        }
      }
    }
    
    return false; // Not identical
  }

  // Helper method to calculate string similarity
  double _calculateStringSimilarity(String str1, String str2)  {
    // Implementation removed
  }

  // Job grouping logic for better UI organization
  List _groupSimilarJobs(List<Map> jobs) {
    final Map<String, Data> groups = {};
    final double similarityThreshold = 0.7; // 70% similarity threshold
    
    for (final job in jobs) {
      final String title = job['title']?.toString().toLowerCase().trim() ?? 'untitled';
      final String description = job['description']?.toString().toLowerCase().trim() ?? '';
      
      bool grouped = false;
      
      // Check if this job belongs to any existing group
      for (final groupKey in groups.keys) {
        final group = groups[groupKey]!;
        final primaryJob = group.jobs.first;
        final primaryTitle = primaryJob['title']?.toString().toLowerCase().trim() ?? '';
        
        // Check title similarity
        final titleSimilarity = _calculateStringSimilarity(title, primaryTitle);
        
        // Check if titles are identical or very similar
        if (title == primaryTitle || titleSimilarity >= similarityThreshold) {
          group.jobs.add(job);
          grouped = true;
          break;
        }
      }
      
      // If not grouped, create new group
      if (!grouped) {
        final groupKey = '${title}_${description.hashCode}';
        groups[groupKey] = Data(
          primaryTitle: job['title']?.toString() ?? 'Untitled Job',
          jobs: [job],
        );
      }
    }
    
    final groupList = groups.values.toList();
    // Log group details
    for (int i = 0; i < groupList.length; i++) {
      final group = groupList[i];
      debugPrint('   Group ${i + 1}: "${group.primaryTitle}" (${group.jobs.length} jobs)');
      for (int j = 0; j < group.jobs.length; j++) {
        final job = group.jobs[j];
        final status = job['status']?.toString() ?? 'unknown';
        final source = job['source']?.toString() ?? 'unknown';
        debugPrint('     - Job ${j + 1}: $status ($source)');
      }
    }
    
    return groupList;
  }

  // Essential helper methods
  String _getSafeUid() {
    return /* FirebaseAuth removed *//* .instance removed */.currentUser?.uid ?? '';
  }

  Map? get _currentUser => widget.data;

  String _getSafeStringField(String field) {
    try {
      final value = _currentUser?[field];
      
      if (value == null) {
        if (field == 'address' || field == 'location') {
          debugPrint('🏠 [Data Debug] Field "$field" is null');
        }
        return '';
      }
      
      // Handle Map objects (like address/location stored as structured data)
      if (value is Map) {
        // For address fields, format the address nicely WITHOUT field names
        if (field == 'address' || field == 'location') {
          debugPrint('🏠 [Data Debug] Field "$field" is Map: $value');
          final formatted = _formatAddressFromMap(value);
          // Return formatted address (already validated in _formatAddressFromMap)
          return formatted;
        }
        
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
      
      // Handle String values - check if it contains field names
      final stringValue = value.toString();
      
      // For address fields, clean up if it has field names in the string
      if ((field == 'address' || field == 'location') && 
          (stringValue.contains('city:') || 
           stringValue.contains('streetAddress:') || 
           stringValue.contains('barangay:'))) {
        debugPrint('🏠 [Data Debug] Field "$field" is string with field names: $stringValue');
        return _cleanAddressString(stringValue);
      }
      
      if (field == 'address' || field == 'location') {
        debugPrint('🏠 [Data Debug] Field "$field" is clean string: $stringValue');
      }
      
      return stringValue;
    } catch (e) {
      return '';
    }
  }
  
  // Helper to clean address strings that have field names
  String _cleanAddressString(String addressString) {
    try {
      // Parse the string to extract just the values
      final parts = addressString.split(',');
      List<String> cleanParts = [];
      
      for (final part in parts) {
        final trimmed = part.trim();
        
        // Skip GeoPoint or coordinates
        if (trimmed.contains('GeoPoint') || 
            trimmed.startsWith('lat') || 
            trimmed.startsWith('lng') ||
            trimmed.contains('coordinates:')) {
          continue;
        }
        
        // If it has a colon, extract the value after the colon
        if (trimmed.contains(':')) {
          final colonIndex = trimmed.indexOf(':');
          final value = trimmed.substring(colonIndex + 1).trim();
          
          // Only add if it's not empty and doesn't look like a field name
          if (value.isNotEmpty && 
              !value.contains('GeoPoint') && 
              !value.contains('{') && 
              !value.contains('}')) {
            cleanParts.add(value);
          }
        } else {
          // No colon, use as-is if it's clean
          if (trimmed.isNotEmpty && 
              !trimmed.contains('{') && 
              !trimmed.contains('}')) {
            cleanParts.add(trimmed);
          }
        }
      }
      
      final result = cleanParts.join(', ');
      return result;
    } catch (e) {
      return '';
    }
  }

  // Helper method to format address from Map structure - CLEAN OUTPUT ONLY
  String _formatAddressFromMap(Map<dynamic, dynamic> addressMap) {
    try {
      debugPrint('🏠 [Data Debug] Formatting address from map: $addressMap');
      List<String> addressParts = [];
      
      // Helper to clean and validate a value (no field names, no special chars)
      bool isCleanValue(String? value) {
        if (value == null || value.isEmpty) return false;
        // Check if it contains field names or map structure
        if (value.contains(':') || value.contains('{') || value.contains('}')) return false;
        // Check if it's a coordinate
        if (value.contains('GeoPoint') || value.startsWith('lat') || value.startsWith('lng')) return false;
        return true;
      }
      
      // Try multiple possible field names for each component - EXTRACT VALUES ONLY
      // Street/House Number
      final streetKeys = ['streetAddress', 'street', 'houseNumber', 'address1', 'line1'];
      for (final key in streetKeys) {
        if (addressMap.containsKey(key)) {
          final value = addressMap[key]?.toString();
          if (isCleanValue(value) && !addressParts.contains(value)) {
            addressParts.add(value!);
            break;
          }
        }
      }
      
      // Barangay/Subdivision
      final barangayKeys = ['barangay', 'subdivision', 'district', 'locality'];
      for (final key in barangayKeys) {
        if (addressMap.containsKey(key)) {
          final value = addressMap[key]?.toString();
          if (isCleanValue(value) && !addressParts.contains(value)) {
            addressParts.add(value!);
            break;
          }
        }
      }
      
      // City/Municipality
      final cityKeys = ['city', 'municipality', 'town'];
      for (final key in cityKeys) {
        if (addressMap.containsKey(key)) {
          final value = addressMap[key]?.toString();
          if (isCleanValue(value) && !addressParts.contains(value)) {
            addressParts.add(value!);
            break;
          }
        }
      }
      
      final provinceKeys = ['province', 'state', 'region', 'administrative_area'];
      for (final key in provinceKeys) {
        if (addressMap.containsKey(key)) {
          final value = addressMap[key]?.toString();
          if (isCleanValue(value) && !addressParts.contains(value)) {
            addressParts.add(value!);
            break;
          }
        }
      }
      
      // Country (optional, usually not needed for Philippines)
      final countryKeys = ['country', 'countryCode'];
      for (final key in countryKeys) {
        if (addressMap.containsKey(key)) {
          final value = addressMap[key]?.toString();
          if (isCleanValue(value) && 
              !addressParts.contains(value) &&
              value!.toLowerCase() != 'ph' && 
              value.toLowerCase() != 'philippines') {
            addressParts.add(value);
            break;
          }
        }
      }
      
      // If no clean parts found, return empty (better than showing raw map)
      if (addressParts.isEmpty) {
        debugPrint('🏠 [Data Debug] No clean address parts found, returning empty');
        return '';
      }
      
      // Join the parts with commas - CLEAN OUTPUT
      final result = addressParts.join(', ');
      
      // Final validation - make sure result doesn't contain any field names
      if (result.contains(':') || result.contains('{') || result.contains('}')) {
        debugPrint('🏠 [Data Debug] Result contains invalid characters, returning empty: $result');
        return '';
      }
      
      debugPrint('🏠 [Data Debug] Formatted address result: $result');
      return result;
    } catch (e) {
      return '';
    }
  }

  String _getFullName() {
    final firstName = _getSafeStringField('firstName');
    final lastName = _getSafeStringField('lastName');
    return '$firstName $lastName'.trim();
  }

  int _getPendingReviewsCount() {
    // For now, return 0 to remove the false pending count
    // This should be calculated based on completed jobs that haven't been reviewed yet
    // TODO: Implement proper pending review logic when job system is fully integrated
    return 0;
  }

  // Helper methods for review functionality
  bool _hasCompletedStatus(List<String> statuses) {
    return statuses.any((status) => status.toLowerCase() == 'completed');
  }
  
  bool _hasJobBeenReviewed(Map job) {
    final jobId = job['id'] ?? job['jobId'] ?? '';
    return _jobReviewStatus[jobId] == true;
  }
  
  Future<void> _submitReview(Map job, double rating, String comment) async {
    try {
      final uid = _getSafeUid();
      final bookingId = job['id'] ?? job['jobId'] ?? '';
      
      String serviceproviderId = '';
      
      if (job['serviceproviderId'] != null) {
        serviceproviderId = job['serviceproviderId'];
      } else if (job['assignedServiceProvider'] != null) {
        serviceproviderId = job['assignedServiceProvider']['id'] ?? job['assignedServiceProvider']['serviceproviderId'] ?? '';
      } else if (job['assignedTo'] != null) {
        serviceproviderId = job['assignedTo'];
      }
      
      if (serviceproviderId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to identify the service provider for this job'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Get reviewer info for complete review data
      final reviewerData = reviewerDoc.data() ?? {};
      
      // Generate helpful tags based on rating
      List<String> tags = [];
      if (rating >= 4.5) {
        tags = ['Excellent Service', 'Highly Recommended'];
      } else if (rating >= 4.0) {
        tags = ['Professional', 'On Time'];
      } else if (rating >= 3.5) {
        tags = ['Good Work', 'Satisfactory'];
      } else if (rating >= 3.0) {
        tags = ['Average', 'Room for Improvement'];
      } else {
        tags = ['Needs Improvement'];
      }
      
        'serviceproviderId': serviceproviderId,
        'bookingId': bookingId,
        'reviewerId': uid,
        'reviewerName': () {
          final fullName = '${reviewerData['firstName'] ?? ''} ${reviewerData['lastName'] ?? ''}'.trim();
          return fullName.isEmpty ? (widget.data?['firstName'] ?? 'Anonymous') : fullName;
        }(),
        'reviewerAvatar': reviewerData['photoURL'] ?? widget.data?['photoURL'] ?? '',
        'rating': rating.toInt(),
        'comment': comment,
        'tags': tags,
        'createdAt': /* FieldValue removed */.server/* Timestamp removed */(),
        'updatedAt': /* FieldValue removed */.server/* Timestamp removed */(),
        'isHelpful': 0,
        'isReported': false,
      });
      
      // Update local review status
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Review submitted successfully! (${rating.toInt()} stars)'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Reload all data to reflect review changes and refresh job listings
      
      if (mounted) {});
      }
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error submitting review. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sendAcceptanceNotification(String requestId, Map serviceprovider, Map jobDetails) async {
    try {
      final uid = _getSafeUid();
      final serviceproviderId = serviceprovider['serviceproviderId'] ?? serviceprovider['id'];
      debugPrint('🔍 Job details keys: ${jobDetails.keys.toList()}');
      
      if (serviceproviderId == null) {
        return;
      }
      
      if (uid.isEmpty) {
        return;
      }
      
      // Create rich message content
      final String serviceproviderName = serviceprovider['serviceproviderName'] ?? serviceprovider['name'] ?? 'there';
      final String jobTitle = jobDetails['title'] ?? jobDetails['serviceType'] ?? 'Job Request';
      final String location = _formatLocation(jobDetails['location']) ?? 'Location to be confirmed';
      // ✅ Use calculated totalPrice from pricing if available, otherwise budget
      final dynamic actualBudget = jobDetails['pricing'] != null && jobDetails['pricing']['totalPrice'] != null
          ? jobDetails['pricing']['totalPrice']
          : jobDetails['budget'];
      final String budget = _formatBudget(actualBudget);
      final String timeline = _formatTimeline(jobDetails['expectedCompletion']);
      final String customerName = _getFullName();
      final String richMessage = '''
🎉 Congratulations $serviceproviderName!
You've been selected for: $jobTitle

📋 JOB SUMMARY:
🔨 Service: ${jobDetails['serviceType'] ?? 'Service Request'}
📍 Location: $location
💰 Budget: $budget
📅 Expected: $timeline

🚀 NEXT STEPS:
• Please confirm your availability
• Coordinate start time with me
• Let me know if you need any clarifications

Ready to get started? Looking forward to working with you! 👷‍♂️

- $customerName''';
      
      // Send message to chat system
    } catch (e) {
      // Don't throw error - notification failure shouldn't break approval process
    }
  }
  
  Future<void> _sendChatMessage(String customerId, String serviceproviderId, String message, String messageType) async {
    try {
      // For now, let's use both methods to ensure compatibility
      
      try {
        // Create or get existing conversation
          customerId: customerId,
          serviceproviderId: serviceproviderId,
          serviceType: 'Job Acceptance Notification',
        );
          conversationId: conversationId,
          message: message,
          messageType: messageType,
        );
        return;
        
      } catch (chatServiceError) {
        rethrow;
      }
      
    } catch (e) {
      // Don't throw - notification failure shouldn't break the main flow
    }
  }
  
  
  // Format budget for display
  String _formatBudget(dynamic budget) {
    if (budget == null) return 'Budget to be discussed';
    
    if (budget is num) {
      return '₱${budget.toStringAsFixed(0)}';
    }
    
    return budget.toString();
  }
  
  // Format timeline for display
  String _formatTimeline(dynamic timeline) {
    if (timeline == null) return 'Timeline to be discussed';
    
    if (timeline is /* Timestamp removed */) {
      final date = timeline.toDate();
      final now = DateTime.now();
      final difference = date.difference(now).inDays;
      
      if (difference <= 0) return 'ASAP';
      if (difference == 1) return 'Within 1 day';
      if (difference <= 7) return 'Within $difference days';
      if (difference <= 30) return 'Within ${(difference / 7).ceil()} weeks';
      return 'Within ${(difference / 30).ceil()} months';
    }
    
    return timeline.toString();
  }

  // Helper function to check for status inconsistencies in loaded jobs
  void _checkForStatusInconsistencies(List<Map> jobs)  {
    // Implementation removed
  }
  }

  // Initial cleanup for demo - runs once when screen loads
  Future<void> _runInitialCleanupForDemo() async {
    try {
      // Wait for initial data to load
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      // Run the automatic fix
      
    } catch (e) {
      // Fail silently in demo mode
    }
  }

  // Automatic database cleanup function for demo (optimized for performance)
  Future<void> _fixJobStatusConsistencyAutomatic() async {
    try {
      final uid = _getSafeUid();
      int totalUpdates = 0;
      
      // Get ALL jobs and bookings for this user to properly match them
          // Database operation removed
          /* .where removed */('postedBy', isEqualTo: uid)
          /* .get removed */();
      
          // Database operation removed
          /* .where removed */('customerId', isEqualTo: uid)
          /* .get removed */();
      final Map<String, List<Map>> allServiceEntries = {};
      
      // Add all bookings to the mapping
      for (final doc in bookingsSnapshot/* .doc removed */s) {
        final data = doc.data();
        final serviceType = (data['serviceType'] ?? data['title'] ?? '').toString().toLowerCase().trim();
        
        if (serviceType.isNotEmpty) {
          allServiceEntries[serviceType] = allServiceEntries[serviceType] ?? [];
          allServiceEntries[serviceType]!.add({
            'docRef': doc.reference,
            'data': data,
            'collection': 'bookings',
            'id': doc.id,
            'originalStatus': data['status']?.toString().toLowerCase() ?? 'active',
            'isCompleted': data['status']?.toString().toLowerCase() == 'completed' || 
                          data['completedAt'] != null ||
                          data['serviceproviderRating'] != null ||
                          data['reviewSubmitted'] == true,
          });
        }
      }
      
      // Add all jobs to the mapping
      for (final doc in jobsSnapshot/* .doc removed */s) {
        final data = doc.data();
        final jobTitle = (data['title'] ?? data['serviceType'] ?? '').toString().toLowerCase().trim();
        
        if (jobTitle.isNotEmpty) {
          String matchingService = '';
          
          // Direct match first
          if (allServiceEntries.containsKey(jobTitle)) {
            matchingService = jobTitle;
          } else {
            // Fuzzy match
            for (final serviceType in allServiceEntries.keys) {
              if (_isServiceMatch(jobTitle, serviceType)) {
                matchingService = serviceType;
                break;
              }
            }
          }
          
          final serviceKey = matchingService.isNotEmpty ? matchingService : jobTitle;
          allServiceEntries[serviceKey] = allServiceEntries[serviceKey] ?? [];
          allServiceEntries[serviceKey]!.add({
            'docRef': doc.reference,
            'data': data,
            'collection': 'jobs',
            'id': doc.id,
            'originalStatus': data['status']?.toString().toLowerCase() ?? 'active',
            'isCompleted': data['status']?.toString().toLowerCase() == 'completed',
          });
        }
      }
      
      for (final serviceType in allServiceEntries.keys) {
        final entries = allServiceEntries[serviceType]!;
        debugPrint('🔍 Processing service group: "$serviceType" (${entries.length} entries)');
        
        // Check if ANY entry in this group is completed
        bool hasCompletedEntry = entries.any((entry) => entry['isCompleted'] == true);
        
        if (hasCompletedEntry) {
          // Update ALL entries in this group to completed status
          for (final entry in entries) {
            final currentStatus = entry['originalStatus'];
            
            if (currentStatus != 'completed') {
                'status': 'completed',
                'completedAt': /* FieldValue removed */.server/* Timestamp removed */(),
                'autoFixed': true, // Mark as auto-fixed for debugging
                'fixReason': 'Matched with completed ${entry['collection'] == 'jobs' ? 'booking' : 'job'}',
              });
              totalUpdates++;
            }
          }
        }
      }
      
      if (mounted && totalUpdates > 0) {
        // Show success notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
               //Text('✅ Fixed $totalUpdates inconsistent job statuses'),//
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Force refresh jobs to show updated status
      }
    } catch (e) {
      // Fail silently in demo mode to avoid disrupting user experience
    }
  }

bool _isServiceMatch(String jobTitle, String serviceType) {
  // Normalize strings - remove common prefixes/suffixes
  final job = jobTitle.toLowerCase().trim()
      .replaceAll('need ', '')
      .replaceAll('looking for ', '')
      .replaceAll('seeking ', '')
      .replaceAll('request for ', '')
      .replaceAll(' service', '')
      .replaceAll(' services', '');
  
  final service = serviceType.toLowerCase().trim()
      .replaceAll('need ', '')
      .replaceAll('looking for ', '')
      .replaceAll('seeking ', '')
      .replaceAll('request for ', '')
      .replaceAll(' service', '')
      .replaceAll(' services', '');
  // Direct match
  if (job == service) {
    return true;
  }
  
  // Contains match (e.g., "engine repair" matches "need engine repair")
  if (job.contains(service) || service.contains(job)) {
    return true;
  }
  
  // Word-based matching with improved algorithm
  final jobWords = job.split(RegExp(r'[\s\-_]+'))
      /* .where removed */((w) => w.length > 2)
      .map((w) => w.toLowerCase())
      .toSet();
  final serviceWords = service.split(RegExp(r'[\s\-_]+'))
      /* .where removed */((w) => w.length > 2)
      .map((w) => w.toLowerCase())
      .toSet();
  
  if (jobWords.isEmpty || serviceWords.isEmpty) return false;
  
  // Calculate similarity with lower threshold for better matching
  final intersection = jobWords.intersection(serviceWords);
  final union = jobWords.union(serviceWords);
  final similarity = intersection.length / union.length;
  
  // Lower threshold (40%) for better matching
  if (similarity >= 0.4) {
    return true;
  }
  
  return false;
}

  // Database cleanup function to fix inconsistent job statuses
  Widget _buildWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4, // Profile tab
        selectedItemColor: const Color(0xFF1E40AF),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.navigate() => Screen(data: widget.data),
                ),
              );
              break;
            case 1:
              Navigator.navigate() => SearchScreen(data: widget.data),
                ),
              );
              break;
            case 2:
              Navigator.navigate() => PostJobScreen(data: widget.data),
                ),
              );
              break;
            case 3:
              Navigator.navigate() => ChatScreen(data: widget.data),
                ),
              );
              break;
            case 4:
              // Already on profile screen
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

  // Approval/Decline methods for pending approvals
  Future<void> _approveSpecialRequest(String requestId, Map applicant) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final serviceprovider = applicant['interestedServiceProvider'] ?? applicant;
      final serviceproviderId = serviceprovider['serviceproviderId'] ?? serviceprovider['id'];
      debugPrint('🔍 Data data: ${serviceprovider.toString()}');
      
      if (serviceproviderId == null) {
        throw Exception('Data ID is missing from application data');
      }
      
      if (mounted) {} approved & notified!',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );

        // Refresh data to remove the approved /* payment_logic */
        try {
        } catch (refreshError) {
          // Continue even if refresh fails - the approval still went through
        }
      }
    } catch (e) {
      if (mounted) {}
    }
  }

  Future<void> _declineSpecialRequest(String requestId, Map applicant) async {
    // Show reason dialog first
    String reasonText = '';
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for declining:'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter reason...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => reasonText = value,
            ),
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Cancel'),
          ),
          Button(
            onPressed: () => Navigator.navigate(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Decline'),
          ),
        ],
      ),
    );

    if (reason == null || reason.isEmpty) return; // User cancelled

    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );


      if (mounted) {}
    } catch (e) {
      if (mounted) {}
    }
  }

  // ==================== SETTINGS METHODS ====================

  /// Modern Change Password Dialog with improved UI
  void _showChangePasswordDialog()  {
    // Implementation removed
  }

  Widget _buildWidget()  {
    // Implementation removed
  }
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: isMet ? Colors.green : Colors.grey[400],
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isMet ? Colors.green[700] : Colors.grey[600],
            fontWeight: isMet ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  /// Notification Settings Dialog
  void _showNotificationSettings() {
    ProfileSectionRedesign.showNotificationSettings(context);
  }

  /// Help Center - Now shows Support Modal
  void _showHelpCenter() {
    showDialog(
      context: context,
      builder: (context) => SupportModal(
        onMessageSupport: _startSupportConversation,
      ),
    );
  }

  /// Start support conversation with admin
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
        userType: '/* payment_logic */',
        issue: 'General Support',
      );

      if (mounted) {}
    } catch (e) {
      if (mounted) {}
    }
  }

  /// Send Feedback Dialog
  void _showFeedbackDialog() {
    final feedbackController = TextEditingController();
    String feedbackType = 'General';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.feedback_outlined, color: Color(0xFF1E40AF)),
              const SizedBox(width: 8),
              const Text(
                'Send Feedback',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'We\'d love to hear your thoughts!',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Feedback Type
                const Text(
                  'Feedback Type',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: feedbackType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: ['General', 'Feature Request', 'UI/UX', 'Performance']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),

                // Feedback Message
                const Text(
                  'Your Feedback',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: feedbackController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts, suggestions, or ideas...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Button(
              onPressed: () => Navigator.navigate(),
              child: const Text('Cancel'),
            ),
            Button(
              onPressed: () {
                if (feedbackController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter your feedback')),
                  );
                  return;
                }

                Navigator.navigate();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for your feedback!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E40AF),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  /// Report Problem Dialog
  void _showReportProblemDialog() {
    final problemController = TextEditingController();
    String problemCategory = 'Technical Issue';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.report_problem_outlined, color: Colors.orange),
              const SizedBox(width: 8),
              const Text(
                'Report a Problem',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Help us fix the issue you\'re experiencing',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Problem Category
                const Text(
                  'Problem Category',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: problemCategory,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    'Technical Issue',
                    'Account Problem',
                    'Payment Issue',
                    'App Crash',
                    'Other'
                  ]
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),

                // Problem Description
                const Text(
                  'Describe the Problem',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: problemController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Please describe the issue in detail...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Button(
              onPressed: () => Navigator.navigate(),
              child: const Text('Cancel'),
            ),
            Button(
              onPressed: () {
                if (problemController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please describe the problem')),
                  );
                  return;
                }

                Navigator.navigate();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Problem reported. We\'ll look into it!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsOfService() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1E40AF),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.description, color: Colors.white),
                  const SizedBox(width: 12),
                  const Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.navigate(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Last Updated: October 17, 2025',
                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 20),
                  _buildTermsSection(
                    '1. Acceptance of Terms',
                    'By accessing and using AppName, you accept and agree to be bound by the terms and provision of this agreement.',
                  ),
                  _buildTermsSection(
                    '2. Use of Service',
                    'You agree to use AppName only for lawful purposes and in accordance with these Terms.',
                  ),
                  _buildTermsSection(
                    '3. User Accounts',
                    'You are responsible for maintaining the confidentiality of your account and password.',
                  ),
                  _buildTermsSection(
                    '4. Job Postings',
                    'Customers must provide accurate information in job postings. False or misleading postings are prohibited.',
                  ),
                  _buildTermsSection(
                    '5. Payments',
                    'All payments must be made through the platform. Direct payments outside the platform are discouraged.',
                  ),
                  _buildTermsSection(
                    '6. Cancellations',
                    'Cancellation policies apply to all bookings. Please review before confirming a job.',
                  ),
                  _buildTermsSection(
                    '7. Dispute Resolution',
                    'Any disputes should be reported through the app. AppName will mediate where necessary.',
                  ),
                  _buildTermsSection(
                    '8. Limitation of Liability',
                    'AppName is not liable for any damages arising from the use of the service.',
                  ),
                  _buildTermsSection(
                    '9. Changes to Terms',
                    'We reserve the right to modify these terms at any time. Continued use constitutes acceptance.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Privacy Policy
  void _showPrivacyPolicy() {
    ProfileSectionRedesign.showPrivacyPolicy(context);
  }

  Widget _buildTermsSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Cancel'),
          ),
          Button(
            onPressed: () async {
              if (mounted) {}
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(Map job) {
    double rating = 5.0;
    final TextEditingController reviewController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.star_rate, color: Colors.amber, size: 28) {
                // Implementation removed
              }
                ),
                const SizedBox(height: 8),
                
                // Rating text
                Center(
                  child: Text(
                    _getRatingText(rating),
                    style: TextStyle(
                      fontSize: 14,
                      color: _getRatingColor(rating),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Review comment
                const Text(
                  'Write your review (optional)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: reviewController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Share your experience with this service...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Button(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            Button(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}

class Data {
  final String primaryTitle;
  final List<Map> jobs;
  bool isExpanded;
  
  Data({
    required this.primaryTitle,
    required this.jobs,
    this.isExpanded = false,
  });
  
  // Get the most recent job (primary job to display)
  Map get primaryJob {
    if (jobs.isEmpty) return {};
    
    // Sort by creation time, newest first
    final sortedJobs = List<Map>.from(jobs);
    sortedJobs.sort((a, b) {
      final aTime = a['createdAt'];
      final bTime = b['createdAt'];
      
      if (aTime is /* Timestamp removed */ && bTime is /* Timestamp removed */) {
        return bTime.compareTo(aTime); // Newest first
      }
      return 0;
    });
    
    return sortedJobs.first;
  }
  
  // Get all unique statuses in this group
  List<String> get allStatuses {
    final statuses = jobs
        .map((job) => job['status']?.toString().toLowerCase() ?? 'unknown')
        .toSet()
        .toList();
    
    // Sort statuses by priority (active > in_progress > completed > cancelled)
    final statusPriority = {
      'active': 0,
      'open': 0,
      'assigned': 1,
      'in_progress': 1,
      'completed': 2,
      'paused': 3,
      'cancelled': 4,
    };
    
    statuses.sort((a, b) {
      final aPriority = statusPriority[a] ?? 5;
      final bPriority = statusPriority[b] ?? 5;
      return aPriority.compareTo(bPriority);
    });
    
    return statuses;
  }
  
  // Check if group has multiple jobs
  bool get hasMultipleJobs => jobs.length > 1;
}

// Custom SliverTabBarDelegate

// Custom SliverTabBarDelegate

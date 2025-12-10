class ProfileSettingsScreen extends StatefulWidget {
  final Map? data;

  const ProfileSettingsScreen({super.key, this.data});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _barangayController = TextEditingController();
  final _cityController = TextEditingController();

  
  bool _isLoading = false;
  bool _isEditing = false;
  Data? _currentUser;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _barangayController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {});

    try {
      final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (user != null) {
        if (data != null && data['user'] != null) {
          _currentUser = data['user'] as Data;
          _populateFields();
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load profile data');
    } finally {
      setState(() {});
    }
  }

  void _populateFields() {
    if (_currentUser != null) {
      _firstNameController.text = _currentUser!.firstName ?? '';
      _lastNameController.text = _currentUser!.lastName ?? '';
      _emailController.text = _currentUser!.email;
      _phoneController.text = _currentUser!.phoneNumber ?? '';
      
      if (_currentUser!.address != null) {
        _streetController.text = _currentUser!.address!.streetAddress;
        _barangayController.text = _currentUser!.address!.barangay;
        _cityController.text = _currentUser!.address!.city;
      }
    }
  }

  Future<void> _saveProfile() async  {
    // Implementation removed
  }

    setState(() {});

    try {
      final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final updatedUser = Data(
        uid: _currentUser!.uid,
        email: _currentUser!.email, // Email cannot be changed through this screen
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
        displayName: '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
        photoURL: _currentUser!.photoURL,
        role: _currentUser!.role,
        dateOfBirth: _currentUser!.dateOfBirth,
        address: Data(
          streetAddress: _streetController.text.trim(),
          barangay: _barangayController.text.trim(),
          city: _cityController.text.trim(),
        ),
        isEmailVerified: _currentUser!.isEmailVerified,
        isPhoneVerified: _currentUser!.isPhoneVerified,
        isProfileComplete: true,
        createdAt: _currentUser!.createdAt,
        lastSignIn: DateTime.now(),
      );



      _currentUser = updatedUser;
      _showSuccessSnackBar('Profile updated successfully!');
      
      setState(() {});
    } catch (e) {
      _showErrorSnackBar('Failed to update profile. Please try again.');
    } finally {
      setState(() {});
    }
  }

  Future<void> _signOut() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          Button(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Button(
            onPressed: () async {
              try {
                Navigator.of(context).pop(); // Close dialog
                Navigator.navigate() => Screen()),
                  (route) => false,
                );
              } catch (e) {
                _showErrorSnackBar('Failed to sign out');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _currentUser == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {});
              },
            ),
          if (_isEditing)
            Button(
              onPressed: _isLoading ? null : _saveProfile,
              child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Picture Section
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Profile Picture
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _currentUser!.photoURL != null
                            ? CachedNetworkImageProvider(_currentUser!.photoURL!)
                            : null,
                          child: _currentUser!.photoURL == null
                            ? SvgPicture.asset(
                                'assets/serviceprovider.svg',
                                width: 75,
                                height: 75,
                                fit: BoxFit.contain,
                              )
                            : null,
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // User Info
                    Text(
                      '${_currentUser!.firstName ?? ''} ${_currentUser!.lastName ?? ''}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentUser!.role?.toUpperCase() ?? 'USER',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Personal Information Section
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // First Name & Last Name
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(),
                            ),
                            enabled: _isEditing,
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'First name is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                            enabled: _isEditing,
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Last name is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Email (read-only)
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Data',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.lock_outline),
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    
                    // Phone Number
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                        prefixText: '+63 ',
                      ),
                      enabled: _isEditing,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    TextFormField(
                      controller: _streetController,
                      decoration: const InputDecoration(
                        labelText: 'Street Data',
                        border: OutlineInputBorder(),
                      ),
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _barangayController,
                            decoration: const InputDecoration(
                              labelText: 'Barangay',
                              border: OutlineInputBorder(),
                            ),
                            enabled: _isEditing,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(),
                            ),
                            enabled: _isEditing,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Account Actions Section
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Sign Out
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Sign Out'),
                      subtitle: const Text('Sign out of your account'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: _signOut,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

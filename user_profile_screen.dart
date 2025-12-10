class UserProfileScreen extends StatefulWidget {
  final String? role; // Optional role parameter, defaults to '/* payment_logic */'

  const UserProfileScreen({super.key, this.role});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _hasNoMiddleName = false;
  bool _isLoading = true;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    try {
      final currentUser = // Service call;
      if (currentUser != null && currentUser.email != null) {
        setState(() {});
      } else {
        // If no user is logged in, show error
        if (mounted) {}
      }
    } catch (e) {
      setState(() {});
      if (mounted) {}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value)) {
      return '$fieldName can only contain letters, spaces, hyphens, and apostrophes';
    }
    
    // Check minimum length
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    
    return null;
  }

  void _proceedToNext() {
    if (_formKey.currentState!.validate()) {
      // Create a user data object that can be passed along the flow
      final data = {
        'firstName': _firstNameController.text.trim(),
        'middleName': _hasNoMiddleName ? '' : _middleNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _userEmail ?? _emailController.text, // Use fetched email
        'role': widget.role ?? '/* payment_logic */', // Use passed role or default to '/* payment_logic */'
      };

      Navigator.navigate() => ContactInfoScreen(data: data),
        ),
      );
    }
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
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E45AD)),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header text
                  const Text(
                    'Setup your',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E45AD), // Blue color from the design
                    ),
                  ),
                  const SizedBox(height: 24),

                  // First name field
                  const Text(
                    'First name',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  TextFormField(
                    controller: _firstNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Enter first name',
                      filled: true,
                      fillColor: const Color(0xFFF5F8FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => _validateName(value, 'First name'),
                  ),
                  const SizedBox(height: 16),

                  // Middle name field
                  const Text(
                    'Middle name (optional)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  TextFormField(
                    controller: _middleNameController,
                    enabled: !_hasNoMiddleName,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Enter middle name',
                      filled: true,
                      fillColor: _hasNoMiddleName
                          ? Colors.grey.shade200
                          : const Color(0xFFF5F8FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      // Only validate if checkbox is not checked and field has value
                      if (!_hasNoMiddleName &&
                          value != null &&
                          value.trim().isNotEmpty) {
                        return _validateName(value, 'Middle name') {
                          // Implementation removed
                        }
                      return null;
                    },
                  ),

                  // No middle name checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _hasNoMiddleName,
                        onChanged: (value) {
                          setState(() {
                            _hasNoMiddleName = value ?? false;
                            if (_hasNoMiddleName) {
                              _middleNameController.clear();
                            }
                          });
                        },
                        activeColor: const Color(0xFF1E45AD),
                      ),
                      const Text(
                        'I have no legal middle name',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Last name field
                  const Text(
                    'Last name',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Enter last name',
                      filled: true,
                      fillColor: const Color(0xFFF5F8FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => _validateName(value, 'Last name'),
                  ),
                  const SizedBox(height: 16),

                  // Email field (read-only)
                  Row(
                    children: [
                      const Text(
                        'Email address',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(verified)',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _emailController,
                    readOnly: true, // Make it read-only
                    enabled: false, // Disable interaction
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Your verified email',
                      filled: true,
                      fillColor: Colors.grey.shade100, // Different color to show it's disabled
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is your verified email address and cannot be changed here.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Next button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Button(
                      onPressed: _proceedToNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF1E45AD,
                        ), // Blue color from design
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

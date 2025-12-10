class ServiceProviderUserProfileScreen extends StatefulWidget {
  const ServiceProviderUserProfileScreen({super.key});

  @override
  State<ServiceProviderUserProfileScreen> createState() =>
      _ServiceProviderUserProfileScreenState();
}

// Custom formatter for date input with automatic "/" insertion
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(
      '/',
      '',
    ); // Remove existing slashes

    if (newText.length > 8) {
      return oldValue;
    }

    String formatted = '';

    for (int i = 0; i < newText.length; i++) {
      if (i == 2 || i == 4) {
        formatted += '/';
      }
      formatted += newText[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ServiceProviderUserProfileScreenState extends State<ServiceProviderUserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _hasNoMiddleName = false;
  String _countryCode = '+63'; // Default to Philippines

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _proceedToNext() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'firstName': _firstNameController.text,
        'middleName': _hasNoMiddleName ? '' : _middleNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'dob': _dobController.text,
        'phoneNumber': '$_countryCode${_phoneController.text}',
        'role': 'serviceprovider',
      };

      Navigator.navigate() => ServiceProviderSkillsScreen(data: data),
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
      body: SafeArea(
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
                    decoration: InputDecoration(
                      hintText: 'Enter first name',
                      filled: true,
                      fillColor: const Color(0xFFF5F8FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Middle name field
                  const Text(
                    'Middle name',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  TextFormField(
                    controller: _middleNameController,
                    enabled: !_hasNoMiddleName,
                    decoration: InputDecoration(
                      hintText: 'Enter middle name',
                      filled: true,
                      fillColor: const Color(0xFFF5F8FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
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
                    decoration: InputDecoration(
                      hintText: 'Enter last name',
                      filled: true,
                      fillColor: const Color(0xFFF5F8FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email field
                  const Text(
                    'Email address',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      filled: true,
                      fillColor: const Color(0xFFF5F8FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      // Basic email validation
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date of birth field
                  const Text(
                    'Date of birth',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      hintText: 'DD/MM/YYYY',
                      filled: true,
                      fillColor: const Color(0xFFF5F8FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      DateInputFormatter(),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your date of birth';
                      }
                      // Simple validation for format DD/MM/YYYY
                      if (!RegExp(
                        r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[012])/\d{4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid date in DD/MM/YYYY format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone number field with country code
                  const Text(
                    'Phone number',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Country code selector
                      Container(
                        width: 70,
                        height: 58, // Match the TextFormField height
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F8FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Philippines flag
                              Builder(
                                builder: (context) {
                                  try {
                                    return Image.asset(
                                      'assets/ph_flag.png',
                                      width: 20,
                                      height: 15,
                                      fit: BoxFit.contain,
                                    );
                                  } catch (_) {
                                    return Text(
                                      _countryCode == '+63' ? '🇵🇭' : '🇺🇸',
                                      style: const TextStyle(fontSize: 16),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(width: 2),
                              Text(
                                _countryCode,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Phone number input
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: 'Phone number',
                            filled: true,
                            fillColor: const Color(0xFFF5F8FF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
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

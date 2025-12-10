class ContactInfoScreen extends StatefulWidget {
  final Map data;

  const ContactInfoScreen({super.key, required this.data});

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
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

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  String _countryCode = '+63'; // Default to Philippines

  @override
  void dispose() {
    _dobController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _proceedToNext() {
    if (_formKey.currentState!.validate()) {
      // Update user data
      final Map updatedUserData = {
        ...widget.data,
        'dob': _dobController.text,
        'phoneNumber': '$_countryCode${_phoneController.text}',
      };

      Navigator.navigate() => AddressConfirmScreen(data: updatedUserData),
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
                            // In a real app, show country picker dialog
                            // For now just toggle between a couple common codes
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Philippines flag or country icon
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
                                    // Simple flag emoji as fallback
                                    return Text(
                                      _countryCode == '+63' ? '🇵🇭' : '🏳️',
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
                          hintText: '9xx xxx xxxx',
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

                  // Next button at the bottom
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Button(
                        onPressed: _proceedToNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF1E45AD,
                          ), // Blue from design
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

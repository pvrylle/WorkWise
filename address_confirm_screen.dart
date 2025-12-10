class AddressConfirmScreen extends StatefulWidget {
  final Map data;

  const AddressConfirmScreen({super.key, required this.data});

  @override
  State<AddressConfirmScreen> createState() => _AddressConfirmScreenState();
}

class _AddressConfirmScreenState extends State<AddressConfirmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetAddressController = TextEditingController();
  String? _selectedBarangay;

  // List of all barangays in Olongapo City
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

  @override
  void dispose() {
    _streetAddressController.dispose();
    super.dispose();
  }

  void _confirmAddress() {
    if (_formKey.currentState!.validate()) {
      // Update user data with address information
      final Map updatedUserData = {
        ...widget.data,
        'address': {
          'city': 'Olongapo City',
          'barangay': _selectedBarangay ?? '',
          'streetAddress': _streetAddressController.text,
        },
      };

      // Navigate to success screen with all user data
      Navigator.navigate() =>
              RegistrationSuccessScreen(data: updatedUserData),
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
                    'Confirm your',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Data',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E45AD), // Blue color from the design
                    ),
                  ),
                  const SizedBox(height: 24),

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
                      hintText: 'Select your barangay',
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
                        return 'Please select your barangay';
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
                      hintText: 'Enter your street name, building, house no.',
                      filled: true,
                      fillColor: const Color(0xFFF5F8FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your street address';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),

                  // Continue button at the bottom
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Button(
                      onPressed: _confirmAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF1E45AD,
                        ), // Blue from design
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Continue',
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

class ServiceProviderSkillsScreen extends StatefulWidget {
  final Map data;

  const ServiceProviderSkillsScreen({super.key, required this.data});

  @override
  State<ServiceProviderSkillsScreen> createState() => _ServiceProviderSkillsScreenState();
}

class _ServiceProviderSkillsScreenState extends State<ServiceProviderSkillsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _professionController = TextEditingController();
  final _experienceController = TextEditingController();
  final _skillsController = TextEditingController();
  final _rateController = TextEditingController();

  // ✅ Standardized professions from centralized config
  final List<String> _professions = ServicesConfig.categoryNames;

  String? _selectedProfession;
  String? _selectedExperience;

  @override
  void dispose() {
    _professionController.dispose();
    _experienceController.dispose();
    _skillsController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _proceedToNext() {
    if (_formKey.currentState!.validate()) {
      // Update user data with skills information
      final Map updatedUserData = {
        ...widget.data,
        'profession': _selectedProfession ?? _professionController.text,
        'experience': _selectedExperience,
        'skills': _skillsController.text,
        'hourlyRate': _rateController.text,
      };

      // Navigate to portfolio/documents screen
      Navigator.navigate() =>
              ServiceProviderPortfolioScreen(data: updatedUserData),
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
                    'Professional',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Information',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E45AD),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Profession/Trade dropdown
                  const Text(
                    'Profession/Trade',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedProfession,
                    decoration: InputDecoration(
                      hintText: 'Select your profession',
                      filled: true,
                      fillColor: const Color(0xFFF5F8FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: _professions.map((String profession) {
                      return DropdownMenuItem<String>(
                        value: profession,
                        child: Text(
                          profession
                              .split(' ')
                              .map(
                                (word) =>
                                    word[0].toUpperCase() + word.substring(1),
                              )
                              .join(' '),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your profession';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Experience level
                  const Text(
                    'Years of Experience',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedExperience,
                    decoration: InputDecoration(
                      hintText: 'Select experience level',
                      filled: true,
                      fillColor: const Color(0xFFF5F8FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: '0-1', child: Text('0-1 years')),
                      DropdownMenuItem(value: '1-3', child: Text('1-3 years')),
                      DropdownMenuItem(value: '3-5', child: Text('3-5 years')),
                      DropdownMenuItem(
                        value: '5-10',
                        child: Text('5-10 years'),
                      ),
                      DropdownMenuItem(value: '10+', child: Text('10+ years')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your experience level';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Skills description
                  const Text(
                    'Skills & Specializations',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  TextFormField(
                    controller: _skillsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Describe your skills and specializations...',
                      filled: true,
                      fillColor: const Color(0xFFF5F8FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe your skills';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Hourly rate
                  const Text(
                    'Hourly Rate (PHP)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  TextFormField(
                    controller: _rateController,
                    decoration: InputDecoration(
                      hintText: 'Enter your hourly rate',
                      filled: true,
                      fillColor: const Color(0xFFF5F8FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      prefixText: '₱ ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your hourly rate';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),

                  // Next button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Button(
                      onPressed: _proceedToNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E45AD),
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

// Enhanced Portfolio Screen with Upload Functionality
class ServiceProviderPortfolioScreen extends StatefulWidget {
  final Map data;

  const ServiceProviderPortfolioScreen({super.key, required this.data});

  @override
  State<ServiceProviderPortfolioScreen> createState() => _ServiceProviderPortfolioScreenState();
}

class _ServiceProviderPortfolioScreenState extends State<ServiceProviderPortfolioScreen> {
  final // Image utility removed _picker = // Image utility removed();

  List<File> _portfolioImages = [];
  File? _idDocument;
  List<File> _certifications = [];

  bool _isUploading = false;
  String _uploadStatus = '';

  Future<void> _pickPortfolioImages() async {
    try {
        requestFullMetadata: false,
      );

      if (images.isNotEmpty) {
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${images.length} portfolio images selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error selecting images: $e')));
    }
  }

  Future<void> _pickIdDocument() async {
    try {
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        setState(() {});

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('ID document captured')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error capturing ID: $e')));
    }
  }

  Future<void> _pickCertifications() async {
    try {
        requestFullMetadata: false,
      );

      if (images.isNotEmpty) {
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${images.length} certifications selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting certifications: $e')),
      );
    }
  }

  Future<void> _uploadDocuments() async {
    setState(() {});

    try {
      final user = // Service call;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final userId = user.uid;

      // Upload portfolio images
      if (_portfolioImages.isNotEmpty) {
        setState(() {});

        final portfolioUrls =
              userId: userId,
              imageFiles: _portfolioImages,
            );

          userId: userId,
          portfolioUrls: portfolioUrls,
        );
      }

      // Upload ID document
      if (_idDocument != null) {
        setState(() {});

          userId: userId,
          imageFile: _idDocument!,
          fileName: 'id_document.jpg',
        );

          userId: userId,
          idDocumentUrl: idUrl,
        );
      }

      // Upload certifications
      if (_certifications.isNotEmpty) {
        setState(() {});

        List<String> certUrls = [];
        for (int i = 0; i < _certifications.length; i++) {
            userId: userId,
            imageFile: _certifications[i],
            fileName: 'certification_${i + 1}.jpg',
          );
          certUrls.add(url);
        }

          userId: userId,
          certificationUrls: certUrls,
        );
      }

      setState(() {});

      // Proceed to address screen
      Navigator.navigate() => AddressConfirmScreen(data: widget.data),
        ),
      );
    } catch (e) {
      setState(() {});

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload error: $e')));
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Portfolio &',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Text(
                'Documents',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E45AD),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Upload your work samples and certifications to build trust with clients.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Portfolio upload
              _buildUploadContainer(
                title: 'Work Portfolio',
                subtitle: _portfolioImages.isEmpty
                    ? 'Upload photos of your completed work'
                    : '${_portfolioImages.length} images selected',
                icon: Icons.photo_library,
                onTap: _pickPortfolioImages,
                hasContent: _portfolioImages.isNotEmpty,
              ),
              const SizedBox(height: 16),

              // ID upload
              _buildUploadContainer(
                title: 'Valid ID',
                subtitle: _idDocument == null
                    ? 'Upload a government-issued ID'
                    : 'ID document captured',
                icon: Icons.badge,
                onTap: _pickIdDocument,
                hasContent: _idDocument != null,
              ),
              const SizedBox(height: 16),

              // Certifications upload
              _buildUploadContainer(
                title: 'Certifications (Optional)',
                subtitle: _certifications.isEmpty
                    ? 'Upload relevant certificates or licenses'
                    : '${_certifications.length} certifications selected',
                icon: Icons.card_membership,
                onTap: _pickCertifications,
                hasContent: _certifications.isNotEmpty,
              ),

              const SizedBox(height: 24),

              // Upload status
              if (_isUploading) ...[
                Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(_uploadStatus),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Button(
                  onPressed: _isUploading
                      ? null
                      : () {
                          if (_portfolioImages.isNotEmpty ||
                              _idDocument != null ||
                              _certifications.isNotEmpty) {
                            _uploadDocuments();
                          } else {
                            // Skip upload and go to address
                            Navigator.navigate() => AddressConfirmScreen(
                                  data: widget.data,
                                ),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E45AD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    _isUploading
                        ? 'Uploading...'
                        : (_portfolioImages.isNotEmpty ||
                              _idDocument != null ||
                              _certifications.isNotEmpty)
                        ? 'Upload & Continue'
                        : 'Skip & Continue',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadContainer({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool hasContent = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasContent
                ? const Color(0xFF1E45AD)
                : const Color(0xFFE0E0E0),
            width: hasContent ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: hasContent
                    ? const Color(0xFF1E45AD).withOpacity(0.1)
                    : const Color(0xFFF5F8FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                hasContent ? Icons.check_circle : icon,
                color: hasContent
                    ? const Color(0xFF1E45AD)
                    : const Color(0xFF1E45AD),
                size: 24,
              ),
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
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: hasContent ? const Color(0xFF1E45AD) : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: hasContent ? const Color(0xFF1E45AD) : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

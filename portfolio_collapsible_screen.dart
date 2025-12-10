class PortfolioCollapsibleScreen extends StatefulWidget {
  final Map? data;
  final bool isViewOnly;

  const PortfolioCollapsibleScreen({
    super.key,
    this.data,
    this.isViewOnly = false,
  });

  @override
  State<PortfolioCollapsibleScreen> createState() =>
      _PortfolioCollapsibleScreenState();
}

class _PortfolioCollapsibleScreenState extends State<PortfolioCollapsibleScreen>
    with TickerProviderStateMixin {
  final // Image utility removed _imagePicker = // Image utility removed();
  final /* FirebaseAuth removed */ _auth = /* FirebaseAuth removed *//* .instance removed */;
  final /* FirebaseFirestore removed */ _firestore = /* FirebaseFirestore removed *//* .instance removed */;

  List<File> portfolioImages = [];
  File? idDocument;
  List<File> certificates = [];
  bool isUploading = false;
  double uploadProgress = 0.0;
  String currentUploadStatus = 'Ready to upload';

  bool isPortfolioExpanded = true;
  bool isIdExpanded = false;
  bool isCertificatesExpanded = false;

  List<String> submittedPortfolioUrls = [];
  String? submittedIdUrl;
  List<String> submittedCertificateUrls = [];
  bool _isLoadingDocuments = false;
  
  // Portfolio submission status
  String submissionStatus = 'pending_review'; // pending_review, approved, rejected
  String submissionMessage = '';
  DateTime? submittedAt;
  double verificationScore = 0.0;

  bool isSubmissionLocked = false;

  // ✅ NEW: Track revision deadline
  DateTime? revisionDeadline;

  // ⭐ REVISION MODE
  bool isEditModeForRejection = false;
  int revisionAttempt = 1;
  String submissionId = '';
  
  // Revision-specific uploads
  List<File> revisedPortfolioImages = [];
  File? revisedIdDocument;
  List<File> revisedCertificates = [];

  late AnimationController _uploadAnimationController;

  @override
  void initState() {
    super.initState();
    _uploadAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Load submitted documents if in view mode
    if (widget.isViewOnly) {
      _isLoadingDocuments = true;  // ✅ NEW: Set loading flag before calling listener
      _loadSubmittedDocuments();
    }
  }

  StreamSubscription? _portfolioListener;
  StreamSubscription? _portfolioSubmissionsListener;

  // 🔄 REAL-TIME LISTENER - Reflects admin decisions immediately
  void _loadSubmittedDocuments() {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Cancel previous listeners if exist
      _portfolioListener?.cancel();
      _portfolioSubmissionsListener?.cancel();

      // Shows ALL submissions (pending, approved, rejected)
      _portfolioSubmissionsListener = _firestore
          // Database operation removed
          // Database operation removed
          // Database operation removed
          /* .orderBy removed */('createdAt', descending: true)
          /* .limit removed */(1) // Get latest submission
          .snapshots()
          .listen(
        (snapshot) {
          debugPrint('� [Portfolio Submissions] Query result: ${snapshot/* .doc removed */s.length} docs');
          
          if (snapshot/* .doc removed */s.isNotEmpty) {
            try {
              final latestDoc = snapshot/* .doc removed */s.first;
              final data = latestDoc.data();
              
              debugPrint('✅ [Portfolio Submission] Loaded: ${latestDoc.id}');
              debugPrint('📝 [Portfolio Submission] Status: ${data['status']}');
              debugPrint('🖼️ [Portfolio Submission] Files: ${(data['files'] as List?)?.length ?? 0}');
              debugPrint('📜 [Portfolio Submission] Certificates: ${(data['certificates'] as List?)?.length ?? 0}');
              
              final newStatus = data['status'] as String? ?? 'pending_review';
              final newFeedback = data['feedback'] as String?;
              final newLocked = data['locked'] as bool? ?? false;
              final newDeadline = data['revisionDeadline'] as /* Timestamp removed */?;
              final newVersion = data['currentVersion'] as int? ?? 1;
              final newCreatedAt = data['createdAt'] as /* Timestamp removed */?;
              
              // LOAD PORTFOLIO IMAGES from portfolio_submissions
              if (submittedPortfolioUrls.isEmpty && data['files'] != null) {
                setState(() {});
              }
              
              // Update status and metadata
              final hasStatusChange = submissionStatus != newStatus;
              if (hasStatusChange || 
                  isSubmissionLocked != newLocked || 
                  revisionDeadline != newDeadline?.toDate() ||
                  _isLoadingDocuments) {
                setState(() {});
              }
            } catch (e) {
              debugPrint('❌ Error processing portfolio submission: $e');
              if (_isLoadingDocuments) {
                setState(() => _isLoadingDocuments = false);
              }
            }
          } else {
            // No submissions yet
            debugPrint('⚠️ [Portfolio] No submissions found for user ${user.uid}');
            
            if (_isLoadingDocuments) {
              setState(() {});
            }
          }
        },
        onError: (error) {
          debugPrint('❌ Portfolio submissions listener error: $error');
          if (_isLoadingDocuments) {
            setState(() => _isLoadingDocuments = false);
          }
        },
      );
    } catch (e) {
      debugPrint('❌ Error loading portfolio submissions: $e');
      if (_isLoadingDocuments) {
        setState(() => _isLoadingDocuments = false);
      }
    }
  }

  @override
  void dispose() {
    _uploadAnimationController.dispose();
    _portfolioListener?.cancel();  // Cancel old listener (if it exists)
    _portfolioSubmissionsListener?.cancel();  // Cancel portfolio submissions listener
    super.dispose();
  }

  // MARK: Image picking methods
  Future<void> _pickPortfolioImages() async {
      imageQuality: 70,  // Reduced from 90 for faster processing
    );

    setState(() {});
  }

  Future<void> _pickIdDocument() async {
      source: ImageSource.camera,
      imageQuality: 75,  // Reduced from 90 for faster processing
    );

    if (image != null) {
      setState(() => idDocument = File(image.path));
    }
  }

  Future<void> _pickCertificates() async {
      imageQuality: 70,  // Reduced from 85 for faster processing
    );

    setState(() {});
  }

  void _removePortfolioImage(int index) {
    setState(() => portfolioImages.removeAt(index));
  }

  void _removeCertificate(int index) {
    setState(() => certificates.removeAt(index));
  }

  Future<void> _submitPortfolio() async {
    if (portfolioImages.isEmpty || idDocument == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add portfolio images and ID')),
      );
      return;
    }

    setState(() {});

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Upload portfolio images to Cloudinary
      List<String> portfolioUrls = [];
      for (int i = 0; i < portfolioImages.length; i++) {
        setState(() {
          currentUploadStatus = 'Uploading portfolio image ${i + 1}/${portfolioImages.length}...';
          uploadProgress = (i / portfolioImages.length) * 0.4;
        });

          portfolioImages[i],
          'portfolio_${user.uid}_${DateTime.now().millisecondsSinceEpoch}_$i',
          'portfolio', // ✅ Type: portfolio
        );
        portfolioUrls.add(url);
      }

      // Upload ID document to Cloudinary
      setState(() {});

        idDocument!,
        'id_${user.uid}_${DateTime.now().millisecondsSinceEpoch}',
        'id', // ✅ Type: id
      );

      // Upload certificates to Cloudinary
      List<String> certificateUrls = [];
      for (int i = 0; i < certificates.length; i++) {
        setState(() {
          currentUploadStatus = 'Uploading certificate ${i + 1}/${certificates.length}...';
          uploadProgress = 0.5 + (i / certificates.length) * 0.4;
        });

          certificates[i],
          'certificate_${user.uid}_${DateTime.now().millisecondsSinceEpoch}_$i',
          'certificate', // ✅ Type: certificate
        );
        certificateUrls.add(url);
      }

      // Create submission data with uploaded URLs
      // 🔴 ADMIN TEAM: These are the EXACT fields mobile writes. Don't rename or remove.
      final submissionData = {
        'serviceproviderId': user.uid,
        // ✅ RENAMED: portfolioImages → files (backend spec)
        // 🔴 ADMIN: Keep field name as 'files' (array of image URLs)
        'files': portfolioUrls,
        // Keep optional extras (not in spec but useful):
        'idDocument': idUrl,
        'certificates': certificateUrls,
        'portfolioCount': portfolioImages.length,
        'certificateCount': certificates.length,
        // ✅ RENAMED: submittedAt → createdAt (server timestamp)
        // 🔴 ADMIN: Use this for ordering, don't modify
        'createdAt': /* FieldValue removed */.server/* Timestamp removed */(),
        // ✅ NEW: updatedAt
        // 🔴 ADMIN: Update this timestamp when making changes
        'updatedAt': /* FieldValue removed */.server/* Timestamp removed */(),
        'status': 'pending_review',  // 🔴 ADMIN: You will update this to: approved, rejected, or needs_revision
        // ✅ NEW: currentVersion (for tracking revisions)
        // 🔴 ADMIN: Increment this when user resubmits (starts at 1)
        'currentVersion': 1,
        // ✅ NEW: revisionDeadline (admin will set if needs revision)
        // 🔴 ADMIN: Set to /* Timestamp removed */ if status='needs_revision', null if approved/rejected
        'revisionDeadline': null,
        // ✅ NEW: feedback (admin will write this)
        // 🔴 ADMIN: Your review notes for the user
        'feedback': null,
        // ✅ NEW: locked flag (prevents editing during review)
        // 🔴 ADMIN: Set to true when under review, false when decision is made
        'locked': false,
      };

      setState(() {});

      // Write to BOTH collections with identical data
      
      // Write to admin_verification_queue for admin review
          // Database operation removed
          .add(submissionData);

      // 🔴 ADMIN: When you make a decision (approve/reject/revision),
      // Mobile only listens to this collection, not admin_verification_queue!
      // If you don't update this one, mobile won't see your decision.
          // Database operation removed
          // Database operation removed
          // Database operation removed
          .add(submissionData);

      setState(() {});

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {}
    } catch (e) {
      setState(() {});

      if (mounted) {}
    }
  }

  /// Upload file to Cloudinary using multipart form data
  /// [type] can be: 'portfolio', 'id', or 'certificate'
  Future<String> _uploadToCloudinary(
    File file,
    String publicId,
    String type,
  ) async {
    try {
      const cloudName = 'ds1kgj0jn';

      // Get the correct preset and folder based on type
      late String uploadPreset;
      late String folder;
      
      switch (type.toLowerCase()) {
        case 'portfolio':
          uploadPreset = 'appname_portfolios';
          folder = 'appname/portfolios';
          break;
        case 'id':
          uploadPreset = 'appname_id_photos';
          folder = 'appname/ids';
          break;
        case 'certificate':
          uploadPreset = 'appname_certificates';
          folder = 'appname/certificates';
          break;
        default:
          uploadPreset = 'appname_portfolios';
          folder = 'appname/portfolios';
      }

      // Network call removed

      // Network call removed
        ..fields['upload_preset'] = uploadPreset
        ..fields['public_id'] = publicId
        ..fields['folder'] = folder
        ..files.add(
            'file',
            file.path,
          ),
        );


      if (response.statusCode == 200) {
        final responseString = String.fromCharCodes(responseData);
        final jsonResponse = jsonDecode(responseString);
        return jsonResponse['secure_url'] ?? jsonResponse['url'];
      } else {
        final errorString = String.fromCharCodes(errorData);
        throw Exception('Cloudinary upload failed: ${response.statusCode} - $errorString');
      }
    } catch (e) {
      rethrow;
    }
  }

  // ⭐ REVISION MODE HANDLER
  void _handleEnterRevisionMode() {
    // Navigate to revision upload screen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Screen()) => PortfolioCollapsibleScreen(
          data: widget.data,
          isViewOnly: false,
        ),
      ),
    );
  }

  // ⭐ IMAGE PICKERS FOR REVISIONS
  Future<void> _pickRevisedPortfolioImages() async {
    setState(() {});
  }

  Future<void> _pickRevisedIdDocument() async {
      source: ImageSource.camera,
      imageQuality: 75,
    );
    if (image != null) {
      setState(() => revisedIdDocument = File(image.path));
    }
  }

  Future<void> _pickRevisedCertificates() async {
    setState(() {});
  }

  // ⭐ MAIN RESUBMIT METHOD - BACKEND INTEGRATION
  Future<void> _handleResubmitRevision() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    // Validate at least one document changed
    if (revisedPortfolioImages.isEmpty &&
        revisedIdDocument == null &&
        revisedCertificates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please update at least one document'),
        ),
      );
      return;
    }

    setState(() {});

    try {
      setState(() => currentUploadStatus = 'Uploading revised documents...');
      
      // STEP 1: Upload revised portfolio images to Cloudinary (same as original)
      List<String> revisedPortfolioUrls = [];
      for (int i = 0; i < revisedPortfolioImages.length; i++) {
        setState(() {
          currentUploadStatus = 'Uploading portfolio image ${i + 1}/${revisedPortfolioImages.length}...';
        });
          revisedPortfolioImages[i],
          'portfolio_revised_${user.uid}_${DateTime.now().millisecondsSinceEpoch}_$i',
          'portfolio',
        );
        revisedPortfolioUrls.add(url);
      }

      // STEP 2: Upload revised ID document to Cloudinary
      String? revisedIdUrl;
      if (revisedIdDocument != null) {
        setState(() => currentUploadStatus = 'Uploading ID document...');
          revisedIdDocument!,
          'id_revised_${user.uid}_${DateTime.now().millisecondsSinceEpoch}',
          'id',
        );
      }

      // STEP 3: Upload revised certificates to Cloudinary
      List<String> revisedCertificateUrls = [];
      for (int i = 0; i < revisedCertificates.length; i++) {
        setState(() {
          currentUploadStatus = 'Uploading certificate ${i + 1}/${revisedCertificates.length}...';
        });
          revisedCertificates[i],
          'certificate_revised_${user.uid}_${DateTime.now().millisecondsSinceEpoch}_$i',
          'certificate',
        );
        revisedCertificateUrls.add(url);
      }

      // STEP 4: ✅ NEW - Call backend API to resubmit
      setState(() => currentUploadStatus = 'Submitting to backend...');

      try {
          // Network call removed
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'submissionId': submissionId,
            'serviceproviderId': user.uid,
            'files': revisedPortfolioUrls.isNotEmpty ? revisedPortfolioUrls : submittedPortfolioUrls,
          }),
        );

        if (response.statusCode != 200) {
          throw Exception('Backend resubmit failed: ${response.body}');
        }

        setState(() => currentUploadStatus = 'Backend updated, refreshing UI...');
      } catch (e) {
        throw Exception('API call failed: $e');
      }

      // STEP 5: Update UI
      setState(() {
        isEditModeForRejection = false;
        submissionStatus = 'pending_review';
        revisionAttempt = revisionAttempt + 1;
        currentUploadStatus = 'Revision uploaded successfully!';

        // Update submitted URLs with revised ones
        if (revisedPortfolioUrls.isNotEmpty) {
          submittedPortfolioUrls = revisedPortfolioUrls;
        }
        if (revisedIdUrl != null) {
          submittedIdUrl = revisedIdUrl;
        }
        if (revisedCertificateUrls.isNotEmpty) {
          submittedCertificateUrls = revisedCertificateUrls;
        }

        // Clear revision uploads
        revisedPortfolioImages.clear();
        revisedIdDocument = null;
        revisedCertificates.clear();
      });

      // STEP 6: Show success
      if (mounted) {} submitted!\nOur team will review within 24-48 hours.',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
      }

      // STEP 7: Reload submission status (listener will auto-update)
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.navigate();
    } catch (e) {
      if (mounted) {}',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show view mode for viewing submitted portfolio
    if (widget.isViewOnly) {
      return _buildViewMode();
    }

    // Show edit mode for uploading new portfolio
    return _buildEditMode();
  }

  // ✅ NEW: Calculate responsive grid columns based on screen width
  int _getResponsiveGridColumns(int defaultColumns) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Extra small devices (< 360)
    if (screenWidth < 360) {
      return 1;
    }
    // Small devices (360-599)
    else if (screenWidth < 600) {
      return defaultColumns;
    }
    // Medium devices (600-900)
    else if (screenWidth < 900) {
      return (defaultColumns * 1.5).toInt().clamp(1, 4);
    }
    // Large devices (900+)
    else {
      return (defaultColumns * 2).toInt().clamp(1, 6);
    }
  }

  // ✅ NEW: Get responsive image height based on screen width
  double _getResponsiveImageHeight() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 360) {
      return 150;
    } else if (screenWidth < 600) {
      return 180;
    } else if (screenWidth < 900) {
      return 220;
    } else {
      return 280;
    }
  }

  Widget _buildWidget() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('My Portfolio'),
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E40AF),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF1E40AF)),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Current'),
              Tab(text: 'History'),
            ],
            indicatorColor: Color(0xFF1E40AF),
            labelColor: Color(0xFF1E40AF),
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Current Portfolio
            _isLoadingDocuments
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ NEW: Check if user has NO submission at all
                        if (submittedPortfolioUrls.isEmpty &&
                            submittedIdUrl == null &&
                            submittedCertificateUrls.isEmpty)
                          _buildNoSubmissionContainer()
                        else
                          // Status /* payment_logic */ - Top Priority (only show if submission exists)
                          _buildStatusContainer(),
                        
                        const SizedBox(height: 24),

                        // ⭐ REVISION MODE UI
                        if (isEditModeForRejection &&
                            (submissionStatus == 'rejected' ||
                                submissionStatus == 'needs_revision')) ...[
                          _buildRevisionModeHeader(),
                          const SizedBox(height: 16),
                          _buildRevisionPortfolioSection(),
                          const SizedBox(height: 16),
                          _buildRevisionIdSection(),
                          const SizedBox(height: 16),
                          _buildRevisionCertificatesSection(),
                          const SizedBox(height: 16),
                          _buildRevisionSubmitButton(),
                          const SizedBox(height: 24),
                        ],

                        // Documents sections in organized cards
                        // ✅ RESPONSIVE: Grid columns adjust based on screen size
                        _buildDocumentSection(
                          title: 'Portfolio Images',
                          icon: Icons.image_outlined,
                          color: const Color(0xFF1E40AF),
                          urls: submittedPortfolioUrls,
                          gridColumns: _getResponsiveGridColumns(2),
                        ),

                        const SizedBox(height: 16),

                        _buildDocumentSection(
                          title: 'ID Document',
                          icon: Icons.card_giftcard,
                          color: const Color(0xFF10B981),
                          urls: submittedIdUrl != null ? [submittedIdUrl!] : [],
                          gridColumns: 1,
                          isSingleLarge: true,
                        ),

                        const SizedBox(height: 16),

                        _buildDocumentSection(
                          title: 'Certificates & Credentials',
                          icon: Icons.school_outlined,
                          color: const Color(0xFF7C3AED),
                          urls: submittedCertificateUrls,
                          gridColumns: _getResponsiveGridColumns(3),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
            // Tab 2: History Timeline
            _buildHistoryTab(),
          ],
        ),
      ),
    );
  }

  // ✅ NEW: Build History Tab with timeline of all portfolio submissions
  Widget _buildWidget() {
    final user = _auth.currentUser;
    if (user == null) {
      return Center(
        child: Text(
          'Please log in to view history',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return FutureBuilder</* QuerySnapshot removed */>(
      future: _firestore
          // Database operation removed
          /* .where removed */('serviceproviderId', isEqualTo: user.uid)
          /* .get removed */(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!/* .doc removed */s.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No submission history',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your portfolio submissions will appear here',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Sort by decision date (newest first)
        final decisions = snapshot.data!/* .doc removed */s;
        decisions.sort((a, b) {
          final dateA = a['decisionDate'] as /* Timestamp removed */?;
          final dateB = b['decisionDate'] as /* Timestamp removed */?;
          if (dateA == null || dateB == null) return 0;
          return dateB.compareTo(dateA);
        });

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: List.generate(
              decisions.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildHistoryTimelineItem(
                  decision: decisions[index],
                  isFirst: index == 0,
                  isLast: index == decisions.length - 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ✅ NEW: Build single history timeline item
  Widget _buildHistoryTimelineItem({
    required Query/* DocumentSnapshot removed */ decision,
    required bool isFirst,
    required bool isLast,
  }) {
    final data = decision.data() as Map?;
    if (data == null) {
      return const SizedBox.shrink();
    }

    final decisionStatus = data['decision'] as String?;
    final decisionDate = data['decisionDate'] as /* Timestamp removed */?;
    final adminNotes = data['adminNotes'] as String?;
    final currentVersion = data['currentVersion'] as int?;

    Color statusColor;
    IconData statusIcon;
    String statusLabel;

    switch (decisionStatus) {
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusLabel = 'Approved';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusLabel = 'Rejected';
        break;
      case 'needs_revision':
        statusColor = Colors.blue;
        statusIcon = Icons.edit;
        statusLabel = 'Needs Revision';
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        statusLabel = 'Pending';
    }

    return Column(
      children: [
        // Timeline connector line (vertical)
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 22, bottom: 8),
            child: Container(
              width: 2,
              height: 16,
              color: Colors.grey[300],
            ),
          ),
        // Timeline item
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline dot
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: statusColor, width: 2),
              ),
              child: Icon(statusIcon, color: statusColor, size: 24),
            ),
            const SizedBox(width: 12),
            // Timeline content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status and date row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                        if (decisionDate != null)
                          Text(
                            _formatDate(decisionDate.toDate()),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                    // Version info (only if it exists)
                    if (currentVersion != null && currentVersion > 0) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Version $currentVersion',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    // Admin notes if exists
                    if (adminNotes != null && adminNotes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin Feedback',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              adminNotes,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[800],
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ✅ NEW: Show when user hasn't submitted any portfolio yet
  Widget _buildWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[100]!,
            Colors.grey[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.folder_open_outlined,
                  color: Colors.grey[600],
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'No Portfolio Yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get started to showcase your work',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ✅ MINIMIZED: What to upload - simplified
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.blue.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[600], size: 16),
                    const SizedBox(width: 6),
                    const Text(
                      'Required:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const SizedBox(width: 22),
                    Expanded(
                      child: Text(
                        '• Valid ID (required)',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const SizedBox(width: 22),
                    Expanded(
                      child: Text(
                        '• Portfolio images (1-5 images)',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const SizedBox(width: 22),
                    Expanded(
                      child: Text(
                        '• Certificates (optional)',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ✅ Call to action - Links to Portfolio Upload Screen
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to Portfolio screen in EDIT mode (not view mode)
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Screen()) => const PortfolioCollapsibleScreen(
                      isViewOnly: false,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Start Building Portfolio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E40AF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Helper for checklist items
  // REMOVED - No longer needed (simplified minimized UI)

  // ✅ Helper for step items
  // REMOVED - No longer needed (simplified minimized UI)

  // ✅ REDESIGNED: Compact status /* payment_logic */ with better UX
  // ✅ REDESIGNED: Compact status /* payment_logic */ - NO DUPLICATION
  Widget _buildWidget() {
    final isApproved = submissionStatus == 'approved';
    final isRejected = submissionStatus == 'rejected';
    final needsRevision = submissionStatus == 'needs_revision';

    Color statusColor;
    IconData statusIcon;
    String statusText;
    String statusDescription;

    if (isApproved) {
      statusColor = const Color(0xFF10B981);
      statusIcon = Icons.check_circle;
      statusText = 'APPROVED ✓';
      statusDescription = 'Your portfolio is verified!';
    } else if (isRejected) {
      statusColor = const Color(0xFFEF4444);
      statusIcon = Icons.cancel;
      statusText = 'REJECTED';
      statusDescription = submissionMessage.isNotEmpty 
          ? submissionMessage 
          : 'Portfolio did not meet requirements';
    } else if (needsRevision) {
      statusColor = const Color(0xFF6366F1);
      statusIcon = Icons.edit;
      statusText = 'REVISIONS NEEDED';
      statusDescription = submissionMessage.isNotEmpty 
          ? submissionMessage 
          : 'Please make the requested changes';
    } else {
      statusColor = const Color(0xFFF59E0B);
      statusIcon = Icons.schedule;
      statusText = 'UNDER REVIEW';
      statusDescription = 'Our team is reviewing (24-48 hrs)';
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusColor.withOpacity(0.1),
            statusColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ COMPACT: Status + Description + Metadata in one /* payment_logic */
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  statusIcon,
                  color: statusColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      statusDescription,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // ✅ Version + Date on one line
                    Row(
                      children: [
                        Icon(Icons.history, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          'v$revisionAttempt • ${_formatDate(submittedAt ?? DateTime.now())}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ✅ COMPACT: Buttons side-by-side
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              // Resubmit button
              if (isRejected || needsRevision)
                ElevatedButton.icon(
                  onPressed: _handleEnterRevisionMode,
                  icon: const Icon(Icons.edit, size: 14),
                  label: const Text('Resubmit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

              // Upload new button
              if (isApproved)
                ElevatedButton.icon(
                  onPressed: _handleUploadNewPortfolio,
                  icon: const Icon(Icons.add_a_photo, size: 14),
                  label: const Text('Upload New'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

              // Help button
              if (!isApproved)
                OutlinedButton.icon(
                  onPressed: _showHelpDialog,
                  icon: const Icon(Icons.help_outline, size: 14),
                  label: const Text('Help'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ NEW: Upload new portfolio (not revision)
  void _handleUploadNewPortfolio() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Screen()) => const PortfolioCollapsibleScreen(
          isViewOnly: false,
        ),
      ),
    );
  }

  // ✅ NEW: Help dialog
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Portfolio Tips'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('✓ Clear, well-lit images'),
            const SizedBox(height: 8),
            const Text('✓ ID document fully visible'),
            const SizedBox(height: 8),
            const Text('✓ Professional appearance'),
            const SizedBox(height: 12),
            Text(
              'Contact: support@appname.app',
              style: TextStyle(
                fontSize: 11,
                color: Colors.blue[600],
              ),
            ),
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> urls,
    required int gridColumns,
    bool isSingleLarge = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${urls.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (urls.isNotEmpty) ...[
            isSingleLarge
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      urls[0],
                      height: _getResponsiveImageHeight(),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                        height: _getResponsiveImageHeight(),
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridColumns,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: urls.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          urls[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      );
                    },
                  ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: 32,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No documents yet',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ⭐ REVISION MODE UI BUILDERS
  Widget _buildWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.edit_note,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revision Mode - Revision $revisionAttempt/3',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Update your documents and resubmit for review',
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
    );
  }

  Widget _buildWidget() {
    return _buildRevisionSection(
      title: '📸 Portfolio Images (Revised)',
      instruction: 'Upload clearer, brighter images',
      currentFiles: revisedPortfolioImages,
      onAdd: _pickRevisedPortfolioImages,
      onRemove: (index) {
        setState(() => revisedPortfolioImages.removeAt(index));
      },
    );
  }

  Widget _buildWidget() {
    return _buildRevisionSection(
      title: '🆔 ID Document (Revised)',
      instruction: 'Make sure text is clear and fully visible',
      currentFiles: revisedIdDocument != null ? [revisedIdDocument!] : [],
      onAdd: _pickRevisedIdDocument,
      onRemove: (_) {
        setState(() => revisedIdDocument = null);
      },
    );
  }

  Widget _buildWidget() {
    return _buildRevisionSection(
      title: '🎓 Certificates (Optional)',
      instruction: 'Leave empty if unchanged',
      currentFiles: revisedCertificates,
      onAdd: _pickRevisedCertificates,
      onRemove: (index) {
        setState(() => revisedCertificates.removeAt(index));
      },
    );
  }

  Widget _buildRevisionSection({
    required String title,
    required String instruction,
    required List<File> currentFiles,
    required VoidCallback onAdd,
    required Function(int) onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300] ?? Colors.grey,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            instruction,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          if (currentFiles.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                currentFiles.length,
                (index) => Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(currentFiles[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -8,
                      right: -8,
                      child: GestureDetector(
                        onTap: () => onRemove(index),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_photo_alternate),
              label: Text(
                currentFiles.isEmpty ? 'Add Files' : 'Replace/Add More',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    final hasChanges = revisedPortfolioImages.isNotEmpty ||
        revisedIdDocument != null ||
        revisedCertificates.isNotEmpty;
    // ✅ NEW: Disable resubmit when portfolio is locked
    final canResubmit = hasChanges && !isUploading && !isSubmissionLocked;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: canResubmit
                ? _handleResubmitRevision
                : null,
            icon: isUploading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.cloud_upload),
            label: Text(
              isUploading
                  ? 'Uploading: $currentUploadStatus'
                  : 'Submit Revisions for Review',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              disabledBackgroundColor: Colors.grey[300],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        if (!hasChanges)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Please make changes to at least one document',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        // ✅ NEW: Show message when locked
        if (isSubmissionLocked)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(Icons.lock, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  'Portfolio is under review - resubmission disabled',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  Widget _buildWidget() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Portfolio'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: isUploading
          ? _buildUploadingState()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modern minimal header
                  _buildModernHeader(),

                  const SizedBox(height: 20),

                  // Step progress indicator
                  _buildStepProgress(),

                  const SizedBox(height: 24),

                  // Portfolio Images Section
                  _buildModernSection(
                    title: 'Portfolio Images',
                    subtitle: 'Showcase your best work',
                    icon: Icons.photo_library_outlined,
                    isRequired: true,
                    isComplete: portfolioImages.isNotEmpty,
                    count: portfolioImages.length,
                    maxCount: 5,
                    isExpanded: isPortfolioExpanded,
                    onTap: () => setState(() => isPortfolioExpanded = !isPortfolioExpanded),
                    child: _buildPortfolioContent(),
                  ),

                  const SizedBox(height: 12),

                  // ID Document Section
                  _buildModernSection(
                    title: 'ID Document',
                    subtitle: 'Verify your identity',
                    icon: Icons.badge_outlined,
                    isRequired: true,
                    isComplete: idDocument != null,
                    count: idDocument != null ? 1 : 0,
                    maxCount: 1,
                    isExpanded: isIdExpanded,
                    onTap: () => setState(() => isIdExpanded = !isIdExpanded),
                    child: _buildIdContent(),
                  ),

                  const SizedBox(height: 12),

                  // Certificates Section
                  _buildModernSection(
                    title: 'Certificates',
                    subtitle: 'Add your credentials',
                    icon: Icons.workspace_premium_outlined,
                    isRequired: false,
                    isComplete: certificates.isNotEmpty,
                    count: certificates.length,
                    maxCount: 5,
                    isExpanded: isCertificatesExpanded,
                    onTap: () => setState(() => isCertificatesExpanded = !isCertificatesExpanded),
                    child: _buildCertificatesContent(),
                  ),

                  const SizedBox(height: 32),

                  // Submit button
                  _buildSubmitButton(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // MODERN UI COMPONENTS
  // ═══════════════════════════════════════════════════════════

  Widget _buildWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Build Your Portfolio',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Complete your profile to start getting hired',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildWidget() {
    int completedSteps = 0;
    if (portfolioImages.isNotEmpty) completedSteps++;
    if (idDocument != null) completedSteps++;
    if (certificates.isNotEmpty) completedSteps++;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: completedSteps == 3 
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : const Color(0xFF1E40AF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$completedSteps of 3',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: completedSteps == 3 
                        ? const Color(0xFF10B981)
                        : const Color(0xFF1E40AF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Step indicators
          Row(
            children: [
              _buildStepDot(
                label: 'Photos',
                isComplete: portfolioImages.isNotEmpty,
                isFirst: true,
              ),
              _buildStepLine(portfolioImages.isNotEmpty),
              _buildStepDot(
                label: 'ID',
                isComplete: idDocument != null,
              ),
              _buildStepLine(idDocument != null),
              _buildStepDot(
                label: 'Certs',
                isComplete: certificates.isNotEmpty,
                isLast: true,
                isOptional: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepDot({
    required String label,
    required bool isComplete,
    bool isFirst = false,
    bool isLast = false,
    bool isOptional = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isComplete 
                  ? const Color(0xFF10B981)
                  : Colors.white,
              border: Border.all(
                color: isComplete 
                    ? const Color(0xFF10B981)
                    : const Color(0xFFCBD5E1),
                width: 2,
              ),
            ),
            child: Icon(
              isComplete ? Icons.check : Icons.circle,
              size: isComplete ? 18 : 8,
              color: isComplete ? Colors.white : const Color(0xFFCBD5E1),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isComplete ? const Color(0xFF10B981) : Colors.grey[500],
            ),
          ),
          if (isOptional)
            Text(
              '(optional)',
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[400],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepLine(bool isComplete) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: isComplete 
              ? const Color(0xFF10B981)
              : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildModernSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isRequired,
    required bool isComplete,
    required int count,
    required int maxCount,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isComplete 
              ? const Color(0xFF10B981).withOpacity(0.3)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          // Header - always visible
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isComplete 
                          ? const Color(0xFF10B981).withOpacity(0.1)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isComplete 
                          ? const Color(0xFF10B981)
                          : const Color(0xFF64748B),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Title & Status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            if (!isRequired) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Optional',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isComplete 
                              ? '$count/$maxCount added'
                              : subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: isComplete 
                                ? const Color(0xFF10B981)
                                : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status indicator & expand icon
                  Row(
                    children: [
                      if (isComplete)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Color(0xFF10B981),
                            size: 14,
                          ),
                        ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: child,
            ),
            crossFadeState: isExpanded 
                ? CrossFadeState.showSecond 
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    // Adaptive columns based on image count
    int columns = portfolioImages.length <= 2 ? 2 : 3;
    
    return Column(
      children: [
        Container(
          height: 1,
          color: const Color(0xFFF1F5F9),
          margin: const EdgeInsets.only(bottom: 16),
        ),
        // Images grid
        if (portfolioImages.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: portfolioImages.length <= 2 ? 1.0 : 1.0,
            ),
            itemCount: portfolioImages.length,
            itemBuilder: (context, index) => _buildImageTile(
              file: portfolioImages[index],
              onRemove: () => _removePortfolioImage(index),
            ),
          ),
          const SizedBox(height: 12),
        ],
        // Add button
        if (portfolioImages.length < 5)
          _buildModernAddButton(
            onTap: _pickPortfolioImages,
            label: portfolioImages.isEmpty ? 'Add Images' : 'Add More',
            icon: Icons.add_photo_alternate_outlined,
          ),
        const SizedBox(height: 8),
        Text(
          '${portfolioImages.length}/5 images',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildWidget() {
    return Column(
      children: [
        Container(
          height: 1,
          color: const Color(0xFFF1F5F9),
          margin: const EdgeInsets.only(bottom: 16),
        ),
        if (idDocument != null) ...[
          // ID preview
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.file(
                  idDocument!,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildRemoveButton(() => setState(() => idDocument = null)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF10B981),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'ID document added',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          // ID types hint
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Accepted IDs',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildIdChip('National ID'),
                    _buildIdChip('Passport'),
                    _buildIdChip("Driver's License"),
                    _buildIdChip('SSS/BIR ID'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildModernAddButton(
            onTap: _pickIdDocument,
            label: 'Take Photo of ID',
            icon: Icons.camera_alt_outlined,
          ),
        ],
      ],
    );
  }

  Widget _buildIdChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildWidget() {
    return Column(
      children: [
        Container(
          height: 1,
          color: const Color(0xFFF1F5F9),
          margin: const EdgeInsets.only(bottom: 16),
        ),
        // Certificates grid
        if (certificates.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: certificates.length,
            itemBuilder: (context, index) => _buildImageTile(
              file: certificates[index],
              onRemove: () => _removeCertificate(index),
            ),
          ),
          const SizedBox(height: 12),
        ],
        // Add button
        if (certificates.length < 5)
          _buildModernAddButton(
            onTap: _pickCertificates,
            label: certificates.isEmpty ? 'Add Certificates' : 'Add More',
            icon: Icons.upload_file_outlined,
          ),
        const SizedBox(height: 8),
        Text(
          '${certificates.length}/5 certificates',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildImageTile({required File file, required VoidCallback onRemove}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(file, fit: BoxFit.cover),
          Positioned(
            top: 4,
            right: 4,
            child: _buildRemoveButton(onRemove),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveButton(VoidCallback onRemove) {
    return GestureDetector(
      onTap: onRemove,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close,
          color: Colors.white,
          size: 14,
        ),
      ),
    );
  }

  Widget _buildModernAddButton({
    required VoidCallback onTap,
    required String label,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF1E40AF).withOpacity(0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF1E40AF).withOpacity(0.04),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFF1E40AF),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E40AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidget() {
    final bool canSubmit = portfolioImages.isNotEmpty && idDocument != null;
    
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: Button(
            onPressed: canSubmit ? _submitPortfolio : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E40AF),
              disabledBackgroundColor: const Color(0xFFE2E8F0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Text(
              'Submit Portfolio',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: canSubmit ? Colors.white : Colors.grey[500],
              ),
            ),
          ),
        ),
        if (!canSubmit) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                'Add portfolio images and ID to submit',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }


  Widget _buildCollapsibleSection({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onTap,
    required int itemCount,
    required int maxItems,
    required Widget child,
    bool isOptional = false,
  }) {
    final isComplete = itemCount == maxItems;
    final isPartiallyComplete = itemCount > 0 && itemCount < maxItems;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isComplete
                  ? const Color(0xFF10B981).withOpacity(0.3)
                  : const Color(0xFF1E40AF).withOpacity(0.15),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icon with background
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isComplete
                            ? const Color(0xFF10B981).withOpacity(0.1)
                            : const Color(0xFF1E40AF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: isComplete
                            ? const Color(0xFF10B981)
                            : const Color(0xFF1E40AF),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title and count
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              if (isOptional) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Optional',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (isComplete)
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF10B981),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Complete',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          else if (isPartiallyComplete)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '$itemCount/$maxItems items',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              'Not started',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),

                    // Expand/collapse icon
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.expand_more,
                        color: Colors.grey[600],
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Expandable content
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: isExpanded
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 1,
                              color: Colors.grey[200],
                              margin: const EdgeInsets.only(bottom: 16),
                            ),
                            child,
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddImageContainer(VoidCallback onTap,
      {Color color = const Color(0xFF1E40AF)}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.05),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: color, size: 36),
              const SizedBox(height: 4),
              Text(
                'Add',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidget() {
    final totalSteps = 3;
    int completedSteps = 0;

    if (portfolioImages.isNotEmpty) completedSteps++;
    if (idDocument != null) completedSteps++;
    if (certificates.isNotEmpty) completedSteps++;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: completedSteps / totalSteps,
                    minHeight: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      completedSteps == totalSteps
                          ? const Color(0xFF10B981)
                          : const Color(0xFF1E40AF),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$completedSteps/$totalSteps',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E40AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Upload icon with subtle animation
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E40AF).withOpacity(0.1),
              ),
              child: const Center(
                child: Icon(
                  Icons.cloud_upload_outlined,
                  color: Color(0xFF1E40AF),
                  size: 44,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Uploading Portfolio',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentUploadStatus,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Progress bar
            Container(
              width: 200,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: const Color(0xFFE2E8F0),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: uploadProgress,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: const Color(0xFF1E40AF),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${(uploadProgress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E40AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

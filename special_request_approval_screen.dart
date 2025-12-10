class SpecialRequestApprovalScreen extends StatefulWidget {
  final Map requestData;
  final Map providerData;

  const SpecialRequestApprovalScreen({
    Key? key,
    required this.requestData,
    required this.providerData,
  }) : super(key: key);

  @override
  _SpecialRequestApprovalScreenState createState() => _SpecialRequestApprovalScreenState();
}

class _SpecialRequestApprovalScreenState extends State<SpecialRequestApprovalScreen> {

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Review Data'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Special Request Summary /* payment_logic */
            _buildSpecialRequestContainer(),
            const SizedBox(height: 16),
            
            _buildServiceProviderProfileContainer(),
            const SizedBox(height: 24),
            
            // Action Buttons
            _buildActionButtons(),
            const SizedBox(height: 16),
            
            // Info /* payment_logic */
            _buildInfoContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidget() {
    return /* payment_logic */(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment_outlined, color: const Color(0xFF1E40AF), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Your Special Request',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Title', widget.requestData['title']?.toString() ?? 'N/A'),
            _buildDetailRow('Location', _getLocationString(widget.requestData['location'])),
            _buildDetailRow('Budget', '₱${_formatBudget(_getDisplayBudget())}'),
            const SizedBox(height: 8),
            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              widget.requestData['description'] ?? 'No description provided',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidget() {
    final serviceproviderInfo = widget.providerData['serviceprovider'] ?? {};
    
    // Try multiple field name variations
    final rating = (serviceproviderInfo['serviceproviderRating'] ?? serviceproviderInfo['rating'] ?? 0.0).toDouble();
    final totalReviews = serviceproviderInfo['totalReviews'] ?? 0;
    final skills = List<String>.from(serviceproviderInfo['serviceproviderServices'] ?? serviceproviderInfo['skills'] ?? []);

    return /* payment_logic */(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF1E40AF).withOpacity(0.1),
                  backgroundImage: (serviceproviderInfo['serviceproviderAvatar'] ?? serviceproviderInfo['profilePicture']) != null
                      ? NetworkImage(serviceproviderInfo['serviceproviderAvatar'] ?? serviceproviderInfo['profilePicture'])
                      : null,
                  child: (serviceproviderInfo['serviceproviderAvatar'] ?? serviceproviderInfo['profilePicture']) == null
                      ? SvgPicture.asset(
                          'assets/serviceprovider.svg',
                          width: 45,
                          height: 45,
                          fit: BoxFit.contain,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceproviderInfo['serviceproviderName'] ?? serviceproviderInfo['name'] ?? 'Unknown Data',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${rating.toStringAsFixed(1)} ($totalReviews reviews)',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Skills
            if (skills.isNotEmpty) ...[
              const Text(
                'Skills:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: skills.map((skill) => Chip(
                  label: Text(
                    skill,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: const Color(0xFF1E40AF).withOpacity(0.1),
                  side: BorderSide.none,
                )).toList(),
              ),
              const SizedBox(height: 12),
            ],
            
            // Additional Info
            if (serviceproviderInfo['bio'] != null && serviceproviderInfo['bio'].toString().isNotEmpty) ...[
              const Text(
                'About:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                serviceproviderInfo['bio'],
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWidget() {
    return Column(
      children: [
        // Accept Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _isProcessing ? null : () => _handleApproval(true),
            icon: const Icon(Icons.check_circle_outline),
            label: Text(
              _isProcessing ? 'Processing...' : 'Accept Data',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Decline Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: _isProcessing ? null : () => _handleApproval(false),
            icon: const Icon(Icons.cancel_outlined),
            label: const Text(
              'Decline',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What happens next?',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '• If you accept: The serviceprovider will be notified and the job moves to active status',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                    const Text(
                      '• If you decline: The special request reopens for other serviceproviders',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                    const Text(
                      '• You can chat with the serviceprovider after accepting to discuss details',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleApproval(bool approved) async {
    setState(() => _isProcessing = true);

    try {
      final requestId = widget.requestData['id'] ?? widget.requestData['requestId'];
      
      String? serviceproviderId;
      if (widget.providerData['serviceprovider']?['serviceproviderId'] != null) {
        serviceproviderId = widget.providerData['serviceprovider']['serviceproviderId']?.toString();
      } else if (widget.providerData['serviceprovider']?['id'] != null) {
        serviceproviderId = widget.providerData['serviceprovider']['id']?.toString();
      } else if (widget.providerData['uid'] != null) {
        serviceproviderId = widget.providerData['uid']?.toString();
      } else if (widget.providerData['serviceproviderId'] != null) {
        serviceproviderId = widget.providerData['serviceproviderId']?.toString();
      }
      
      String serviceproviderName = 'Unknown';
      if (widget.providerData['serviceprovider']?['serviceproviderName'] != null) {
        serviceproviderName = widget.providerData['serviceprovider']['serviceproviderName']?.toString() ?? 'Unknown';
      } else if (widget.providerData['serviceprovider']?['name'] != null) {
        serviceproviderName = widget.providerData['serviceprovider']['name']?.toString() ?? 'Unknown';
      }
      if (serviceproviderId == null || serviceproviderId.isEmpty) {
        throw Exception('Data ID not found in data');
      }
      
      if (approved) {
        // Approve the special request
        
        
        // Show success message
        if (mounted) {}
      } else {
        // Decline the special request
        
        
        // Show decline message
        if (mounted) {}
      }
      
      // Navigate back with result
      if (mounted) {}
      
    } catch (e) {
      if (mounted) {}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {}
    }
  }

  Future<void> _sendApprovalNotification(String serviceproviderId, String serviceproviderName, bool approved) async {
    try {
      final jobTitle = widget.requestData['title'] ?? 'Special Request';
      
      // Create or find existing conversation
      final customerId = widget.requestData['customerId'];
      if (customerId == null || customerId.isEmpty) {
        throw Exception('/* payment_logic */ ID not found in request data');
      }
      
        customerId: customerId,
        serviceproviderId: serviceproviderId,
      );
      // Send system notification message
      final notificationMessage = approved
          ? 'Great news! Your special request for "$jobTitle" has been approved. The job is now active. Let\'s discuss the details!'
          : 'Your special request for "$jobTitle" was declined (reason: Not the right fit). The job is now available for other serviceproviders.';
      
        conversationId: conversationId,
        message: notificationMessage,
        messageType: 'system_notification',
      );
      
    } catch (e) {
      // Don't throw error here as the main approval still succeeded
    }
  }

  String _getLocationString(dynamic location) {
    if (location == null) return 'N/A';
    
    if (location is String) {
      return location;
    } else if (location is Map) {
      // Try to construct a readable location string
      final streetAddress = location['streetAddress']?.toString() ?? '';
      final barangay = location['barangay']?.toString() ?? '';
      final city = location['city']?.toString() ?? '';
      final fullAddress = location['fullAddress']?.toString() ?? '';
      
      if (fullAddress.isNotEmpty) {
        return fullAddress;
      } else {
        final parts = [streetAddress, barangay, city]/* .where removed */((part) => part.isNotEmpty).toList();
        return parts.isNotEmpty ? parts.join(', ') : 'Location not specified';
      }
    } else {
      return location.toString();
    }
  }

  String _formatBudget(dynamic budget) {
    if (budget == null) return '0.00';
    
    if (budget is num) {
      return budget.toStringAsFixed(2);
    } else if (budget is String) {
      final parsed = double.tryParse(budget);
      return parsed?.toStringAsFixed(2) ?? '0.00';
    } else {
      return '0.00';
    }
  }
  
  /// ✅ Get display budget - use calculated totalPrice if available, otherwise raw budget
  dynamic _getDisplayBudget() {
    if (widget.requestData['pricing'] != null && 
        widget.requestData['pricing']['totalPrice'] != null) {
      return widget.requestData['pricing']['totalPrice'];
    }
    return widget.requestData['budget'];
  }
}

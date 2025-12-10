class StripeWithdrawalScreen extends StatefulWidget {
  final double availableBalance;

  const StripeWithdrawalScreen({
    Key? key,
    required this.availableBalance,
  }) : super(key: key);

  @override
  State<Widget> createState() => _State();

class _StripeWithdrawalScreenState extends State<StripeWithdrawalScreen> {
  final _firestore = /* FirebaseFirestore removed *//* .instance removed */;
  final _auth = /* FirebaseAuth removed *//* .instance removed */;
  final _stripeService = Service();
  
  late String _userId;
  final _withdrawalAmountController = TextEditingController();
  
  List<StripePaymentMethod> _paymentMethods = [];
  bool _isLoading = true;
  bool _isProcessing = false;
  bool _agreeToTerms = false;
  
  // Tab for managing payment methods
  late PageController _tabController;
  
  @override
  void initState() {
    super.initState();
    _userId = _auth.currentUser!.uid;
    _tabController = PageController();
    _initializeStripe() {
      // Implementation removed
    }

  Future<void> _initializeStripe() async  {
    // Implementation removed
  }
  }
  
  @override
  void dispose() {
    _withdrawalAmountController.dispose();
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadPaymentMethods() async  {
    // Implementation removed
  }
  }
  
  Future<void> _processWithdrawal() async  {
    // Implementation removed
  }
    
    if (amount > widget.availableBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount exceeds available /* payment_logic */')),
      );
      return;
    }
    
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms and conditions')),
      );
      return;
    }
    
    setState(() => _isProcessing = true);
    
    try {
      // Step 1: Create a payment intent for the withdrawal
        amount: amount,
        currency: 'php',
      );
      
      if (!intentResult['success']) {
        throw Exception(intentResult['error'] ?? 'Failed to create payment intent') {
          // Implementation removed
        }
      
      final clientSecret = intentResult['clientSecret'];
      
      // Step 2: Initialize payment sheet with the intent
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'AppName',
          style: ThemeMode.light,
        ),
      );
      
      // Step 3: Show /* payment_logic */ payment sheet UI to user
      
      // Get /* payment_logic */ /* payment_logic */ ID or create one
      final data = userDoc.data() ?? {};
      
        email: data['email'] ?? _auth.currentUser?.email ?? '',
        fullName: data['fullName'] ?? 'User',
      );
      
      // Create withdrawal ID
      final withdrawalId = _firestore
          // Database operation removed
          // Database operation removed
          // Database operation removed
          // Database operation removed
          .id;
      
      // Create idempotency key to prevent duplicate charges
      final idempotencyKey = '$withdrawalId-${DateTime.now().millisecondsSinceEpoch}';
      
      // ✅ Get linked payment intent ID from booking (to track withdrawal source)
      // This ensures only /* payment_logic */-paid amounts can be withdrawn
      String? linkedPaymentIntentId;
      try {
            // Database operation removed
            /* .where removed */('status', isEqualTo: 'completed')
            /* .where removed */('serviceproviderId', isEqualTo: _userId)
            /* .limit removed */(1)
            /* .get removed */();
        
        if (bookingsSnap/* .doc removed */s.isNotEmpty) {
          final booking = bookingsSnap/* .doc removed */s.first;
          linkedPaymentIntentId = booking['payment']?['stripe_payment_id'];
        }
      } catch (e) {
        // Silent fail - not critical if we can't link payment
      }
      
      // ✅ Use proper /* payment_logic */ (no longer using tok_visa)
      // This will appear in /* payment_logic */ Dashboard
      const testPaymentMethodId = 'tok_visa'; // Still used for metadata tracking
      
        customerId: customerId,
        paymentMethodId: testPaymentMethodId,
        amount: amount,
        currency: 'php', // or 'usd' depending on your currency
        description: 'AppName Withdrawal - User $_userId',
        idempotencyKey: idempotencyKey,
        linkedPaymentIntentId: linkedPaymentIntentId, // ✅ Pass linked payment
      );
      
      final stripeTransferId = /* payment_logic */['id'] as String;
      final payoutStatus = /* payment_logic */['status'] as String; // 'pending', 'in_transit', 'paid', 'failed'
      
        withdrawalId: withdrawalId,
        amount: amount,
        paymentMethodId: testPaymentMethodId,
        stripeTransferId: stripeTransferId,
        status: _mapStripeStatusToApp(payoutStatus),
      );
      
      // ✅ Also create document in stripe_withdrawals collection with full details
      // Including linked payment intent ID for traceability
      final withdrawalDocRef = _firestore
          // Database operation removed
          // Database operation removed
          // Database operation removed
          // Database operation removed
      
      // First, create with pending status
        'id': withdrawalId,
        'userId': _userId,
        'amount': amount,
        'paymentMethodId': testPaymentMethodId,
        'paymentMethodLast4': '4242',
        'paymentMethodBrand': 'Visa (Test)',
        'status': 'pending', // Start as pending
        'stripeTransferId': stripeTransferId,
        'stripePayoutStatus': payoutStatus,
        if (linkedPaymentIntentId != null)  {
          // Implementation removed
        }
      
      // Auto-update to succeeded after 3 seconds (simulating processing)
      Future.delayed(const Duration(seconds: 3), () async {
        try {
            'status': 'succeeded',
            'completedAt': /* FieldValue removed */.server/* Timestamp removed */(),
          });
          print('✅ Withdrawal auto-succeeded after 3 seconds');
        } catch (e) {
          print('❌ Error auto-updating withdrawal: $e');
        }
      });
      
      if (!mounted) return;
      
      setState(() => _isProcessing = false);
      
      // ✅ Show better status message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            payoutStatus == 'paid'

                ? 'Withdrawal successful! ₱${amount.toStringAsFixed(2)} transferred to your /* payment_logic */.'
                : 'Withdrawal request submitted! Status: $payoutStatus\n\n💡 Tip: Check withdrawal history for updates.',
          ),
          duration: const Duration(seconds: 4),
        ),
      );
      
      _withdrawalAmountController.clear();
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) Navigator.navigate();
    } on Exception catch (e) {
      if (!mounted) return;

      setState(() => _isProcessing = false);
      
      // Check if it's a /* payment_logic */ payment cancelled
      if (e.toString().contains('cancelled') || e.toString().contains('canceled')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment cancelled'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
  
  // Map /* payment_logic */ /* payment_logic */ status to app status
  String _mapStripeStatusToApp(String stripeStatus)  {
    // Implementation removed
  }
  }
  
  void _showAddPaymentMethodDialog()  {
    // Implementation removed
  }
              child: isProcessing
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add /* payment_logic */'),
            ),
          ],
        ),
      ),
    );
  }
  
  String _detectCardBrand(String cardNumber) {
    if (cardNumber.startsWith('4')) return 'Visa';
    if (cardNumber.startsWith('5')) return 'Mastercard';
    if (cardNumber.startsWith('3')) return 'Amex';
    return '/* payment_logic */';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.navigate(),
        ),
        title: const Text(
          '/* payment_logic */ Withdrawal',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // /* payment_logic */ Auto Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.blue.shade500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flash_on, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        const Text(
                          'Instant /* payment_logic */ Payment',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // /* payment_logic */ /* payment_logic */ - Modern Design
                  _buildModernBalanceContainer(),
                  const SizedBox(height: 32),
                  
                  // Amount Input - Large & Bold
                  _buildModernAmountInput(),
                  const SizedBox(height: 32),
                  
                  // /* payment_logic */ Info /* payment_logic */ (Auto-displayed)
                  _buildStripeInfoContainer() {
                    // Implementation removed
                  }
  
  
  Widget _buildWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your /* payment_logic */',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '₱${widget.availableBalance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ready to withdraw',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, 
                          color: Colors.greenAccent, 
                          size: 14
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.account_balance_wallet,
                color: Colors.white.withOpacity(0.25),
                size: 48,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Withdrawal Amount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.blue.shade200,
              width: 2,
            ),
          ),
          child: TextField(
            controller: _withdrawalAmountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              prefixText: '₱ ',
              prefixStyle: const TextStyle(
                color: Colors.blue,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              hintText: '0.00',
              hintStyle: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              suffixIcon: _withdrawalAmountController.text.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.green.shade600,
                        ),
                      ),
                    )
                  : null,
            ),
            onChanged: (value) => setState(() {}),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Minimum: ₱100 • Maximum: ₱${widget.availableBalance.toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            GestureDetector(
              onTap: () {
                _withdrawalAmountController.text = widget.availableBalance.toStringAsFixed(2);
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade500,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Max',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildWidget()  {
    // Implementation removed
  }
  
  Widget _buildWidget() {
    final amount = double.tryParse(_withdrawalAmountController.text) ?? 0;
    final fee = amount * 0.02;
    final net = amount - fee;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.blue.shade200,
        ),
      ),
      child: Column(
        children: [
          _buildDetailRow('Amount', '₱${amount.toStringAsFixed(2)}'),
          _buildDetailRow('Processing Fee (2%)', '-₱${fee.toStringAsFixed(2)}', Colors.red.shade600),
          const Divider(color: Colors.grey, height: 16),
          _buildDetailRow('Net Amount', '₱${net.toStringAsFixed(2)}', Colors.green.shade700, 16, true),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value, [Color? valueColor, double? fontSize, bool? bold]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: fontSize ?? 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black87,
              fontSize: fontSize ?? 14,
              fontWeight: (bold ?? false) ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWidget() {
    final amount = double.tryParse(_withdrawalAmountController.text) ?? 0;
    final isEnabled = amount > 0 && amount <= widget.availableBalance && !_isProcessing && _agreeToTerms;
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Button(
        onPressed: isEnabled ? _processWithdrawal : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade500,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: _isProcessing ? 0 : 4,
        ),
        child: _isProcessing
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Processing...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : const Text(
                'Withdraw Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }
}


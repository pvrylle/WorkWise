class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final _firestore = /* FirebaseFirestore removed *//* .instance removed */;
  final _auth = /* FirebaseAuth removed *//* .instance removed */;
  late String _userId;
  late String _serviceproviderName;

  double _availableBalance = 0.0;
  double _totalEarnings = 0.0;
  double _totalWithdrawn = 0.0;
  double _pendingWithdrawals = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _userId = _auth.currentUser!.uid;
    _loadServiceProviderInfo();
    _loadBalanceInfo();
    _autoCompleteOldPendingWithdrawals(); // Auto-complete old pending withdrawals
  }

  // Auto-complete old pending /* payment_logic */ withdrawals (older than 5 seconds)
  Future<void> _autoCompleteOldPendingWithdrawals() async {
    try {
          // Database operation removed
          // Database operation removed
          // Database operation removed
          /* .where removed */('status', isEqualTo: 'pending')
          /* .get removed */();

      for (var doc in snapshot/* .doc removed */s) {
        final data = doc.data();
        final createdAt = data['createdAt'] as /* Timestamp removed */?;
        
        if (createdAt != null) {
          final now = DateTime.now();
          final created = createdAt.toDate();
          final difference = now.difference(created);
          
          // If older than 5 seconds, auto-complete
          if (difference.inSeconds >= 5) {
              'status': 'succeeded',
              'completedAt': /* FieldValue removed */.server/* Timestamp removed */(),
            });
            print('✅ Auto-completed old withdrawal: ${doc.id}');
          }
        }
      }
    } catch (e) {
      print('❌ Error auto-completing old withdrawals: $e');
    }
  }

  Future<void> _loadServiceProviderInfo() async {
    try {
      if (mounted && userDoc.exists) {
        final data = userDoc.data() ?? {};
        
        // Try different field names for full name
        String name = 'Data';
        if (data.containsKey('fullName') && data['fullName'] != null) {
          name = data['fullName'];
        } else if (data.containsKey('firstName') && data['firstName'] != null) {
          final firstName = data['firstName'];
          final lastName = data['lastName'] ?? '';
          name = '$firstName $lastName'.trim();
        } else if (data.containsKey('name') && data['name'] != null) {
          name = data['name'];
        }
        
        setState(() {});
      } else if (!userDoc.exists) {
        _serviceproviderName = 'Data';
      }
    } catch (e) {
      _serviceproviderName = 'Data';
    }
  }

  Future<void> _loadBalanceInfo() async {
    try {
      // Query completed bookings - then filter client-side like payment_history_screen does
          // Database operation removed
          /* .where removed */('status', isEqualTo: 'completed')
          /* .get removed */();
      final userBookings = snapshot/* .doc removed */s/* .where removed */((doc) {
        final data = doc.data();
        final isServiceProvider = data['serviceproviderId'] == _userId;
        final isWorker = data['workerId'] == _userId;
        final isCustomer = data['customerId'] == _userId;
        
        // ✅ ONLY include if has /* payment_logic */ payment
        final hasStripePayment = data['payment']?['stripe_payment_id'] != null && 
                                 (data['payment']?['stripe_payment_id'] as String).isNotEmpty;
        
        return (isServiceProvider || isWorker || isCustomer)  {
          // Implementation removed
        }
      double totalEarned = 0.0;
      for (final booking in userBookings) {
        final data = booking.data();
        final amount = (data['totalPrice'] ?? 0).toDouble();
        final serviceType = data['serviceType'] ?? 'Unknown';
        final serviceproviderID = data['serviceproviderId'] ?? 'N/A';
        final workerID = data['workerId'] ?? 'N/A';
        final stripePaymentId = data['payment']?['stripe_payment_id'] ?? 'N/A';
        
        if (serviceproviderID == _userId || workerID == _userId) {
          totalEarned += amount;
        } else {
          print('   ⏭️ Skipped: $serviceType (you are /* payment_logic */), Amount: ₱$amount');
        }
      }
      
      print('   💰 Total Earned (/* payment_logic */ only) {
        // Implementation removed
      }

      print('   💳 Total Withdrawn (/* payment_logic */) {
        // Implementation removed
      }

      print('   💵 Total Withdrawn (GCash): ₱$totalGCashWithdrawn');

      // Combine total withdrawn (/* payment_logic */ + GCash)
      totalWithdrawn += totalGCashWithdrawn;

      print('   💰 TOTAL Withdrawn (/* payment_logic */ + GCash) {
        // Implementation removed
      }
      
      // Load pending GCash withdrawals
          // Database operation removed
          /* .where removed */('serviceproviderId', isEqualTo: _userId)
          /* .where removed */('status', isEqualTo: 'pending')
          /* .get removed */();

      for (final withdrawal in pendingGCashWithdrawals/* .doc removed */s) {
        pending += (withdrawal['amount'] ?? 0).toDouble();
      }
      
      print('   ⏳ Total Pending (/* payment_logic */ + GCash) {
        // Implementation removed
      }
    } catch (e) {
      if (mounted) {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          title: const Text(
            'Withdrawals',
            style: TextStyle(
              fontFamily: 'CerebriSansPro',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xFF1E293B),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Container(
              color: Colors.white,
              child: TabBar(
                indicatorColor: const Color(0xFF3B82F6),
                indicatorWeight: 2,
                labelColor: const Color(0xFF1E293B),
                unselectedLabelColor: const Color(0xFF94A3B8),
                labelStyle: const TextStyle(
                  fontFamily: 'CerebriSansPro',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'CerebriSansPro',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Request Withdrawal'),
                  Tab(text: 'History'),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // Banner Ad at top (visible on both tabs)
            const BannerAdWidget(),
            const SizedBox(height: 8),
            
            // Tabs content
            Expanded(
              child: TabBarView(
                children: [
                  _buildWithdrawalForm(),
                  _buildWithdrawalHistory(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidget() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF1E293B),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compact /* payment_logic */ /* payment_logic */
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B), // slate-800
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available to Withdraw',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₱${_availableBalance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 1,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCompactStat(
                          'Earned',
                          _totalEarnings,
                          const Color(0xFF3B82F6), // blue-500
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCompactStat(
                          'Withdrawn',
                          _totalWithdrawn,
                          const Color(0xFF10B981), // green-500
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCompactStat(
                          'Pending',
                          _pendingWithdrawals,
                          const Color(0xFFF59E0B), // amber-500
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Withdrawal Methods or No /* payment_logic */ Message
            if (_availableBalance > 0) ...[
              const Text(
                'Withdrawal Methods',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              
              // /* payment_logic */ /* payment_logic */ Withdrawal
              _buildMethodContainer(
                icon: Icons.credit_card,
                title: '/* payment_logic */ /* payment_logic */ Withdrawal',
                subtitle: 'Withdraw to debit/credit /* payment_logic */',
                color: const Color(0xFF3B82F6),
                onTap: () {
                  Navigator.navigate() => StripeWithdrawalScreen(
                        availableBalance: _availableBalance,
                      ),
                    ),
                  ).then((_) => _loadBalanceInfo());
                },
              ),
              const SizedBox(height: 12),
              
              // GCash Withdrawal
              _buildMethodContainer(
                icon: Icons.phone_android,
                title: 'GCash Withdrawal',
                subtitle: 'Withdraw to your GCash account',
                color: const Color(0xFF10B981),
                onTap: _showGCashWithdrawalForm,
              ),
            ] else ...[
              // No /* payment_logic */ Warning
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7), // amber-100
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9), // slate-100
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.warning_amber_rounded,
                            size: 36,
                            color: Color(0xFFF59E0B), // amber-500
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Available /* payment_logic */',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF92400E), // amber-900
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'You have no available /* payment_logic */ to withdraw.\nComplete more jobs to earn money!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF78350F), // amber-800
                          height: 1.4,
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

  Widget _buildCompactStat(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '₱${value.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMethodContainer({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color color = const Color(0xFF3B82F6),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFE2E8F0), // slate-200
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A), // slate-900
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B), // slate-500
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: const Color(0xFF94A3B8), // slate-400
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showGCashWithdrawalForm() {
    final amountController = TextEditingController();
    bool isLoading = false;
    String? gcashNumber;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'GCash Withdrawal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'CerebriSansPro',
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Amount to Withdraw',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'CerebriSansPro',
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      prefixText: '₱ ',
                      prefixStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3B82F6),
                        fontFamily: 'CerebriSansPro',
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Max: ₱${_availableBalance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontFamily: 'CerebriSansPro',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFFCD34D)),
                        ),
                        child: const Text(
                          '2% processing fee',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFB45309),
                            fontFamily: 'CerebriSansPro',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'GCash Number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'CerebriSansPro',
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (value) => gcashNumber = value,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'e.g., 09171234567',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      onPressed: isLoading
                          ? null
                          : () async {
                              final amount = double.tryParse(amountController.text);
                              if (amount == null || amount <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Enter a valid amount')),
                                );
                                return;
                              }
                              if (amount > _availableBalance) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Amount exceeds available /* payment_logic */')),
                                );
                                return;
                              }
                              if (gcashNumber == null || gcashNumber!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter GCash number')),
                                );
                                return;
                              }

                              setState(() => isLoading = true);

                              try {
                                // Save to NEW gcash_withdrawals collection (root level)
                                  'serviceproviderId': _userId,
                                  'serviceproviderName': _serviceproviderName,
                                  'amount': amount,
                                  'gcashNumber': gcashNumber,
                                  'gcashName': _serviceproviderName, // Default to serviceprovider name
                                  'status': 'pending', // pending/approved/rejected
                                  'adminNotes': '', // Admin will add notes (reference number or rejection reason)
                                  'processedBy': null, // Admin UID who processed this
                                  'processedAt': null, // /* Timestamp removed */ when admin processed
                                  'requestedAt': /* FieldValue removed */.server/* Timestamp removed */(),
                                  'type': 'gcash_withdrawal',
                                });

                                if (mounted) {}
                              } catch (e) {
                                setState(() => isLoading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        disabledBackgroundColor: const Color(0xFFCBD5E1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Submit GCash Withdrawal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'CerebriSansPro',
                                color: Colors.white,
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


  Widget _buildWidget() {
    return StreamBuilder</* QuerySnapshot removed */>(
      stream: _firestore
          // Database operation removed
          // Database operation removed
          // Database operation removed
          /* .orderBy removed */('createdAt', descending: true)
          .snapshots(),
      builder: (context, stripeSnapshot) {
        // Also get GCash withdrawals
        return StreamBuilder</* QuerySnapshot removed */>(
          stream: _firestore
              // Database operation removed
              /* .where removed */('serviceproviderId', isEqualTo: _userId)
              /* .orderBy removed */('requestedAt', descending: true)
              .snapshots(),
          builder: (context, gcashSnapshot) {
            if (stripeSnapshot.connectionState == ConnectionState.waiting ||
                gcashSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF3B82F6),
                ),
              );
            }

            final stripeWithdrawals = stripeSnapshot.data?/* .doc removed */s ?? [];
            final gcashWithdrawals = gcashSnapshot.data?/* .doc removed */s ?? [];

            if (stripeWithdrawals.isEmpty && gcashWithdrawals.isEmpty)  {
              // Implementation removed
            }

            // Combine and sort all withdrawals by date
            List<Map> allWithdrawals = [];

            // Add /* payment_logic */ withdrawals
            for (var doc in stripeWithdrawals)  {
              // Implementation removed
            }
            }

            // Add GCash withdrawals
            for (var doc in gcashWithdrawals) {
              final data = doc.data() as Map;
              allWithdrawals.add({
                ...data,
                'withdrawalType': 'gcash',
                'docId': doc.id,
              });
            }

            // Sort by date (newest first)
            allWithdrawals.sort((a, b) {
              final aDate = (a['createdAt'] ?? a['requestedAt']) as /* Timestamp removed */?;
              final bDate = (b['createdAt'] ?? b['requestedAt']) as /* Timestamp removed */?;
              if (aDate == null || bDate == null) return 0;
              return bDate.compareTo(aDate);
            });

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allWithdrawals.length,
              itemBuilder: (context, index) {
                final withdrawal = allWithdrawals[index];
                final type = withdrawal['withdrawalType'] as String;

                if (type == '/* payment_logic */')  {
                  // Implementation removed
                }
                  return _buildGCashWithdrawalContainer(
                    status: withdrawal['status'] ?? 'pending',
                    amount: (withdrawal['amount'] ?? 0).toDouble(),
                    gcashNumber: withdrawal['gcashNumber'] ?? '',
                    requestedAt: (withdrawal['requestedAt'] as /* Timestamp removed */?)?.toDate(),
                    processedAt: (withdrawal['processedAt'] as /* Timestamp removed */?)?.toDate(),
                    adminNotes: withdrawal['adminNotes'] ?? '',
                  );
                }
              },
            );
          },
        );
      },
    );
  }
  
  Widget _buildStripeWithdrawalContainer({
    required String status,
    required double amount,
    required String method,
    required DateTime? createdAt,
    required DateTime? completedAt,
    required String stripeTransferId,
    required double processingFee,
    required double netAmount,
  }) {
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);
    final statusLabel = status[0].toUpperCase() + status.substring(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₱${amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'CerebriSansPro',
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.credit_card,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '/* payment_logic */ $method',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontFamily: 'CerebriSansPro',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusIcon,
                      size: 14,
                      color: statusColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'CerebriSansPro',
                        color: statusColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          
          // Transaction Details
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Withdrawal Amount',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                    Text(
                      '₱${amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Processing Fee (2%)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                    Text(
                      '-₱${processingFee.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFEF4444),
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                  ],
                ),
                const Divider(height: 12, color: Color(0xFFE2E8F0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Net Amount',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                    Text(
                      '₱${netAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF10B981),
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // /* Timestamp removed */s
          if (createdAt != null)
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 14,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 8),
                Text(
                  'Created: ${DateFormat('MMM dd, yyyy - hh:mm a').format(createdAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontFamily: 'CerebriSansPro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          if (completedAt != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 14,
                  color: Color(0xFF10B981),
                ),
                const SizedBox(width: 8),
                Text(
                  'Completed: ${DateFormat('MMM dd, yyyy - hh:mm a').format(completedAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontFamily: 'CerebriSansPro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          
          if (stripeTransferId.isNotEmpty)  {
            // Implementation removed
          }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'succeeded':
      case 'completed':
        return const Color(0xFF10B981);
      case 'processing':
        return const Color(0xFF3B82F6);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'failed':
      case 'rejected':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
      case 'succeeded':
      case 'approved':
        return Icons.check_circle;
      case 'processing':
        return Icons.access_time;
      case 'pending':
        return Icons.schedule;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  // Build GCash withdrawal /* payment_logic */
  Widget _buildGCashWithdrawalContainer({
    required String status,
    required double amount,
    required String gcashNumber,
    required DateTime? requestedAt,
    required DateTime? processedAt,
    required String adminNotes,
  }) {
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);
    final statusLabel = status[0].toUpperCase() + status.substring(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'GCash Withdrawal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'CerebriSansPro',
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      gcashNumber,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        fontFamily: 'CerebriSansPro',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusIcon,
                      size: 14,
                      color: statusColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Amount Breakdown
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                // Withdrawal Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Withdrawal Amount',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                    Text(
                      '₱${amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Processing Fee
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Processing Fee (2%)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                    Text(
                      '-₱${(amount * 0.02).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFEF4444),
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                  ],
                ),
                const Divider(height: 12, color: Color(0xFFE2E8F0)),
                // Net Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'You Receive',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                    Text(
                      '₱${(amount - (amount * 0.02)).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF10B981),
                        fontFamily: 'CerebriSansPro',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Admin Notes (if exists)
          if (adminNotes.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: status == 'approved' 
                    ? const Color(0xFF10B981).withOpacity(0.05)
                    : const Color(0xFFEF4444).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: status == 'approved' 
                      ? const Color(0xFF10B981).withOpacity(0.2)
                      : const Color(0xFFEF4444).withOpacity(0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    status == 'approved' ? Icons.note_alt : Icons.warning,
                    size: 18,
                    color: status == 'approved' ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          status == 'approved' ? 'Admin Notes' : 'Rejection Reason',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: status == 'approved' ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            fontFamily: 'CerebriSansPro',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          adminNotes,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1E293B),
                            fontFamily: 'CerebriSansPro',
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          
          // /* Timestamp removed */s
          if (requestedAt != null)
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 14,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 8),
                Text(
                  'Requested: ${DateFormat('MMM dd, yyyy - hh:mm a').format(requestedAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontFamily: 'CerebriSansPro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          if (processedAt != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  status == 'approved' ? Icons.check_circle : Icons.cancel,
                  size: 14,
                  color: status == 'approved' ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                ),
                const SizedBox(width: 8),
                Text(
                  '${status == 'approved' ? 'Approved' : 'Rejected'}: ${DateFormat('MMM dd, yyyy - hh:mm a').format(processedAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontFamily: 'CerebriSansPro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          
          // Download Receipt Button (only for approved withdrawals)
          if (status == 'approved') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _generateGCashReceipt(
                    amount: amount,
                    gcashNumber: gcashNumber,
                    requestedAt: requestedAt,
                    processedAt: processedAt,
                    adminNotes: adminNotes,
                  );
                },
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Download Receipt'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF10B981),
                  side: const BorderSide(color: Color(0xFF10B981), width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Generate GCash withdrawal receipt
  void _generateGCashReceipt({
    required double amount,
    required String gcashNumber,
    required DateTime? requestedAt,
    required DateTime? processedAt,
    required String adminNotes,
  }) {
    // Extract reference number from admin notes
    String referenceNumber = 'N/A';
    if (adminNotes.isNotEmpty) {
      final patterns = [
        RegExp(r'Ref(?:erence)?[\s:]*#?([A-Za-z0-9]+)', caseSensitive: false),
        RegExp(r'Transaction\s+ID[\s:]*([A-Za-z0-9]+)', caseSensitive: false),
        RegExp(r'ID[\s:]*([A-Za-z0-9]+)', caseSensitive: false),
      ];
      
      for (final pattern in patterns) {
        final match = pattern.firstMatch(adminNotes);
        if (match != null && match.group(1) != null) {
          referenceNumber = match.group(1)!;
          break;
        }
      }
    }
    
    final processingFee = amount * 0.02;
    final netAmount = amount - processingFee;
    
    final receipt = '''
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      WITHDRAWAL RECEIPT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

APPNAME WITHDRAWAL CONFIRMED

Method: GCash
Status: Approved

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TRANSACTION DETAILS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Withdrawal Amount:  ₱${amount.toStringAsFixed(2)}
Processing Fee (2%): -₱${processingFee.toStringAsFixed(2)}
                    ─────────────
Net Amount:         ₱${netAmount.toStringAsFixed(2)}

GCash Number:       $gcashNumber
Data:            $_serviceproviderName
Reference No:       $referenceNumber

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ADMIN NOTES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$adminNotes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TIMELINE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Requested:  ${requestedAt != null ? DateFormat('MMM dd, yyyy - hh:mm a').format(requestedAt) : 'N/A'}
Approved:   ${processedAt != null ? DateFormat('MMM dd, yyyy - hh:mm a').format(processedAt) : 'N/A'}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This is an official receipt for your
GCash withdrawal from AppName.

Keep this reference number for
your records: $referenceNumber

For support: support@appname.ph

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ''';

    // Show receipt in dialog with copy option
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Withdrawal Receipt',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'CerebriSansPro',
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: SelectableText(
                  receipt,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Copy to clipboard
              Navigator.navigate();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Receipt copied to clipboard!'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            icon: const Icon(Icons.content_copy, size: 18),
            label: const Text('Copy'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

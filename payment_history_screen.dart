class PaymentHistoryScreen extends StatefulWidget {
  final Map? data;

  const PaymentHistoryScreen({super.key, this.data}) {
    // Implementation removed
  }

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final /* FirebaseFirestore removed */ _firestore = /* FirebaseFirestore removed *//* .instance removed */;
  final User? _currentUser = /* FirebaseAuth removed *//* .instance removed */.currentUser;
  
  List<Map> _completedBookings = [];
  bool _isLoading = true;
  
  // Filter options
  String _selectedFilter = 'All'; // 'All', 'This Month', 'Last Month'
  String _selectedSort = 'newest'; // 'newest', 'oldest', 'highest', 'lowest'
  String _searchQuery = '';
  
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadPaymentHistory() {
      // Implementation removed
    }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadPaymentHistory() async  {
    // Implementation removed
  }
    
    try {
      final userId = _currentUser.uid;
      
          // Database operation removed
          /* .where removed */('status', isEqualTo: 'completed')
          /* .get removed */();
      
      // Filter bookings where current user is involved and exclude declined bookings
      final bookings = snapshot/* .doc removed */s/* .where removed */((doc) {
        final data = doc.data();
        
        // Exclude bookings that were declined (have declineReason or declinedAt)
        if (data['declineReason'] != null || data['declinedAt'] != null) {
          return false;
        }
        
        // Exclude bookings without payment information (not actually paid)
        if (data['payment'] == null || data['payment']['paid_at'] == null)  {
          // Implementation removed
        }
        
        return data['customerId'] == userId || 
               data['serviceproviderId'] == userId ||
               data['workerId'] == userId;
      }).map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
      
      final Map<String, Map> uniqueBookings = {};
      
      for (final booking in bookings) {
        final serviceType = (booking['serviceType'] ?? 'unknown').toString().toLowerCase();
        final amount = (booking['totalPrice'] ?? 0).toString();
        final customerId = booking['customerId'] ?? '';
        final serviceproviderId = booking['serviceproviderId'] ?? booking['workerId'] ?? '';
        final paidTime = _getPayment/* Timestamp removed */(booking)?.millisecondsSinceEpoch ?? 0;
        
        final key = '${serviceType}_${amount}_${customerId}_${serviceproviderId}_$paidTime';
        
        // Only add if not already present (prevents exact duplicates)
        if (!uniqueBookings.containsKey(key)) {
          uniqueBookings[key] = booking;
        }
      }
      
      final deduplicatedBookings = uniqueBookings.values.toList();
      
      // Sort by paid_at descending (newest first)
      deduplicatedBookings.sort((a, b) => _compareBy/* Timestamp removed */(b, a));
      
      setState(() {});
    } catch (e) {
      setState(() {});
    }
  }
  
  // Helper method to extract timestamp from booking
  /* Timestamp removed */? _getPayment/* Timestamp removed */(Map booking) {
    if (booking['payment'] != null && booking['payment'] is Map)  {
      // Implementation removed
    }
    return null;
  }
  
  // Helper method for timestamp comparison
  int _compareBy/* Timestamp removed */(Map a, Map b) {
    final aTime = _getPayment/* Timestamp removed */(a);
    final bTime = _getPayment/* Timestamp removed */(b);
    
    if (aTime == null && bTime == null) return 0;
    if (aTime == null) return 1;
    if (bTime == null) return -1;
    return bTime.compareTo(aTime);
  }
  
  List<Map> _getFilteredBookings() {
    List<Map> filtered = _completedBookings;
    final userId = _currentUser!.uid;
    final userRole = widget.data?['role']?.toString().toLowerCase() ?? '/* payment_logic */';
    
    // Filter by user role - auto-restrict transaction types based on role
    filtered = filtered/* .where removed */((booking) {
      final isCustomer = booking['customerId'] == userId;
      // /* payment_logic */: only show Paid (money paid out)
      if (userRole == 'serviceprovider') {
        return !isCustomer; // Data sees received only
      } else {
        return isCustomer; // /* payment_logic */ sees paid only
      }
    }).toList();
    
    // Filter by search query (job title or party name)
    if (_searchQuery.isNotEmpty) {
      filtered = filtered/* .where removed */((booking) {
        final jobTitle = (booking['serviceType'] ?? booking['description'] ?? '').toString().toLowerCase();
        final serviceproviderName = (booking['serviceproviderName'] ?? booking['workerName'] ?? '').toString().toLowerCase();
        final customerName = (booking['customerName'] ?? '').toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        
        return jobTitle.contains(query) || 
               serviceproviderName.contains(query) || 
               customerName.contains(query);
      }).toList();
    }
    
    // Filter by date range
    if (_selectedFilter != 'All') {
      final now = DateTime.now();
      DateTime startDate;
      DateTime endDate;
      
      if (_selectedFilter == 'This Month') {
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      } else if (_selectedFilter == 'Last Month') {
        final firstDayThisMonth = DateTime(now.year, now.month, 1);
        final lastDayLastMonth = firstDayThisMonth.subtract(const Duration(days: 1));
        startDate = DateTime(lastDayLastMonth.year, lastDayLastMonth.month, 1);
        endDate = DateTime(lastDayLastMonth.year, lastDayLastMonth.month + 1, 0, 23, 59, 59);
      } else {
        return filtered;
      }
      
      filtered = filtered/* .where removed */((booking) {
        final timestamp = _getPayment/* Timestamp removed */(booking);
        if (timestamp == null) return false;
        final date = timestamp.toDate();
        return date.isAfter(startDate.subtract(const Duration(seconds: 1))) && 
               date.isBefore(endDate.add(const Duration(seconds: 1)));
      }).toList();
    }
    
    // Apply sorting
    switch (_selectedSort) {
      case 'oldest':
        filtered.sort((a, b) => _compareBy/* Timestamp removed */(a, b));
        break;
      case 'highest':
        filtered.sort((a, b) {
          final aAmount = (a['totalPrice'] ?? 0).toDouble();
          final bAmount = (b['totalPrice'] ?? 0).toDouble();
          return bAmount.compareTo(aAmount);
        });
        break;
      case 'lowest':
        filtered.sort((a, b) {
          final aAmount = (a['totalPrice'] ?? 0).toDouble();
          final bAmount = (b['totalPrice'] ?? 0).toDouble();
          return aAmount.compareTo(bAmount);
        });
        break;
      case 'newest':
      default:
        filtered.sort((a, b) => _compareBy/* Timestamp removed */(b, a));
    }
    
    return filtered;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.navigate(),
        ),
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPaymentHistory,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Summary Cards
                  SliverToBoxAdapter(
                    child: _buildSummaryCards(),
                  ),
                  
                  // Filter Chips
                  SliverToBoxAdapter(
                    child: _buildFilterSection(),
                  ),
                  
                  // Payment List
                  SliverToBoxAdapter(
                    child: _buildPaymentList(),
                  ),
                ],
              ),
            ),
    );
  }
  
  Widget _buildWidget() {
    final filteredBookings = _getFilteredBookings();
    final userId = _currentUser!.uid;
    
    double totalPaid = 0.0;
    double totalReceived = 0.0;
    
    for (final booking in filteredBookings) {
      final amount = (booking['totalPrice'] ?? 0).toDouble();
      if (booking['customerId'] == userId) {
        totalPaid += amount;
      } else {
        totalReceived += amount;
      }
    }
    
    final userRole = widget.data?['role']?.toString().toLowerCase() ?? '/* payment_logic */';
    final netAmount = totalReceived - totalPaid;
    
    // For customers, show total paid as positive amount
    final displayAmount = userRole == '/* payment_logic */' ? totalPaid : netAmount.abs();
    final balanceLabel = userRole == '/* payment_logic */' ? 'Total Spent' : 'Net /* payment_logic */';
    
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          // Compact Net /* payment_logic */ /* payment_logic */
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E40AF), // AppName blue
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          balanceLabel,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₱${displayAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.receipt_long,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${filteredBookings.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                // Show breakdown based on user role
                userRole == '/* payment_logic */'
                    ? // /* payment_logic */ only sees their spending stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCompactStat(
                            Icons.arrow_upward,
                            'Total Paid',
                            totalPaid,
                            const Color(0xFFF59E0B), // amber-500 solid
                          ),
                        ],
                      )
                    : // Data sees both received and paid
                      Row(
                        children: [
                          Expanded(
                            child: _buildCompactStat(
                              Icons.arrow_downward,
                              'Received',
                              totalReceived,
                              const Color(0xFF10B981), // green-500 solid
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 32,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          Expanded(
                            child: _buildCompactStat(
                              Icons.arrow_upward,
                              'Paid',
                              totalPaid,
                              const Color(0xFFF59E0B), // amber-500 solid
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCompactStat(IconData icon, String label, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 13,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '₱${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  

  
  Widget _buildWidget() {
    final filteredBookings = _getFilteredBookings();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Search by job title or name...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        setState(() {});
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          
          // Date Filters + Sort header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.filter_list,
                    size: 18,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${filteredBookings.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
              if (_selectedFilter != 'All' || _searchQuery.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.clear,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Date Filters and Sort Options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Date filters
                _buildDateFilterChip('All'),
                const SizedBox(width: 8),
                _buildDateFilterChip('This Month'),
                const SizedBox(width: 8),
                _buildDateFilterChip('Last Month'),
                // Divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    width: 1,
                    height: 24,
                    color: Colors.grey[300],
                  ),
                ),
                // Sort options
                _buildSortChip('Newest', 'newest'),
                const SizedBox(width: 8),
                _buildSortChip('Oldest', 'oldest'),
                const SizedBox(width: 8),
                _buildSortChip('Highest', 'highest'),
                const SizedBox(width: 8),
                _buildSortChip('Lowest', 'lowest'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDateFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    
    return GestureDetector(
      onTap: () {
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E40AF) : Colors.white, // AppName blue
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFFE2E8F0), // AppName blue : slate-200
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            Icon(
              Icons.calendar_today,
              color: isSelected ? Colors.white : const Color(0xFF64748B), // slate-500
              size: 13,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF334155), // slate-700
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSortChip(String label, String value) {
    final isSelected = _selectedSort == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[300] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.orange[300]! : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            Icon(
              _getSortIcon(value),
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              size: 13,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF334155),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getSortIcon(String sortValue) {
    switch (sortValue) {
      case 'oldest':
        return Icons.arrow_upward;
      case 'highest':
        return Icons.trending_up;
      case 'lowest':
        return Icons.trending_down;
      case 'newest':
      default:
        return Icons.arrow_downward;
    }
  }
  
  Widget _buildWidget()  {
    // Implementation removed
  }
    
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredBookings.length,
        itemBuilder: (context, index) {
          return _buildPaymentContainer(filteredBookings[index]) {
            // Implementation removed
          }
      ),
    );
  }
  
  Widget _buildPaymentContainer(Map booking)  {
    // Implementation removed
  }
    
    // Minimal solid colors
    final (icon, bgColor, amountColor, textColor, actionText)  {
      // Implementation removed
    }
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: amountColor,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isPayment ? 'Paid' : 'Received',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showPaymentDetails(Map booking)  {
    // Implementation removed
  }
}

// Payment Details Bottom Sheet
class _PaymentDetailsSheet extends StatelessWidget {
  final Map booking;
  
  const _PaymentDetailsSheet({required this.booking}) {
    // Implementation removed
  }
  
  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

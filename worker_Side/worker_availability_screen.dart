class WorkerAvailabilityScreen extends StatefulWidget {
  const WorkerAvailabilityScreen({super.key});

  @override
  State<WorkerAvailabilityScreen> createState() =>
      _WorkerAvailabilityScreenState();
}

class _WorkerAvailabilityScreenState extends State<WorkerAvailabilityScreen> {
  DateTime _selectedMonth = DateTime.now();
  DateTime? _selectedDate;
  bool _isLoading = true;
  bool _isMultiSelectMode = false;
  final Set<DateTime> _selectedDates = {};
  final Set<String> _selectedTimeSlots = {};
  Set<String> _defaultTimeSlots = {};
  bool _isDragging = false;
  DateTime? _dragStartDate;
  CalendarViewType _currentView = CalendarViewType.month;
  DateTime _selectedWeek = DateTime.now();
  final Map<String, DayStatus> _monthlySchedule = {};
  List<Map> _bookings = [];

  final List<String> _timeSlots = [
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
    '6:00 PM',
    '7:00 PM',
  ];

  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<String> _dayNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  void initState() {
    super.initState();
    _initializeMonthlySchedule();
    _loadBookings();
  }

  void _initializeMonthlySchedule() {
    _monthlySchedule.clear();
    final daysInMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    ).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
      final dateKey = _formatDateKey(date);
      _monthlySchedule[dateKey] = DayStatus(
        date: date,
        status: DayStatusType.available,
        bookingCount: 0,
        bookings: [],
      );
    }

    setState(() {});
  }

  Future<void> _loadBookings() async {
    try {
      final user = /* FirebaseAuth removed *//* .instance removed */.currentUser;
      if (user != null) {
        final startOfMonth = DateTime(
          _selectedMonth.year,
          _selectedMonth.month,
          1,
        );
        final endOfMonth = DateTime(
          _selectedMonth.year,
          _selectedMonth.month + 1,
          0,
        );

            // Database operation removed
            /* .where removed */('serviceproviderId', isEqualTo: user.uid)
            /* .where removed */(
              'scheduledDate',
              isGreaterThanOrEqualTo: /* Timestamp removed */.fromDate(startOfMonth),
            )
            /* .where removed */(
              'scheduledDate',
              isLessThanOrEqualTo: /* Timestamp removed */.fromDate(endOfMonth),
            )
            /* .get removed */();

        setState(() {
          _bookings = bookingsQuery/* .doc removed */s
              .map((doc) => {'id': doc.id, ../* .doc removed */.data()})
              .toList();
        });

        _updateScheduleWithBookings() {
          // Implementation removed
        }
    } catch (e) {
    }
  }

  void _updateScheduleWithBookings()  {
    // Implementation removed
  }

    for (var booking in _bookings)  {
      // Implementation removed
    }
      bookingsByDate[dateKey]!.add(booking);
    }

    bookingsByDate.forEach((dateKey, dayBookings) {
      if (_monthlySchedule.containsKey(dateKey)) {
        DayStatusType status = DayStatusType.available;

        final hasConfirmed = dayBookings.any((b) => b['status'] == 'confirmed');
        final hasPending = dayBookings.any((b) => b['status'] == 'pending');
        final hasCompleted = dayBookings.any((b) => b['status'] == 'completed');

        if (hasConfirmed) {
          status = DayStatusType.booked;
        } else if (hasPending) {
          status = DayStatusType.pending;
        } else if (hasCompleted) {
          status = DayStatusType.completed;
        }

        _monthlySchedule[dateKey] = DayStatus(
          date: _monthlySchedule[dateKey]!.date,
          status: status,
          bookingCount: dayBookings.length,
          bookings: dayBookings,
        );
      }
    });

    setState(() {});
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _previousPeriod() {
    setState(() {
      switch (_currentView) {
        case CalendarViewType.day:
          _selectedDate = (_selectedDate ?? DateTime.now()).subtract(
            const Duration(days: 1),
          );
          break;
        case CalendarViewType.week:
          _selectedWeek = _selectedWeek.subtract(const Duration(days: 7));
          break;
        case CalendarViewType.month:
          _selectedMonth = DateTime(
            _selectedMonth.year,
            _selectedMonth.month - 1,
          );
          break;
      }
    });
    _loadBookings();
  }

  void _nextPeriod() {
    setState(() {
      switch (_currentView) {
        case CalendarViewType.day:
          _selectedDate = (_selectedDate ?? DateTime.now()).add(
            const Duration(days: 1),
          );
          break;
        case CalendarViewType.week:
          _selectedWeek = _selectedWeek.add(const Duration(days: 7));
          break;
        case CalendarViewType.month:
          _selectedMonth = DateTime(
            _selectedMonth.year,
            _selectedMonth.month + 1,
          );
          break;
      }
    });
    _loadBookings();
  }

  String _getNavigationTitle() {
    switch (_currentView) {
      case CalendarViewType.day:
        final date = _selectedDate ?? DateTime.now();
        return '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';
      case CalendarViewType.week:
        final weekStart = _getWeekStart(_selectedWeek);
        final weekEnd = weekStart.add(const Duration(days: 6));
        if (weekStart.month == weekEnd.month) {
          return '${_monthNames[weekStart.month - 1]} ${weekStart.day}-${weekEnd.day}, ${weekStart.year}';
        } else {
          return '${_monthNames[weekStart.month - 1]} ${weekStart.day} - ${_monthNames[weekEnd.month - 1]} ${weekEnd.day}, ${weekStart.year}';
        }
      case CalendarViewType.month:
        return '${_monthNames[_selectedMonth.month - 1]} ${_selectedMonth.year}';
    }
  }

  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          _isDragging
              ? 'Drag to select dates...'
              : _isMultiSelectMode
              ? '${_selectedDates.length} selected'
              : 'My Calendar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _isDragging ? const Color(0xFF1E45AD) : Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (_isMultiSelectMode) ...[
            IconButton(
              onPressed: _clearSelection,
              icon: const Icon(Icons.clear),
              tooltip: 'Clear selection',
            ),
            IconButton(
              onPressed: _selectedDates.isNotEmpty
                  ? _showBulkAvailabilityOptions
                  : null,
              icon: const Icon(Icons.check),
              tooltip: 'Apply to selected dates',
            ),
          ] else ...[
            // Calendar view switcher
            PopupMenuButton<CalendarViewType>(
              onSelected: (CalendarViewType viewType) {
                setState(() {});
              },
              icon: const Icon(Icons.view_module),
              tooltip: 'Change view',
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: CalendarViewType.day,
                  child: Row(
                    children: [
                      Icon(
                        Icons.view_day,
                        color: _currentView == CalendarViewType.day
                            ? const Color(0xFF1E45AD)
                            : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Day View',
                        style: TextStyle(
                          color: _currentView == CalendarViewType.day
                              ? const Color(0xFF1E45AD)
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: CalendarViewType.week,
                  child: Row(
                    children: [
                      Icon(
                        Icons.view_week,
                        color: _currentView == CalendarViewType.week
                            ? const Color(0xFF1E45AD)
                            : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Week View',
                        style: TextStyle(
                          color: _currentView == CalendarViewType.week
                              ? const Color(0xFF1E45AD)
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: CalendarViewType.month,
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: _currentView == CalendarViewType.month
                            ? const Color(0xFF1E45AD)
                            : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Month View',
                        style: TextStyle(
                          color: _currentView == CalendarViewType.month
                              ? const Color(0xFF1E45AD)
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: _previousPeriod,
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                Expanded(
                  child: Text(
                    _getNavigationTitle(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed: _nextPeriod,
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),

          // Quick availability actions
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                const Text(
                  'Quick Availability Settings (Next 12 Months)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Tooltip(
                        message: 'Set all weekdays (Mon-Fri) as available',
                        child: ElevatedButton.icon(
                          onPressed: _setWeekdaysAvailable,
                          icon: const Icon(Icons.work, size: 16),
                          label: const Text(
                            'Weekdays',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E45AD),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            minimumSize: const Size(0, 40),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Tooltip(
                        message: 'Remove weekend availability (Sat-Sun)',
                        child: ElevatedButton.icon(
                          onPressed: _setWeekendsUnavailable,
                          icon: const Icon(Icons.block, size: 16),
                          label: const Text(
                            'No Weekends',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            minimumSize: const Size(0, 40),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Tooltip(
                        message:
                            'Set all days as available (including weekends)',
                        child: ElevatedButton.icon(
                          onPressed: _setAllDaysAvailable,
                          icon: const Icon(Icons.calendar_month, size: 16),
                          label: const Text(
                            'All Days',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            minimumSize: const Size(0, 40),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Multi-select info or Status legend
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _isMultiSelectMode
                ? Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.blue[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_selectedDates.length} date${_selectedDates.length == 1 ? '' : 's'} selected. Tap dates to select/deselect.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Button(
                        onPressed: _exitMultiSelectMode,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegendItem('Available', const Color(0xFFE8F5E8)),
                      _buildLegendItem('Booked', const Color(0xFF1E45AD)),
                      _buildLegendItem('Pending', const Color(0xFFFF9800)),
                      _buildLegendItem('Completed', const Color(0xFF9E9E9E)),
                    ],
                  ),
          ),

          const Divider(height: 1),

          // Calendar
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Day headers
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: _dayNames
                          .map(
                            (day) => Expanded(
                              child: Text(
                                day,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  // Calendar view
                  Expanded(child: _buildCalendarView()),
                ],
              ),
            ),
          ),

          // Selected date details or multi-select actions
          if (_selectedDate != null && !_isMultiSelectMode)
            _buildSelectedDateDetails()
          else if (_isMultiSelectMode)
            _buildMultiSelectActions(),

          // Time availability selector
          if (_isMultiSelectMode || _selectedDate != null)
            _buildTimeAvailabilitySelector(),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildWidget() {
    switch (_currentView) {
      case CalendarViewType.day:
        return _buildDayView();
      case CalendarViewType.week:
        return _buildWeekView();
      case CalendarViewType.month:
        return _buildMonthView();
    }
  }

  Widget _buildWidget() {
    final currentDate = _selectedDate ?? DateTime.now();
    final dateKey = _formatDateKey(currentDate);
    final dayStatus = _monthlySchedule[dateKey];
    final isToday = _isSameDay(currentDate, DateTime.now());

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Day header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: dayStatus != null
                  ? _getStatusColor(dayStatus.status)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: isToday
                  ? Border.all(color: const Color(0xFF1E45AD), width: 2)
                  : null,
            ),
            child: Column(
              children: [
                Text(
                  _dayNames[currentDate.weekday - 1],
                  style: TextStyle(
                    fontSize: 16,
                    color: dayStatus?.status == DayStatusType.available
                        ? Colors.grey[600]
                        : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentDate.day.toString(),
                  style: TextStyle(
                    fontSize: 48,
                    color: dayStatus != null ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (dayStatus != null && dayStatus.bookingCount > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${dayStatus.bookingCount} booking${dayStatus.bookingCount == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: dayStatus.status == DayStatusType.available
                          ? Colors.grey[600]
                          : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Day schedule - Time slots with indicators
          Expanded(child: _buildDaySchedule(currentDate, dayStatus)),
        ],
      ),
    );
  }

  Widget _buildDaySchedule(DateTime date, DayStatus? dayStatus) {
    return ListView.builder(
      itemCount: _timeSlots.length,
      itemBuilder: (context, index) {
        final timeSlot = _timeSlots[index];
        final hasBooking =
            dayStatus?.bookings.any(
              (booking) => _isTimeSlotBooked(booking, timeSlot),
            ) ??
            false;
        final isAllDay =
            dayStatus?.bookings.any((booking) => booking['isAllDay'] == true) ??
            false;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isAllDay
                ? Colors.red[100]
                : hasBooking
                ? Colors.blue[100]
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isAllDay
                  ? Colors.red[300]!
                  : hasBooking
                  ? Colors.blue[300]!
                  : Colors.grey[200]!,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  timeSlot,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isAllDay || hasBooking
                        ? Colors.black87
                        : Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isAllDay
                      ? 'ALL DAY JOB'
                      : hasBooking
                      ? 'Booked'
                      : 'Available',
                  style: TextStyle(
                    fontSize: 14,
                    color: isAllDay
                        ? Colors.red[700]
                        : hasBooking
                        ? Colors.blue[700]
                        : Colors.grey[600],
                    fontWeight: isAllDay || hasBooking
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (isAllDay)
                Icon(Icons.access_time, color: Colors.red[700], size: 16)
              else if (hasBooking)
                Icon(Icons.event, color: Colors.blue[700], size: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWidget() {
    final weekStart = _getWeekStart(_selectedWeek);

    return Column(
      children: [
        // Week days header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: List.generate(7, (index) {
              final date = weekStart.add(Duration(days: index));
              final dateKey = _formatDateKey(date);
              final dayStatus = _monthlySchedule[dateKey];
              final isToday = _isSameDay(date, DateTime.now());
              final isSelected =
                  _selectedDate != null && _isSameDay(date, _selectedDate!);

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1E45AD)
                          : dayStatus != null
                          ? _getStatusColor(dayStatus.status).withOpacity(0.3)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday
                          ? Border.all(color: const Color(0xFF1E45AD), width: 2)
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(
                          _dayNames[date.weekday - 1].substring(0, 3),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (dayStatus != null &&
                            dayStatus.bookingCount > 0) ...[
                          const SizedBox(height: 2),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : _getStatusColor(dayStatus.status),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Week schedule grid
        Expanded(child: _buildWeekScheduleGrid(weekStart)),
      ],
    );
  }

  Widget _buildWeekScheduleGrid(DateTime weekStart) {
    return SingleChildScrollView(
      child: Column(
        children: _timeSlots.map((timeSlot) {
          return Container(
            height: 60,
            margin: const EdgeInsets.only(bottom: 1),
            child: Row(
              children: [
                // Time label
                SizedBox(
                  width: 60,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      timeSlot,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // Week days
                Expanded(
                  child: Row(
                    children: List.generate(7, (dayIndex) {
                      final date = weekStart.add(Duration(days: dayIndex));
                      final dateKey = _formatDateKey(date);
                      final dayStatus = _monthlySchedule[dateKey];
                      final hasBooking =
                          dayStatus?.bookings.any(
                            (booking) => _isTimeSlotBooked(booking, timeSlot),
                          ) ??
                          false;
                      final isAllDay =
                          dayStatus?.bookings.any(
                            (booking) => booking['isAllDay'] == true,
                          ) ??
                          false;

                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: isAllDay
                                ? Colors.red[200]
                                : hasBooking
                                ? Colors.blue[200]
                                : dayStatus != null
                                ? _getStatusColor(
                                    dayStatus.status,
                                  ).withOpacity(0.1)
                                : Colors.grey[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: isAllDay
                                ? Icon(
                                    Icons.access_time,
                                    size: 12,
                                    color: Colors.red[700],
                                  )
                                : hasBooking
                                ? Icon(
                                    Icons.event,
                                    size: 12,
                                    color: Colors.blue[700],
                                  )
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(DayStatusType status) {
    switch (status) {
      case DayStatusType.available:
        return const Color(0xFF4CAF50);
      case DayStatusType.booked:
        return const Color(0xFF1E45AD);
      case DayStatusType.pending:
        return const Color(0xFFFF9800);
      case DayStatusType.completed:
        return const Color(0xFF9E9E9E);
    }
  }

  bool _isTimeSlotBooked(Map booking, String timeSlot) {
    // Simple implementation - in real app, you'd check actual booking times
    final bookingHour = booking['hour'] as String?;
    return bookingHour == timeSlot;
  }

  Widget _buildWidget() {
    final daysInMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    ).day;
    final firstDayOfMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month,
      1,
    );
    final startingWeekday = firstDayOfMonth.weekday;

    final leadingEmptyDays = startingWeekday - 1;
    final totalCells = leadingEmptyDays + daysInMonth;
    final totalRows = ((totalCells - 1) / 7).ceil();

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: totalRows * 7,
      itemBuilder: (context, index) {
        final dayNumber = index - leadingEmptyDays + 1;

        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox();
        }

        final date = DateTime(
          _selectedMonth.year,
          _selectedMonth.month,
          dayNumber,
        );
        final dateKey = _formatDateKey(date);
        final dayStatus = _monthlySchedule[dateKey];
        final isToday = _isSameDay(date, DateTime.now());
        final isSelected =
            _selectedDate != null && _isSameDay(date, _selectedDate!);
        final isMultiSelected = _selectedDates.any(
          (selectedDate) => _isSameDay(selectedDate, date),
        );

        return _buildCalendarDay(
          date,
          dayStatus,
          isToday,
          isSelected,
          isMultiSelected,
        );
      },
    );
  }

  Widget _buildCalendarDay(
    DateTime date,
    DayStatus? dayStatus,
    bool isToday,
    bool isSelected,
    bool isMultiSelected,
  ) {
    Color backgroundColor = Colors.white;
    Color textColor = Colors.black87;
    Color borderColor = Colors.transparent;

    if (dayStatus != null) {
      switch (dayStatus.status) {
        case DayStatusType.booked:
          backgroundColor = const Color(0xFF1E45AD);
          textColor = Colors.white;
          break;
        case DayStatusType.pending:
          backgroundColor = const Color(0xFFFF9800);
          textColor = Colors.white;
          break;
        case DayStatusType.completed:
          backgroundColor = const Color(0xFF9E9E9E);
          textColor = Colors.white;
          break;
        case DayStatusType.available:
          backgroundColor = const Color(0xFFE8F5E8);
          textColor = Colors.black87;
          break;
      }
    }

    // Multi-select styling overrides
    if (isMultiSelected) {
      backgroundColor = const Color(0xFF1E45AD).withOpacity(0.8);
      textColor = Colors.white;
      borderColor = const Color(0xFF1E45AD);
    } else if (isToday) {
      borderColor = const Color(0xFF1E45AD);
    } else if (isSelected) {
      borderColor = const Color(0xFF1E45AD);
    }

    return GestureDetector(
      onTap: () {
        if (_isDragging) {
          // Don't handle taps while dragging
          return;
        }
        if (_isMultiSelectMode) {
          _toggleDateSelection(date);
        } else {
          setState(() {});
        }
      },
      onLongPress: () {
        if (!_isMultiSelectMode) {
          _startMultiSelectMode(date);
        }
      },
      onLongPressStart: (details) {
        _startDragSelection(date);
      },
      onLongPressMoveUpdate: (details) {
        if (_isDragging) {
          // Calculate which date the user is currently over
          _updateDragSelection(date) {
            // Implementation removed
          }
      },
      onLongPressEnd: (details) {
        if (_isDragging) {
          _endDragSelection();
        }
      },
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: borderColor != Colors.transparent
              ? Border.all(color: borderColor, width: 2)
              : null,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                    color: textColor,
                  ),
                ),
                if (dayStatus != null && dayStatus.bookingCount > 0) ...[
                  const SizedBox(height: 2),
                  _buildDayIndicators(dayStatus, textColor),
                ],
              ],
            ),
            // Multi-select checkbox
            if (isMultiSelected)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Color(0xFF1E45AD),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayIndicators(DayStatus dayStatus, Color textColor) {
    final hasAllDayJob = dayStatus.bookings.any(
      (booking) => booking['isAllDay'] == true,
    );
    final regularBookings = dayStatus.bookings
        /* .where removed */((booking) => booking['isAllDay'] != true)
        .length;

    if (hasAllDayJob) {
      // Show ALL DAY indicator
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        decoration: BoxDecoration(
          color: Colors.red[600],
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'ALL DAY',
          style: TextStyle(
            fontSize: 7,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (regularBookings > 0) {
      // Show booking count with time indicators
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$regularBookings',
              style: TextStyle(
                fontSize: 10,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 2),
          // Small time indicator dots
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              (regularBookings > 3 ? 3 : regularBookings),
              (index) => Container(
                width: 3,
                height: 3,
                margin: const EdgeInsets.only(right: 1),
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget _buildWidget() {
    if (_selectedDate == null) return const SizedBox();

    final dateKey = _formatDateKey(_selectedDate!);
    final dayStatus = _monthlySchedule[dateKey];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _formatSelectedDate(_selectedDate!),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Button(
                onPressed: () {
                  setState(() {});
                },
                child: const Text('Close'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (dayStatus == null || dayStatus.bookingCount == 0)
            const Text(
              'No bookings for this day',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            )
          else ...[
            Text(
              '${dayStatus.bookingCount} booking${dayStatus.bookingCount > 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            ...dayStatus.bookings.map((booking) => _buildBookingItem(booking)),
          ],

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Button(
              onPressed: () {
                // TODO: Manage availability for this day
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E45AD),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Manage This Day',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingItem(Map booking) {
    Color statusColor = _getBookingStatusColor(booking['status']);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking['serviceType'] ?? 'Service',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (booking['clientName'] != null)
                  Text(
                    booking['clientName'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                Text(
                  booking['scheduledTime'] ?? '9:00 AM',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            _capitalizeFirst(booking['status'] ?? 'pending'),
            style: TextStyle(
              fontSize: 12,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBookingStatusColor(String? status) {
    switch (status) {
      case 'confirmed':
        return const Color(0xFF1E45AD);
      case 'pending':
        return const Color(0xFFFF9800);
      case 'completed':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _formatSelectedDate(DateTime date) {
    final dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final dayName = dayNames[date.weekday - 1];
    return '$dayName, ${_monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _startMultiSelectMode(DateTime initialDate) {
    setState(() {});
  }

  void _toggleDateSelection(DateTime date) {
    setState(() {
      if (_selectedDates.contains(date)) {
        _selectedDates.remove(date);
      } else {
        _selectedDates.add(date);
      }
    });
  }

  void _exitMultiSelectMode() {
    setState(() {});
  }

  void _clearSelection() {
    setState(() {});
  }

  void _startDragSelection(DateTime startDate) {
    setState(() {
      _isDragging = true;
      _dragStartDate = startDate;
      if (!_isMultiSelectMode) {
        _isMultiSelectMode = true;
        _selectedDates.clear();
      }
      _selectedDates.add(startDate);
    });

    // Provide haptic feedback
    HapticFeedback.mediumImpact();
  }

  void _updateDragSelection(DateTime currentDate)  {
    // Implementation removed
  }
  }

  void _endDragSelection() {
    setState(() {});
  }

  void _setWeekdaysAvailable() {
    _showConfirmationDialog(
      title: 'Set Weekdays Available',
      message:
          'This will set all weekdays (Monday-Friday) as available for the current month and all following months. Continue?',
      onConfirm: () => _applyWeekdayAvailability(true),
    );
  }

  void _setWeekendsUnavailable() {
    _showConfirmationDialog(
      title: 'Remove Weekend Availability',
      message:
          'This will make all weekends (Saturday-Sunday) unavailable for the current month and all following months. Continue?',
      onConfirm: () => _applyWeekendAvailability(false),
    );
  }

  void _setAllDaysAvailable() {
    _showConfirmationDialog(
      title: 'Set All Days Available',
      message:
          'This will set all days (including weekends) as available for the current month and all following months. Continue?',
      onConfirm: () => _applyAllDaysAvailability(true),
    );
  }

  void _showConfirmationDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          Button(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Button(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E45AD),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _applyWeekdayAvailability(bool isAvailable) {
    int monthsToUpdate = 12; // Update current month + next 11 months
    int updatedDays = 0;

    setState(() {
      for (int monthOffset = 0; monthOffset < monthsToUpdate; monthOffset++) {
        DateTime targetMonth = DateTime(
          _selectedMonth.year,
          _selectedMonth.month + monthOffset,
        );
        DateTime firstDay = DateTime(targetMonth.year, targetMonth.month, 1);
        DateTime lastDay = DateTime(targetMonth.year, targetMonth.month + 1, 0);

        for (
          DateTime date = firstDay;
          !date.isAfter(lastDay);
          date = date.add(const Duration(days: 1))
        ) {
          // Check if it's a weekday (Monday = 1, Friday = 5)
          if (date.weekday >= 1 && date.weekday <= 5) {
            String dateKey = _formatDateKey(date);

            if (isAvailable) {
              _monthlySchedule[dateKey] = DayStatus(
                date: date,
                status: DayStatusType.available,
                bookingCount: 0,
                bookings: [],
              );
              // Apply default time slots if they exist
              // TODO: Implement time slot storage and application
            } else {
              _monthlySchedule.remove(dateKey);
            }
            updatedDays++;
          }
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Updated $updatedDays weekdays for the next 12 months'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  void _applyWeekendAvailability(bool isAvailable) {
    int monthsToUpdate = 12; // Update current month + next 11 months
    int updatedDays = 0;

    setState(() {
      for (int monthOffset = 0; monthOffset < monthsToUpdate; monthOffset++) {
        DateTime targetMonth = DateTime(
          _selectedMonth.year,
          _selectedMonth.month + monthOffset,
        );
        DateTime firstDay = DateTime(targetMonth.year, targetMonth.month, 1);
        DateTime lastDay = DateTime(targetMonth.year, targetMonth.month + 1, 0);

        for (
          DateTime date = firstDay;
          !date.isAfter(lastDay);
          date = date.add(const Duration(days: 1))
        ) {
          // Check if it's a weekend (Saturday = 6, Sunday = 7)
          if (date.weekday == 6 || date.weekday == 7) {
            String dateKey = _formatDateKey(date);

            if (isAvailable) {
              _monthlySchedule[dateKey] = DayStatus(
                date: date,
                status: DayStatusType.available,
                bookingCount: 0,
                bookings: [],
              );
            } else {
              _monthlySchedule.remove(dateKey);
            }
            updatedDays++;
          }
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAvailable
              ? 'Made $updatedDays weekend days available for the next 12 months'
              : 'Removed availability for $updatedDays weekend days for the next 12 months',
        ),
        backgroundColor: isAvailable ? const Color(0xFF4CAF50) : Colors.red,
      ),
    );
  }

  void _applyAllDaysAvailability(bool isAvailable) {
    int monthsToUpdate = 12; // Update current month + next 11 months
    int updatedDays = 0;

    setState(() {
      for (int monthOffset = 0; monthOffset < monthsToUpdate; monthOffset++) {
        DateTime targetMonth = DateTime(
          _selectedMonth.year,
          _selectedMonth.month + monthOffset,
        );
        DateTime firstDay = DateTime(targetMonth.year, targetMonth.month, 1);
        DateTime lastDay = DateTime(targetMonth.year, targetMonth.month + 1, 0);

        for (
          DateTime date = firstDay;
          !date.isAfter(lastDay);
          date = date.add(const Duration(days: 1))
        ) {
          String dateKey = _formatDateKey(date);

          if (isAvailable) {
            _monthlySchedule[dateKey] = DayStatus(
              date: date,
              status: DayStatusType.available,
              bookingCount: 0,
              bookings: [],
            );
          } else {
            _monthlySchedule.remove(dateKey);
          }
          updatedDays++;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAvailable
              ? 'Made all $updatedDays days available for the next 12 months'
              : 'Removed availability for all $updatedDays days for the next 12 months',
        ),
        backgroundColor: isAvailable ? const Color(0xFF4CAF50) : Colors.red,
      ),
    );
  }

  void _showBulkAvailabilityOptions() {
    if (_selectedDates.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set Availability for ${_selectedDates.length} Days',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check_circle, color: Colors.green),
              ),
              title: const Text('Set as Available'),
              subtitle: const Text(
                'Mark selected dates as available for bookings',
              ),
              onTap: () {
                _setBulkAvailability(DayStatusType.available);
                Navigator.navigate();
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.block, color: Colors.grey),
              ),
              title: const Text('Set as Unavailable'),
              subtitle: const Text('Block selected dates from bookings'),
              onTap: () {
                _setBulkAvailability(null); // null means unavailable
                Navigator.navigate();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _setBulkAvailability(DayStatusType? status) {
    // Store selected dates count before clearing
    int selectedCount = _selectedDates.length;

    for (DateTime date in _selectedDates) {
      String dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      if (status != null) {
        _monthlySchedule[dateKey] = DayStatus(
          date: date,
          status: status,
          bookingCount: 0,
          bookings: [],
        );
      } else {
        _monthlySchedule.remove(dateKey);
      }
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status != null
              ? 'Marked $selectedCount days as available'
              : 'Marked $selectedCount days as unavailable',
        ),
        backgroundColor: const Color(0xFF1E45AD),
      ),
    );
  }

  Widget _buildWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${_selectedDates.length} day${_selectedDates.length == 1 ? '' : 's'} selected',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Button(
                onPressed: () {
                  setState(() {});
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Button(
                  onPressed: () => _setBulkAvailability(null),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text(
                    'Mark Unavailable',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Button(
                  onPressed: () =>
                      _setBulkAvailability(DayStatusType.available),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                  ),
                  child: const Text(
                    'Mark Available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Hours',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (_defaultTimeSlots.isNotEmpty)
                    Text(
                      'Default: ${_defaultTimeSlots.join(', ')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              if (_defaultTimeSlots.isNotEmpty) ...[
                Button(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text(
                    'Use Default',
                    style: TextStyle(color: Color(0xFF4CAF50)),
                  ),
                ),
              ],
              Button(
                onPressed: () {
                  setState(() {
                    if (_selectedTimeSlots.length == _timeSlots.length) {
                      _selectedTimeSlots.clear();
                    } else {
                      _selectedTimeSlots.addAll(_timeSlots);
                    }
                  });
                },
                child: Text(
                  _selectedTimeSlots.length == _timeSlots.length
                      ? 'Clear All'
                      : 'Select All',
                  style: const TextStyle(color: Color(0xFF1E45AD)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.5,
            ),
            itemCount: _timeSlots.length,
            itemBuilder: (context, index) {
              final timeSlot = _timeSlots[index];
              final isSelected = _selectedTimeSlots.contains(timeSlot);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedTimeSlots.remove(timeSlot);
                    } else {
                      _selectedTimeSlots.add(timeSlot);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF1E45AD)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1E45AD)
                          : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      timeSlot,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Button(
                  onPressed: _selectedTimeSlots.isNotEmpty
                      ? _saveTimeAvailability
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E45AD),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    _isMultiSelectMode
                        ? 'Set Hours for Selected Days'
                        : 'Save Availability Hours',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Button(
                  onPressed: _selectedTimeSlots.isNotEmpty
                      ? _setDefaultTimeAvailability
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Set as Default Hours',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Default hours will apply to all future available days',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _saveTimeAvailability()  {
    // Implementation removed
  }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Availability hours saved for ${targetDates.length} day${targetDates.length == 1 ? '' : 's'}',
        ),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );

    if (_isMultiSelectMode) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  void _setDefaultTimeAvailability() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Default Working Hours'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'These hours will be automatically applied to all future available dates created by the quick availability buttons.',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Text(
              'Selected Hours: ${_selectedTimeSlots.join(', ')}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Button(
            onPressed: () {
              Navigator.of(context).pop();
              _applyDefaultTimeAvailability();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
            ),
            child: const Text(
              'Set as Default',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _applyDefaultTimeAvailability() {
    setState(() {});

    // Apply default hours to all existing available days
    _applyDefaultHoursToAllAvailableDays();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Default working hours set: ${_defaultTimeSlots.join(', ')}\nApplied to all available days for next 12 months.',
        ),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 4),
      ),
    );

    // Clear current selection
    setState(() {
      _selectedTimeSlots.clear();
      if (_isMultiSelectMode) {
        _isMultiSelectMode = false;
        _selectedDates.clear();
      } else {
        _selectedDate = null;
      }
    });
  }

  void _applyDefaultHoursToAllAvailableDays() {
    if (_defaultTimeSlots.isEmpty) return;

    int monthsToUpdate = 12;

    setState(() {
      for (int monthOffset = 0; monthOffset < monthsToUpdate; monthOffset++) {
        DateTime targetMonth = DateTime(
          _selectedMonth.year,
          _selectedMonth.month + monthOffset,
        );
        DateTime firstDay = DateTime(targetMonth.year, targetMonth.month, 1);
        DateTime lastDay = DateTime(targetMonth.year, targetMonth.month + 1, 0);

        for (
          DateTime date = firstDay;
          !date.isAfter(lastDay);
          date = date.add(const Duration(days: 1))
        ) {
          String dateKey = _formatDateKey(date);

          // Only update days that are already marked as available
          if (_monthlySchedule.containsKey(dateKey) &&
              _monthlySchedule[dateKey]!.status == DayStatusType.available) {
            // TODO: Store time availability data in the DayStatus object or separate collection
            // For now, we'll just note that this day has default hours applied
          }
        }
      }
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class DayStatus {
  final DateTime date;
  final DayStatusType status;
  final int bookingCount;
  final List<Map> bookings;

  DayStatus({
    required this.date,
    required this.status,
    required this.bookingCount,
    required this.bookings,
  });
}

enum DayStatusType { available, booked, pending, completed }

enum CalendarViewType { day, week, month }

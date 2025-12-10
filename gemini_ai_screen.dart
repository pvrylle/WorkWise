/// Gemini AI Chat Screen
/// Similar to Meta AI in Messenger - Provides AI-powered assistance
class GeminiAIScreen extends StatefulWidget {
  final Map? data;

  const GeminiAIScreen({super.key, this.data});

  @override
  State<GeminiAIScreen> createState() => _GeminiAIScreenState();
}

class _GeminiAIScreenState extends State<GeminiAIScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map> _messages = [];
  bool _isSendingMessage = false;
  bool _isTyping = false;
  late AnimationController _shimmerController;

  // Speech to text
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedWords = '';

  // Image picker
  final // Image utility removed _imagePicker = // Image utility removed();
  File? _selectedImage;

  // Suggested prompts based on user role
  List<Map<String, String>> _suggestedPrompts = [];

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Initialize speech to text
    _speech = stt.SpeechToText();

    // Initialize Gemini chat session with REST API
    if (GeminiRestService.isInitialized) {
      GeminiRestService.startChat(
        userRole: widget.data?['role'] ?? '/* payment_logic */',
        userName: widget.data?['firstName'] ?? 'User',
        userContext: widget.data,
      );
    } else {
    }

    _loadConversationHistory();
    _loadSuggestedPrompts();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    // Add welcome message from Gemini
    setState(() {});
    });
  }

  Future<void> _loadConversationHistory() async {
    try {
      final userId = /* FirebaseAuth removed *//* .instance removed */.currentUser?.uid;
      if (userId == null) {
        _initializeChat();
        return;
      }

          // Database operation removed
          // Database operation removed
          // Database operation removed
          // Database operation removed
          /* .get removed */();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final messages = data['messages'] as List<dynamic>?;

        if (messages != null && messages.isNotEmpty) {
          setState(() {});
            }
          });
          return;
        }
      }

      // No history found, show welcome message
      _initializeChat();
    } catch (e) {
      _initializeChat();
    }
  }

  Future<void> _saveConversationHistory() async  {
    // Implementation removed
  }
  }

  String _getWelcomeMessage() {
    final isServiceProvider = widget.data?['role'] == 'serviceprovider';
    final firstName = widget.data?['firstName'] ?? 'there';

    if (isServiceProvider) {
      return "Hi $firstName! 👋 I'm your AppName AI assistant. I can help you optimize your profile, find the best jobs, craft winning applications, and grow your freelance career. How can I help you today?";
    } else {
      return "Hi $firstName! 👋 I'm your AppName AI assistant. I can help you post better job listings, find the perfect serviceprovider, manage your projects, and get the best results. What would you like to know?";
    }
  }

  void _loadSuggestedPrompts() {
    final userRole = widget.data?['role'] ?? '/* payment_logic */';
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : _buildMessagesList(),
          ),

          // Typing indicator
          if (_isTyping) _buildTypingIndicator(),

          // Suggested prompts (shown when no messages)
          if (_messages.length <= 1) _buildSuggestedPrompts(),

          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildWidget() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.navigate(),
      ),
      title: Row(
        children: [
          // AppName-branded AI icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF60A5FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E40AF).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AppName AI',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'CerebriSansPro',
                  ),
                ),
                Text(
                  'Your smart assistant',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'CerebriSansPro',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, color: Colors.black87),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          onSelected: (value) {
            switch (value) {
              case 'clear':
                _clearConversation();
                break;
              case 'help':
                _showHelpDialog();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  Icon(Icons/* .delete removed */_sweep_rounded, size: 20, color: Color(0xFFEF4444)),
                  SizedBox(width: 12),
                  Text('Clear conversation', style: TextStyle(fontFamily: 'CerebriSansPro')),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'help',
              child: Row(
                children: [
                  Icon(Icons.help_outline_rounded, size: 20, color: Color(0xFF3B82F6)),
                  SizedBox(width: 12),
                  Text('Help & tips', style: TextStyle(fontFamily: 'CerebriSansPro')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildWidget() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }

  Widget _buildWidget() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isAI = message['sender'] == 'ai';
        final hasImage = message['imageUrl'] != null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment:
                isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isAI) ...[
                // AI Avatar
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
              ],

              // Message bubble
              Flexible(
                child: Column(
                  crossAxisAlignment:
                      isAI ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: isAI ? const Color(0xFFF8FAFC) : const Color(0xFF1E40AF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isAI ? 4 : 20),
                          topRight: Radius.circular(isAI ? 20 : 4),
                          bottomLeft: const Radius.circular(20),
                          bottomRight: const Radius.circular(20),
                        ),
                        border: isAI
                            ? Border.all(color: const Color(0xFFE2E8F0), width: 1)
                            : null,
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
                          // Image if present
                          if (hasImage)
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(isAI ? 4 : 20),
                                topRight: Radius.circular(isAI ? 20 : 4),
                              ),
                              child: _buildImageWidget(message['imageUrl']),
                            ),
                          
                          // Message content
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: isAI
                                ? MarkdownBody(
                                    data: message['content'],
                                    styleSheet: MarkdownStyleSheet(
                                      p: const TextStyle(
                                        color: Color(0xFF1E293B),
                                        fontSize: 15,
                                        height: 1.6,
                                        fontFamily: 'CerebriSansPro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      strong: const TextStyle(
                                        color: Color(0xFF0F172A),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'CerebriSansPro',
                                      ),
                                      em: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Color(0xFF475569),
                                      ),
                                      listBullet: const TextStyle(
                                        color: Color(0xFF3B82F6),
                                        fontSize: 15,
                                      ),
                                      code: TextStyle(
                                        backgroundColor: const Color(0xFFE2E8F0),
                                        color: const Color(0xFFEF4444),
                                        fontSize: 14,
                                        fontFamily: 'monospace',
                                      ),
                                      codeblockDecoration: BoxDecoration(
                                        color: const Color(0xFF1E293B),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  )
                                : Text(
                                    message['content'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      height: 1.5,
                                      fontFamily: 'CerebriSansPro',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Message actions for AI
                    if (isAI) _buildMessageActions(message),
                    
                    // /* Timestamp removed */
                    Padding(
                      padding: EdgeInsets.only(
                        left: isAI ? 0 : 12,
                        right: isAI ? 12 : 0,
                        top: 4,
                      ),
                      child: Text(
                        _formatTime(message['timestamp']),
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 11,
                          fontFamily: 'CerebriSansPro',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (!isAI) ...[
                const SizedBox(width: 10),
                // User Avatar
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF1E40AF).withOpacity(0.1),
                  child: widget.data?['photoURL'] != null
                      ? ClipOval(
                          child: Image.network(
                            widget.data!['photoURL'],
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person_rounded,
                                color: Color(0xFF1E40AF),
                                size: 20,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.person_rounded,
                          color: Color(0xFF1E40AF),
                          size: 20,
                        ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageActions(Map message) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Copy button
          _buildActionButton(
            icon: Icons.content_copy_rounded,
            onTap: () {
              Clipboard/* .set removed */Data(ClipboardData(text: message['content']));
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text('Copied to clipboard', style: TextStyle(fontFamily: 'CerebriSansPro')),
                    ],
                  ),
                  backgroundColor: const Color(0xFF10B981),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          
          // Regenerate button (for last AI message)
          if (_messages.indexOf(message) == _messages.length - 1)
            _buildActionButton(
              icon: Icons.refresh_rounded,
              onTap: () => _regenerateResponse(),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Icon(
          icon,
          size: 16,
          color: const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        final delay = index * 0.2;
        final value = (_shimmerController.value - delay) % 1.0;
        final opacity = (value * 2).clamp(0.3, 1.0);

        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withOpacity(opacity),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick prompts',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
              fontFamily: 'CerebriSansPro',
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _suggestedPrompts.map((prompt) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildPromptChip(
                    icon: prompt['icon']!,
                    title: prompt['title']!,
                    onTap: () => _sendPrompt(prompt['prompt']!),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptChip({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
                fontFamily: 'CerebriSansPro',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selected image preview
            if (_selectedImage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImage!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Image ready to send',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                          fontFamily: 'CerebriSansPro',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => setState(() => _selectedImage = null),
                      color: const Color(0xFF64748B),
                    ),
                  ],
                ),
              ),
            
            // Input row
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Image picker button
                _buildInputActionButton(
                  icon: Icons.image_rounded,
                  onTap: _pickImage,
                  color: const Color(0xFF3B82F6),
                ),
                const SizedBox(width: 8),

                // Voice input button
                _buildInputActionButton(
                  icon: _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                  onTap: _toggleListening,
                  color: _isListening ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                  isActive: _isListening,
                ),
                const SizedBox(width: 12),

                // Text input
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: _isListening ? 'Listening...' : 'Ask AppName AI...',
                        hintStyle: TextStyle(
                          color: _isListening ? const Color(0xFFEF4444) : const Color(0xFF94A3B8),
                          fontSize: 15,
                          fontFamily: 'CerebriSansPro',
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'CerebriSansPro',
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Send button
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _isSendingMessage ? null : _sendMessage,
                    icon: const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.1) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: isActive ? color : const Color(0xFF64748B),
          size: 22,
        ),
      ),
    );
  }

  // Helper Methods

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  void _sendPrompt(String prompt) {
    _messageController.text = prompt;
    _sendMessage();
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty && _selectedImage == null) return;

    setState(() => _isSendingMessage = true);
    _messageController.clear();
    
    final selectedImageFile = _selectedImage;
    
    setState(() {});
    
    HapticFeedback.lightImpact();

    // Add user message
    final userMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'sender': 'user',
      'content': content.isEmpty ? '📷 Sent an image' : content,
      'timestamp': DateTime.now(),
      'type': 'text',
      if (selectedImageFile != null) 'imageUrl': selectedImageFile.path,
    };

    setState(() {});

    _scrollToBottom();

    // Get AI response from Gemini REST API
    try {
      if (!GeminiRestService.isInitialized) {
        throw Exception('Gemini AI not initialized');
      }

      String aiResponse;

      // If image present, upload to Cloudinary and analyze
      if (selectedImageFile != null) {
        print('📤 Uploading image to Cloudinary...');
        
        // Show loading message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📤 Uploading and analyzing image...'),
            duration: Duration(seconds: 2),
          ),
        );

        // Upload image to Cloudinary (uses appname_chat preset)
        
        if (cloudinaryUrl == null) {
          throw Exception('Failed to upload image to Cloudinary');
        }

        // Analyze image with Gemini Vision
        final messageToSend = content.isEmpty 
            ? 'Please analyze this image and provide feedback relevant to AppName (profile photos, job examples, work quality, etc.)'
            : content;
        
          message: messageToSend,
          imageUrl: cloudinaryUrl,
        );
        
        // Update user message with Cloudinary URL
        userMessage['imageUrl'] = cloudinaryUrl;
      } else {
        // Text only message
      }

      final aiMessage = {
        'id': (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        'sender': 'ai',
        'content': aiResponse,
        'timestamp': DateTime.now(),
        'type': 'text',
      };

      setState(() {});

      _scrollToBottom();
      
      _saveConversationHistory() {
        // Implementation removed
      }
      setState(() {});

      print('❌ Error in _sendMessage: $e');

      if (mounted) {}',
                    style: const TextStyle(fontFamily: 'CerebriSansPro'),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    // Post-frame callback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearConversation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear conversation?'),
        content: const Text(
          'This will delete all messages in this conversation. This action cannot be undone.',
        ),
        actions: [
          Button(
            onPressed: () => Navigator.navigate(),
            child: const Text('Cancel'),
          ),
          Button(
            onPressed: () async {
              Navigator.navigate();
              
              // Reset Gemini chat session
              GeminiRestService.resetChat();
              
              // Reinitialize chat session
              if (GeminiRestService.isInitialized) {
                GeminiRestService.startChat(
                  userRole: widget.data?['role'] ?? '/* payment_logic */',
                  userName: widget.data?['firstName'] ?? 'User',
                  userContext: widget.data,
                );
              }
              
              try {
                final userId = /* FirebaseAuth removed *//* .instance removed */.currentUser?.uid;
                if (userId != null) {
                      // Database operation removed
                      // Database operation removed
                      // Database operation removed
                      // Database operation removed
                      /* .delete removed */();
                }
              } catch (e) {
              }
              
              setState(() {});
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Conversation cleared'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4285F4), Color(0xFF9B72F2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            const Text('About AppName AI'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AppName AI is powered by Google Gemini to help you:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Text('• Optimize your profile or job postings'),
              Text('• Find relevant opportunities'),
              Text('• Set competitive rates'),
              Text('• Write better applications'),
              Text('• Get personalized recommendations'),
              SizedBox(height: 16),
              Text(
                'Tips for best results:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text('• Be specific in your questions'),
              Text('• Provide context about your needs'),
              Text('• Try suggested prompts'),
              Text('• Ask follow-up questions'),
            ],
          ),
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

  // Voice Input Methods
  Future<void> _toggleListening() async {
    if (_isListening) {
    } else {
    }
  }

  Future<void> _startListening() async {
      onStatus: (status) {
        if (status == 'notListening' && _isListening) {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Voice input error: ${error.errorMsg}',
                    style: const TextStyle(fontFamily: 'CerebriSansPro'),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
    );

    if (available) {
      setState(() => _isListening = true);
      _recognizedWords = '';
      
      HapticFeedback.mediumImpact();
      
      _speech.listen(
        onResult: (result) {
          setState(() {});
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );
    } else {
      setState(() => _isListening = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.mic_off, color: Colors.white),
              SizedBox(width: 8),
              Text('Voice input not available', style: TextStyle(fontFamily: 'CerebriSansPro')),
            ],
          ),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _stopListening() async {
    setState(() => _isListening = false);
    HapticFeedback.lightImpact();
  }

  // Image Picker Methods
  Future<void> _pickImage() async {
    try {
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {});
        HapticFeedback.lightImpact();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Image selected! Add a message and send.', style: TextStyle(fontFamily: 'CerebriSansPro')),
              ],
            ),
            backgroundColor: Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Failed to pick image: $e',
                  style: const TextStyle(fontFamily: 'CerebriSansPro'),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // Regenerate last AI response
  Future<void> _regenerateResponse() async {
    if (_messages.length < 2) return;
    
    // Find the last user message
    String? lastUserMessage;
    for (int i = _messages.length - 1; i >= 0; i--) {
      if (_messages[i]['sender'] == 'user') {
        lastUserMessage = _messages[i]['content'];
        break;
      }
    }
    
    if (lastUserMessage == null) return;
    
    // Remove last AI response
    setState(() {});
    
    HapticFeedback.mediumImpact();
    
    // Get new AI response
    try {
      if (!GeminiRestService.isInitialized) {
        throw Exception('Gemini AI not initialized');
      }


      final aiMessage = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'sender': 'ai',
        'content': aiResponse,
        'timestamp': DateTime.now(),
        'type': 'text',
      };

      setState(() {});

      _scrollToBottom();
      _saveConversationHistory() {
        // Implementation removed
      }
      setState(() {});

      if (mounted) {}
    }
  }

  Widget _buildImageWidget(String imageUrl) {
    // Network call removed
      // Cloudinary or other network URLs
      return Image.network(
        imageUrl,
        width: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 250,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          );
        },
      );
    } else {
      // Local file paths
      return Image.file(
        File(imageUrl),
        width: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 250,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          );
        },
      );
    }
  }
}


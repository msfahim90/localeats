import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../utils/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final String vendorName;
  const ChatScreen({super.key, required this.vendorName});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isTyping = false;

  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hello! Welcome to ${''} 👋 How can I help you?', 'isMe': false, 'time': '2:30 PM'},
    {'text': 'Hi! Is the Chicken Biryani available today?', 'isMe': true, 'time': '2:31 PM'},
    {'text': 'Yes! Fresh biryani is ready 🍚 Would you like to order?', 'isMe': false, 'time': '2:31 PM'},
    {'text': 'Great! How long will delivery take?', 'isMe': true, 'time': '2:32 PM'},
    {'text': 'Around 15-20 minutes to your location 🛵', 'isMe': false, 'time': '2:32 PM'},
  ];

  final List<String> _autoReplies = [
    'Sure! We can prepare that for you 😊',
    'Great choice! Adding it to your order 🍽️',
    'Our delivery time is 15-25 minutes ⏱️',
    'Yes, that item is available today! ✅',
    'Thank you for your order! 🙏',
    'We use fresh ingredients daily 🌿',
  ];

  void _sendMessage() {
    if (_msgCtrl.text.trim().isEmpty) return;
    final msg = _msgCtrl.text.trim();
    setState(() {
      _messages.add({'text': msg, 'isMe': true, 'time': _currentTime});
      _isTyping = true;
    });
    _msgCtrl.clear();
    _scrollToBottom();

    // Auto reply
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            'text': _autoReplies[_messages.length % _autoReplies.length],
            'isMe': false,
            'time': _currentTime,
          });
        });
        _scrollToBottom();
      }
    });
  }

  String get _currentTime {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour < 12 ? 'AM' : 'PM'}';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: AppColors.lightGreen, shape: BoxShape.circle),
              child: const Center(child: Text('🏠', style: TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.vendorName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text('Online', style: GoogleFonts.poppins(fontSize: 11, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.phone_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == _messages.length && _isTyping) {
                  return _TypingIndicator();
                }
                final msg = _messages[i];
                return _MessageBubble(message: msg);
              },
            ),
          ),
          // Quick replies
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                '👍 OK', '⏱️ How long?', '🍽️ Menu?', '📍 Location?', '💰 Price?'
              ].map((q) => GestureDetector(
                onTap: () {
                  _msgCtrl.text = q.substring(3);
                  _sendMessage();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Text(q, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: _msgCtrl,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.poppins(color: AppColors.textGray, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 46, height: 46,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message['isMe'] as bool;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 30, height: 30,
              decoration: const BoxDecoration(color: AppColors.lightGreen, shape: BoxShape.circle),
              child: const Center(child: Text('��', style: TextStyle(fontSize: 14))),
            ),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.primary : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMe ? 16 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 16),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)],
                ),
                child: Text(message['text'],
                    style: GoogleFonts.poppins(
                      color: isMe ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 13,
                      height: 1.4,
                    )),
              ),
              const SizedBox(height: 4),
              Text(message['time'], style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGray)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 30, height: 30,
            decoration: const BoxDecoration(color: AppColors.lightGreen, shape: BoxShape.circle),
            child: const Center(child: Text('🏠', style: TextStyle(fontSize: 14))),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _Dot(delay: 0),
                const SizedBox(width: 4),
                _Dot(delay: 200),
                const SizedBox(width: 4),
                _Dot(delay: 400),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});
  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _anim = Tween<double>(begin: 0, end: 1).animate(_ctrl);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, -4 * _anim.value),
        child: Container(
          width: 8, height: 8,
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.6), shape: BoxShape.circle),
        ),
      ),
    );
  }
}

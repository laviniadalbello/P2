import "package:flutter/material.dart";
import "dart:async";
import "package:file_picker/file_picker.dart";
/* import "package:flutter_animate/flutter_animate.dart";  */

const Color kDarkPrimary = Color.fromARGB(249, 0, 0, 0); // fundo principal
const Color kDarkSecondary = Color.fromARGB(
  108,
  11,
  15,
  29,
); //  elementos secundários (ex: AppBar)
const Color kAccentPurple = Color.fromARGB(
  197,
  245,
  73,
  214,
); // acentos e botões de ação
const Color kLighterPurple = Color.fromARGB(234, 205, 113, 241);
const Color kTextColor = Color(0xFFEAEAEA); // texto principal
const Color kSubtleTextColor = Color(0xFFA0A0A0); // texto secundário/timestamps
const Color kUserMessageBubble = Color(0xFF9E62FF); //  balão do usuário
const Color kAiMessageBubble = Color(0xFF6D5DF6); // balão da IA
const Color kInputBackground = Color(0xFF101022); // Fundo do campo de input
const Color kTypingIndicatorColor = kSubtleTextColor;

class Message {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  String? fileName;
  String? filePath;
  String? reaction;

  Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.fileName,
    this.filePath,
    this.reaction,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required String title});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isAiTyping = false;

  late AnimationController _sendButtonAnimationController;
  late Animation<double> _sendButtonAnimation;

  @override
  void initState() {
    super.initState();
    _addInitialMessages();

    _sendButtonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _sendButtonAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _sendButtonAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _addInitialMessages() {
    setState(() {
      _messages.addAll([
        Message(
          id: "1",
          text:
              "Olá! Agora com envio de arquivos e reações (pressione e segure uma mensagem)!",
          isUser: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
        Message(
          id: "2",
          text: "Que demais! Vou testar o envio de arquivo.",
          isUser: true,
          timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
      ]);
    });
  }

  void _sendMessage({String? text, String? fileName, String? filePath}) {
    final String messageText = text ?? _textController.text.trim();
    if (messageText.isEmpty && fileName == null) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: messageText,
      isUser: true,
      timestamp: DateTime.now(),
      fileName: fileName,
      filePath: filePath,
    );

    setState(() {
      _messages.add(newMessage);
      if (fileName == null) _textController.clear();
    });

    _sendButtonAnimationController.forward().then(
      (_) => _sendButtonAnimationController.reverse(),
    );
    _scrollToBottom();
    _simulateAiResponse(newMessage);
  }

  void _simulateAiResponse(Message userMessage) {
    setState(() => _isAiTyping = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() => _isAiTyping = false);
      String responseText = "Entendido: ";
      if (userMessage.fileName != null) {
        responseText += "Você enviou o arquivo '${userMessage.fileName}'. ";
      } else {
        responseText += "'${userMessage.text}'. ";
      }
      responseText += "Processando sua elegante solicitação...";

      final aiResponse = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      );
      setState(() => _messages.add(aiResponse));
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 50,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuad,
        );
      }
    });
  }

  void _addReaction(String messageId, String reactionEmoji) {
    setState(() {
      final index = _messages.indexWhere((msg) => msg.id == messageId);
      if (index != -1) {
        _messages[index].reaction =
            _messages[index].reaction == reactionEmoji ? null : reactionEmoji;
      }
    });
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        String fileName = result.files.single.name;
        String filePath = result.files.single.path!;
        _sendMessage(text: "", fileName: fileName, filePath: filePath);
        print("Arquivo selecionado: $fileName, Caminho: $filePath");
      } else {
        print("Nenhum arquivo selecionado ou caminho nulo.");
      }
    } catch (e) {
      print("Erro ao selecionar arquivo: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao selecionar arquivo: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkPrimary,
      appBar: AppBar(
        backgroundColor: kDarkSecondary,
        elevation: 1,
        title: const Text(
          "Chat IA Melhorado",
          style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kTextColor),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: kTextColor),
            onPressed: () {
              /* Ações do menu */
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 20.0,
              ),
              itemCount: _messages.length + (_isAiTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isAiTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                }
                final message = _messages[index];
                return MessageBubble(
                  message: message,
                  onReaction: (reaction) => _addReaction(message.id, reaction),
                );
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: kAiMessageBubble,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  kTypingIndicatorColor,
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              "IA está digitando...",
              style: TextStyle(
                color: kSubtleTextColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: kDarkSecondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file_outlined, color: kAccentPurple),
            onPressed: _pickFile,
            tooltip: "Anexar arquivo",
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              style: const TextStyle(color: kTextColor, fontSize: 16),
              decoration: InputDecoration(
                hintText: "Digite sua mensagem...",
                hintStyle: const TextStyle(color: kSubtleTextColor),
                filled: true,
                fillColor: kInputBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: kAccentPurple,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          ScaleTransition(
            scale: _sendButtonAnimation,
            child: FloatingActionButton(
              onPressed: () => _sendMessage(),
              backgroundColor: kAccentPurple,
              elevation: 2,
              mini: true,
              child: const Icon(Icons.send, color: kTextColor, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _sendButtonAnimationController.dispose();
    super.dispose();
  }
}

class MessageBubble extends StatefulWidget {
  final Message message;
  final Function(String reaction) onReaction;

  const MessageBubble({
    super.key,
    required this.message,
    required this.onReaction,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showReactions = false;
  final List<String> _availableReactions = ["👍", "❤️", "😂", "😮", "😢", "🙏"];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.isUser;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = isUser ? kUserMessageBubble : kAiMessageBubble;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(20.0),
      topRight: const Radius.circular(20.0),
      bottomLeft: Radius.circular(isUser ? 20.0 : 4.0),
      bottomRight: Radius.circular(isUser ? 4.0 : 20.0),
    );

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Align(
        alignment: alignment,
        child: GestureDetector(
          onLongPress: () {
            setState(() {
              _showReactions = !_showReactions;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 10.0,
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (widget.message.fileName != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.insert_drive_file_outlined,
                          color: kSubtleTextColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "Arquivo: ${widget.message.fileName}",
                            style: const TextStyle(
                              color: kTextColor,
                              fontStyle: FontStyle.italic,
                              fontSize: 14.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    widget.message.text,
                    style: const TextStyle(color: kTextColor, fontSize: 15.5),
                  ),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.message.reaction != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: Text(
                          widget.message.reaction!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    Text(
                      "${widget.message.timestamp.hour.toString().padLeft(2, "0")}:${widget.message.timestamp.minute.toString().padLeft(2, "0")}",
                      style: const TextStyle(
                        color: kSubtleTextColor,
                        fontSize: 11,
                      ),
                    ),
                    if (isUser) const SizedBox(width: 4),
                    if (isUser)
                      const Icon(
                        Icons.done_all,
                        size: 14,
                        color: kSubtleTextColor,
                      ),
                  ],
                ),
                if (_showReactions)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: kDarkSecondary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 4.0,
                        children:
                            _availableReactions.map((emoji) {
                              return InkWell(
                                onTap: () {
                                  widget.onReaction(emoji);
                                  setState(() => _showReactions = false);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    emoji,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const EnhancedChatApp());
}

class EnhancedChatApp extends StatelessWidget {
  const EnhancedChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat IA Melhorado",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: kDarkPrimary,
        scaffoldBackgroundColor: kDarkPrimary,
        colorScheme: const ColorScheme.dark(
          primary: kAccentPurple,
          secondary: kLighterPurple,
          background: kDarkPrimary,
          surface: kDarkSecondary,
          onPrimary: kTextColor,
          onSecondary: kTextColor,
          onBackground: kTextColor,
          onSurface: kTextColor,
          error: Colors.redAccent,
          onError: kTextColor,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: kTextColor),
          bodyMedium: TextStyle(color: kSubtleTextColor),
          titleLarge: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kInputBackground,
          hintStyle: const TextStyle(color: kSubtleTextColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: kAccentPurple, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
        iconTheme: const IconThemeData(color: kTextColor),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kAccentPurple,
          foregroundColor: kTextColor,
        ),
      ),
      home: const ChatScreen(title: "Chat IA "),
      debugShowCheckedModeBanner: false,
    );
  }
}

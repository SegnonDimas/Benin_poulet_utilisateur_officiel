import 'package:benin_poulet/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/client/chat_client_bloc.dart';
import '../../../widgets/app_text.dart';
import '../../colors/app_colors.dart';

class ChatClientPage extends StatefulWidget {
  final dynamic store; // Store object passed from navigation

  ChatClientPage({super.key, required this.store});

  @override
  State<ChatClientPage> createState() => _ChatClientPageState();
}

class _ChatClientPageState extends State<ChatClientPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context
        .read<ChatClientBloc>()
        .add(LoadChatHistory(storeId: widget.store.id));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.store.imageUrl),
                radius: 20,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      overflow: TextOverflow.visible,
                      text: widget.store.name,
                      fontWeight: FontWeight.bold,
                    ),
                    AppText(
                      overflow: TextOverflow.visible,
                      text: 'En ligne',
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.call),
              onPressed: () {
                // TODO: Implémenter l'appel
              },
            ),
            IconButton(
              icon: Icon(Icons.video_call),
              onPressed: () {
                // TODO: Implémenter l'appel vidéo
              },
            ),
          ],
        ),
        body: BlocBuilder<ChatClientBloc, ChatClientState>(
          builder: (context, state) {
            if (state is ChatClientLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is ChatClientLoaded) {
              return Column(
                children: [
                  // Messages
                  Expanded(
                    child: _buildMessagesList(state.messages),
                  ),

                  // Zone de saisie
                  _buildMessageInput(),
                ],
              );
            }

            if (state is ChatClientError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    AppText(
                      overflow: TextOverflow.visible,
                      text: state.message,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(height: 16),
                    AppButton(
                      onTap: () {
                        context.read<ChatClientBloc>().add(
                              LoadChatHistory(storeId: widget.store.id),
                            );
                      },
                      color: AppColors.primaryColor,
                      child: AppText(
                        overflow: TextOverflow.visible,
                        text: 'Recharger',
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: AppText(
                  overflow: TextOverflow.visible, text: 'Chargement...'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessagesList(List<ChatMessage> messages) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 100,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 24),
            AppText(
              overflow: TextOverflow.visible,
              text: 'Aucun message',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
            SizedBox(height: 12),
            AppText(
              overflow: TextOverflow.visible,
              text: 'Commencez la conversation avec ${widget.store.name}',
              color: Colors.grey.shade500,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      controller: _scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isMe = message.isFromUser;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              backgroundImage: NetworkImage(widget.store.imageUrl),
              radius: 16,
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe
                    ? AppColors.primaryColor
                    : Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    overflow: TextOverflow.visible,
                    text: message.text,
                    color: isMe
                        ? Colors.white
                        : Theme.of(context)
                            .colorScheme
                            .inverseSurface
                            .withOpacity(0.7),
                  ),
                  SizedBox(height: 4),
                  AppText(
                    overflow: TextOverflow.visible,
                    text: message.time,
                    fontSize: 10,
                    color: isMe ? Colors.white : Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 8),
            CircleAvatar(
              //backgroundImage: NetworkImage('https://via.placeholder.com/50'),
              radius: 16,
              //backgroundImage: NetworkImage('https://via.placeholder.com/50'),
              child: Icon(
                Icons.person,
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.4),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Bouton joindre fichier
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: () {
              _showAttachmentOptions();
            },
            color: AppColors.primaryColor,
          ),

          // Champ de saisie
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                //color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Message ...',
                  //showFloatingLabel: false,
                  fillColor: Theme.of(context).colorScheme.inverseSurface,
                  border: InputBorder.none,
                ),
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 5,
              ),
            ),
          ),

          SizedBox(width: 8),

          // Bouton envoyer
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: () {
                _sendMessage();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatClientBloc>().add(
            SendMessage(
              storeId: widget.store.id,
              text: text,
            ),
          );
      _messageController.clear();

      // Faire défiler vers le bas
      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                overflow: TextOverflow.visible,
                text: 'Joindre un fichier',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.camera_alt,
                    label: 'Photo',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implémenter la prise de photo
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.photo_library,
                    label: 'Galerie',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implémenter la sélection depuis la galerie
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.location_on,
                    label: 'Localisation',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implémenter le partage de localisation
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 30,
            ),
          ),
          SizedBox(height: 8),
          AppText(
            overflow: TextOverflow.visible,
            text: label,
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}

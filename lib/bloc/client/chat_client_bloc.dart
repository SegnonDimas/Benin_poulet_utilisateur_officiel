import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Modèles temporaires pour les placeholders
class ChatMessage {
  final String id;
  final String text;
  final String time;
  final bool isFromUser;
  final String? attachmentUrl;
  final String? attachmentType;

  ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.isFromUser,
    this.attachmentUrl,
    this.attachmentType,
  });
}

// Événements
abstract class ChatClientEvent extends Equatable {
  const ChatClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatHistory extends ChatClientEvent {
  final String storeId;

  const LoadChatHistory({required this.storeId});

  @override
  List<Object?> get props => [storeId];
}

class SendMessage extends ChatClientEvent {
  final String storeId;
  final String text;
  final String? attachmentUrl;
  final String? attachmentType;

  const SendMessage({
    required this.storeId,
    required this.text,
    this.attachmentUrl,
    this.attachmentType,
  });

  @override
  List<Object?> get props => [storeId, text, attachmentUrl, attachmentType];
}

class MarkAsRead extends ChatClientEvent {
  final String storeId;

  const MarkAsRead({required this.storeId});

  @override
  List<Object?> get props => [storeId];
}

// États
abstract class ChatClientState extends Equatable {
  const ChatClientState();

  @override
  List<Object?> get props => [];
}

class ChatClientInitial extends ChatClientState {}

class ChatClientLoading extends ChatClientState {}

class ChatClientLoaded extends ChatClientState {
  final List<ChatMessage> messages;
  final bool isTyping;

  const ChatClientLoaded({
    required this.messages,
    this.isTyping = false,
  });

  @override
  List<Object?> get props => [messages, isTyping];

  ChatClientLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
  }) {
    return ChatClientLoaded(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class ChatClientError extends ChatClientState {
  final String message;

  const ChatClientError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class ChatClientBloc extends Bloc<ChatClientEvent, ChatClientState> {
  ChatClientBloc() : super(ChatClientInitial()) {
    on<LoadChatHistory>(_onLoadChatHistory);
    on<SendMessage>(_onSendMessage);
    on<MarkAsRead>(_onMarkAsRead);
  }

  List<ChatMessage> _messages = [];

  Future<void> _onLoadChatHistory(
    LoadChatHistory event,
    Emitter<ChatClientState> emit,
  ) async {
    emit(ChatClientLoading());
    
    try {
      // Simulation d'un délai de chargement
      await Future.delayed(const Duration(seconds: 1));
      
      // Données temporaires des messages
      _messages = [
        ChatMessage(
          id: '1',
          text: 'Bonjour ! Comment puis-je vous aider aujourd\'hui ?',
          time: '10:30',
          isFromUser: false,
        ),
        ChatMessage(
          id: '2',
          text: 'Bonjour ! J\'aimerais commander des poulets frais.',
          time: '10:32',
          isFromUser: true,
        ),
        ChatMessage(
          id: '3',
          text: 'Parfait ! Nous avons des poulets de chair frais disponibles. Combien en voulez-vous ?',
          time: '10:33',
          isFromUser: false,
        ),
        ChatMessage(
          id: '4',
          text: 'Je voudrais 2 poulets de 1.5kg chacun.',
          time: '10:35',
          isFromUser: true,
        ),
        ChatMessage(
          id: '5',
          text: 'Excellent choix ! Le prix est de 2500 FCFA par poulet. Voulez-vous une livraison ?',
          time: '10:36',
          isFromUser: false,
        ),
      ];
      
      emit(ChatClientLoaded(messages: _messages));
    } catch (e) {
      emit(ChatClientError(message: 'Erreur lors du chargement des messages'));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatClientState> emit,
  ) async {
    if (state is ChatClientLoaded) {
      final currentState = state as ChatClientLoaded;
      
      // Créer un nouveau message
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: event.text,
        time: _getCurrentTime(),
        isFromUser: true,
        attachmentUrl: event.attachmentUrl,
        attachmentType: event.attachmentType,
      );
      
      // Ajouter le message à la liste
      _messages.add(newMessage);
      
      emit(currentState.copyWith(messages: _messages));
      
      // Simuler une réponse automatique après 2 secondes
      await Future.delayed(const Duration(seconds: 2));
      
      final autoReply = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _getAutoReply(event.text),
        time: _getCurrentTime(),
        isFromUser: false,
      );
      
      _messages.add(autoReply);
      
      emit(currentState.copyWith(messages: _messages));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<ChatClientState> emit,
  ) async {
    // TODO: Implémenter le marquage comme lu
    print('Messages marqués comme lus pour la boutique: ${event.storeId}');
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  String _getAutoReply(String userMessage) {
    final message = userMessage.toLowerCase();
    
    if (message.contains('bonjour') || message.contains('salut')) {
      return 'Bonjour ! Comment puis-je vous aider ?';
    } else if (message.contains('prix') || message.contains('coût')) {
      return 'Nos prix varient selon le produit. Pouvez-vous me préciser ce que vous cherchez ?';
    } else if (message.contains('livraison') || message.contains('livrer')) {
      return 'Nous proposons la livraison à domicile et en point relais. Quel mode préférez-vous ?';
    } else if (message.contains('disponible') || message.contains('stock')) {
      return 'Je vais vérifier la disponibilité pour vous. Un instant s\'il vous plaît...';
    } else if (message.contains('commande') || message.contains('commander')) {
      return 'Parfait ! Je vais vous aider avec votre commande. Que souhaitez-vous commander ?';
    } else {
      return 'Merci pour votre message ! Je vais vous répondre dans les plus brefs délais.';
    }
  }
}

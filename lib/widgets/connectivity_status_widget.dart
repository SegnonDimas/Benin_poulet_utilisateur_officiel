import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:benin_poulet/services/cache_manager.dart';
import 'package:benin_poulet/widgets/app_text.dart';

class ConnectivityStatusWidget extends StatefulWidget {
  final Widget child;
  final bool showOfflineBanner;

  const ConnectivityStatusWidget({
    super.key,
    required this.child,
    this.showOfflineBanner = true,
  });

  @override
  State<ConnectivityStatusWidget> createState() => _ConnectivityStatusWidgetState();
}

class _ConnectivityStatusWidgetState extends State<ConnectivityStatusWidget> {
  bool _isOnline = true;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _listenToConnectivityChanges();
  }

  Future<void> _checkConnectivity() async {
    final isOnline = await CacheManager.isOnline();
    if (mounted) {
      setState(() {
        _isOnline = isOnline;
      });
    }
  }

  void _listenToConnectivityChanges() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (mounted) {
        setState(() {
          _isOnline = results.isNotEmpty && results.first != ConnectivityResult.none;
        });
        
        // Si on revient en ligne, synchroniser les données
        if (_isOnline) {
          _syncData();
        }
      }
    });
  }

  Future<void> _syncData() async {
    if (!_isOnline) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      // Synchroniser les données en arrière-plan
      await Future.delayed(const Duration(milliseconds: 500));
      // Ici on pourrait appeler SyncService.syncData() si nécessaire
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showOfflineBanner && !_isOnline)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildOfflineBanner(),
          ),
        if (_isSyncing)
          Positioned(
            top: widget.showOfflineBanner && !_isOnline ? 60 : 0,
            left: 0,
            right: 0,
            child: _buildSyncingBanner(),
          ),
      ],
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.orange,
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText(
              text: 'Mode hors ligne - Données locales disponibles',
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          IconButton(
            onPressed: _checkConnectivity,
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
              size: 16,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncingBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.blue,
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          AppText(
            text: 'Synchronisation en cours...',
            color: Colors.white,
            fontSize: 12,
          ),
        ],
      ),
    );
  }
}

class OfflineIndicator extends StatelessWidget {
  final bool isOnline;
  final VoidCallback? onRetry;

  const OfflineIndicator({
    super.key,
    required this.isOnline,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isOnline) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.wifi_off,
                color: Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppText(
                  text: 'Connexion internet indisponible',
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppText(
            text: 'Certaines fonctionnalités peuvent être limitées. Les données affichées proviennent du cache local.',
            fontSize: 12,
            color: Colors.grey[600],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: const AppText(text: 'Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CacheStatusIndicator extends StatelessWidget {
  final bool hasCachedData;
  final bool isCacheValid;

  const CacheStatusIndicator({
    super.key,
    required this.hasCachedData,
    required this.isCacheValid,
  });

  @override
  Widget build(BuildContext context) {
    if (hasCachedData && isCacheValid) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            hasCachedData ? Icons.cached : Icons.cloud_off,
            color: Colors.blue,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText(
              text: hasCachedData 
                  ? 'Données en cache (peuvent être obsolètes)'
                  : 'Aucune donnée en cache disponible',
              fontSize: 12,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }
}

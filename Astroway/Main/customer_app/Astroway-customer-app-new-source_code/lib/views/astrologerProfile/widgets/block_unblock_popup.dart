import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockUnblockDialog {
  static void showBlock(
    BuildContext context, {
    required String astrologerId,
    required String name,
    required String imageUrl,
    required Future<void> Function(String reason, List<String> tags) onSubmit,
  }) {
    Get.dialog(
      _BlockDialog(
        name: name,
        imageUrl: imageUrl,
        onSubmit: (reason, tags) async {
          Get.back();
          await onSubmit(reason, tags);
        },
      ),
      barrierDismissible: true,
    );
  }

  static void showUnblock(
    BuildContext context, {
    required String name,
    required String imageUrl,
    required Future<void> Function() onConfirm,
  }) {
    Get.dialog(
      _UnblockDialog(
        name: name,
        imageUrl: imageUrl,
        onConfirm: () async {
          Get.back();
          await onConfirm();
        },
      ),
      barrierDismissible: true,
    );
  }
}

// ─────────────────────────────────────────────
//  BLOCK DIALOG
// ─────────────────────────────────────────────

class _BlockDialog extends StatefulWidget {
  final String name;
  final String imageUrl;
  final Future<void> Function(String reason, List<String> tags) onSubmit;

  const _BlockDialog({
    required this.name,
    required this.imageUrl,
    required this.onSubmit,
  });

  @override
  State<_BlockDialog> createState() => _BlockDialogState();
}

class _BlockDialogState extends State<_BlockDialog> {
  final TextEditingController _reasonController = TextEditingController();
  final List<String> _allTags = [
    'Inappropriate behavior',
    'Spam',
    'Fake readings',
    'Harassment',
    'Other',
  ];
  final Set<String> _selectedTags = {};
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200, width: 0.5),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              _buildAvatar(context),
              _buildWarningBanner(context),
              _buildReasonTags(context),
              _buildTextField(context),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Report & Block',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          GestureDetector(
            onTap: Get.back,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300, width: 0.5),
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF0997B), Color(0xFFD85A30)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: 33,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      width: 66,
                      height: 66,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          const CircularProgressIndicator(strokeWidth: 2),
                      errorWidget: (_, __, ___) => const Icon(Icons.person,
                          size: 32, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE24B4A),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            'This user will no longer be able to contact you',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFCEBEB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF7C1C1), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why are you blocking?',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFA32D2D),
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              'Your reason helps us improve the platform.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFA32D2D),
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonTags(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: _allTags.map((tag) {
          final selected = _selectedTags.contains(tag);
          return GestureDetector(
            onTap: () => setState(() {
              if (selected) {
                _selectedTags.remove(tag);
              } else {
                _selectedTags.add(tag);
              }
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color:
                    selected ? const Color(0xFFFCEBEB) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      selected ? const Color(0xFFF7C1C1) : Colors.grey.shade300,
                  width: 0.5,
                ),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      selected ? const Color(0xFFA32D2D) : Colors.grey.shade600,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        controller: _reasonController,
        maxLines: 3,
        minLines: 3,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Describe your experience...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await widget.onSubmit(
                  _reasonController.text.trim(),
                  _selectedTags.toList(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE24B4A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Block & Report',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You can unblock from Settings > Blocked accounts',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  UNBLOCK DIALOG
// ─────────────────────────────────────────────

class _UnblockDialog extends StatefulWidget {
  final String name;
  final String imageUrl;
  final Future<void> Function() onConfirm;

  const _UnblockDialog({
    required this.name,
    required this.imageUrl,
    required this.onConfirm,
  });

  @override
  State<_UnblockDialog> createState() => _UnblockDialogState();
}

class _UnblockDialogState extends State<_UnblockDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200, width: 0.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            _buildAvatar(context),
            _buildInfoCard(context),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Unblock Astrologer',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          GestureDetector(
            onTap: Get.back,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300, width: 0.5),
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Stack(
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
                child: Container(
                  width: 72,
                  height: 72,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade400,
                  ),
                  child: CircleAvatar(
                    radius: 33,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        width: 66,
                        height: 66,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const Icon(Icons.person,
                            size: 32, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.block, size: 10, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Currently blocked',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 0.5),
        ),
        child: Text.rich(
          TextSpan(
            style: TextStyle(
                fontSize: 13, color: Colors.grey.shade600, height: 1.6),
            children: [
              const TextSpan(text: 'Unblocking will allow '),
              TextSpan(
                text: widget.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              const TextSpan(
                  text: ' to appear in search results and contact you again.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() => _isLoading = true);
                      await widget.onConfirm();
                      setState(() => _isLoading = false);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEAF3DE),
                foregroundColor: const Color(0xFF3B6D11),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFF639922), width: 0.5),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        color: Color(0xFF3B6D11),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Yes, unblock',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: Get.back,
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade500,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300, width: 0.5),
                ),
              ),
              child: const Text('Cancel', style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}

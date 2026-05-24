import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme.dart';
import '../models/request.dart';
import '../utils/phone_mask.dart';

/// Request card widget – matches web design
class RequestCard extends StatelessWidget {
  final RideRequest request;
  final bool isLoggedIn;

  const RequestCard({
    super.key,
    required this.request,
    this.isLoggedIn = false,
  });

  void _callDriver(BuildContext context) async {
    if (!isLoggedIn) return;
    final phone = request.phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _badge(String label, {Color bgColor = const Color(0xFFE9FBF0), Color textColor = const Color(0xFF00B14F)}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusLabel = request.status == 'new'
        ? '⚡ Mới'
        : request.status == 'done'
            ? '✅ Xong'
            : '🕐 Sắp đi';
    final statusBg = request.status == 'new'
        ? const Color(0xFFE9FBF0)
        : request.status == 'done'
            ? const Color(0xFFEEF2FF)
            : const Color(0xFFE9FBF0);
    final statusColor = request.status == 'new'
        ? AppColors.primary
        : request.status == 'done'
            ? const Color(0xFF6366F1)
            : AppColors.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Top row: badge | name | badge ──
          Row(
            children: [
              _badge('⚡ Mới'),
              Expanded(
                child: Text(
                  request.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _badge(statusLabel, bgColor: statusBg, textColor: statusColor),
            ],
          ),
          const SizedBox(height: 10),

          // ── Phone ──
          Row(
            children: [
              Icon(Icons.phone_iphone_rounded, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                'Số điện thoại khách hàng: ${maskPhone(request.phone, isLoggedIn: isLoggedIn)}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Route ──
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 2),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(builder: (ctx, constraints) {
                        final dashCount = (constraints.maxHeight / 5).floor();
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(dashCount, (_) => Container(
                            width: 1,
                            height: 3,
                            color: Colors.grey.shade400,
                          )),
                        );
                      }),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.startPoint,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        request.endPoint,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Note ──
          if (request.note != null && request.note!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 13, color: AppColors.textMuted),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    request.note!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),

          // ── Price ──
          Row(
            children: [
              const Text(
                'Giá: ',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                request.formattedPrice,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Call button ──
          ElevatedButton.icon(
            onPressed: () => _callDriver(context),
            icon: const Icon(Icons.phone_rounded, size: 18),
            label: const Text(
              'GỌI TÀI XẾ NGAY',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 0.5),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

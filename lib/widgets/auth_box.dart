import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Auth promotion box – matches web hero banner
class AuthBox extends StatelessWidget {
  final bool isRegistered;
  final String? status;
  final VoidCallback onLoginPressed;
  final VoidCallback? onCheckStatus;
  final VoidCallback? onReset;

  const AuthBox({
    super.key,
    this.isRegistered = false,
    this.status,
    required this.onLoginPressed,
    this.onCheckStatus,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final String title = isRegistered
        ? (status == 'approved' ? '✅ Tài khoản đã được duyệt' : '⏳ Đang chờ phê duyệt')
        : 'Tham gia nhóm tài xế';
    final String subtitle = isRegistered
        ? (status == 'approved'
            ? 'Chào mừng bạn! Hãy đăng nhập để bắt đầu'
            : 'Tài khoản của bạn đang được admin xem xét')
        : 'Đăng ký để có thể liên hệ và đón cuốc';

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background image ──
            Image.asset(
              'assets/images/banner.png',
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
              errorBuilder: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00B14F), Color(0xFF0A8F43)],
                  ),
                ),
              ),
            ),

            // ── Content left side ──
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.52,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status helper row
                  if (isRegistered)
                    Row(
                      children: [
                        if (status != 'approved' && onCheckStatus != null)
                          GestureDetector(
                            onTap: onCheckStatus,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.refresh_rounded, color: Colors.white, size: 12),
                                  SizedBox(width: 3),
                                  Text('Cập nhật', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        if (onReset != null) ...[
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: onReset,
                            child: const Icon(Icons.delete_forever_rounded, color: Colors.white70, size: 16),
                          ),
                        ],
                      ],
                    ),
                  if (isRegistered) const SizedBox(height: 4),
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.2,
                      shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtitle
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Buttons row
                  Row(
                    children: [
                      // Đăng ký thành viên (outlined)
                      if (!isRegistered)
                        Flexible(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 13),
                                  SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      'Đăng ký thành viên',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (!isRegistered) const SizedBox(width: 6),
                      // Đăng nhập (filled white)
                      GestureDetector(
                        onTap: onLoginPressed,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

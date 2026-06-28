import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String? selectedMethod;
  final ValueChanged<String> onSelected;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PaymentOptionCard(
            icon: Icons.payments_outlined,
            label: 'Cash',
            subtitle: 'Pay at branch',
            isSelected: selectedMethod == 'CASH',
            onTap: () => onSelected('CASH'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PaymentOptionCard(
            icon: Icons.credit_card_rounded,
            label: 'Online',
            subtitle: 'Pay with Stripe',
            isSelected: selectedMethod == 'ONLINE',
            onTap: () => onSelected('ONLINE'),
          ),
        ),
      ],
    );
  }
}

class _PaymentOptionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_PaymentOptionCard> createState() => _PaymentOptionCardState();
}

class _PaymentOptionCardState extends State<_PaymentOptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.teal.withValues(alpha: 0.06)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.teal
                  : Colors.grey.shade200,
              width: widget.isSelected ? 1.8 : 1.2,
            ),
            boxShadow: [
              if (widget.isSelected)
                BoxShadow(
                  color: AppColors.teal.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? AppColors.teal.withValues(alpha: 0.12)
                      : AppColors.tealLight.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: widget.isSelected
                      ? AppColors.teal
                      : AppColors.tealMuted,
                  size: 24,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      widget.isSelected ? FontWeight.bold : FontWeight.w600,
                  color: widget.isSelected
                      ? AppColors.teal
                      : AppColors.blackColor,
                  fontFamily: 'Inter Tight',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                  fontFamily: 'Inter Tight',
                ),
              ),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected ? AppColors.teal : Colors.transparent,
                  border: Border.all(
                    color: widget.isSelected
                        ? AppColors.teal
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: widget.isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

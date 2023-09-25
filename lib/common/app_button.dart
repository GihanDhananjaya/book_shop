
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';


class AppButton extends StatefulWidget {
  final String buttonText;
  final Function onTapButton;
  final double width;
  final Widget? prefixIcon;

  final Color buttonColor;
  final Color textColor;
  final Color? borderColor;

  AppButton(
      {required this.buttonText,
        required this.onTapButton,
        this.width = 0,
        this.prefixIcon,
        this.borderColor,
        this.buttonColor = AppColors.colorPrimary,
        this.textColor = AppColors.fontColorWhite,
      });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  Color _buttonColor = AppColors.colorPrimary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: MouseRegion(
        onEnter: (e) {
          setState(() {
            _buttonColor = AppColors.colorHover;
          });
        },
        onExit: (e) {
          setState(() {
            _buttonColor = AppColors.colorPrimary;
          });
        },
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            width: widget.width == 0 ? double.infinity : widget.width,
            decoration: BoxDecoration(
              border: Border.all(
                  color: widget.borderColor ?? AppColors.colorTransparent),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: AppColors.colorPrimary
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.prefixIcon ?? const SizedBox.shrink(),
                  widget.prefixIcon != null
                      ? const SizedBox(
                    width: 5,
                  )
                      : const SizedBox.shrink(),
                  Text(
                    widget.buttonText,
                    style: TextStyle(
                        color: AppColors.fontColorDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onTap: () {

          if (widget.onTapButton != null) {
            widget.onTapButton();
          }

      },
    );
  }
}

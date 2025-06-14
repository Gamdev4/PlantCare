import 'package:flutter/material.dart';
import 'package:namer_app/l10n/app_localizations.dart';

class WateringButton extends StatefulWidget{
  final VoidCallback onPressed;
  const WateringButton({super.key, required this.onPressed});

  @override
  State<WateringButton> createState() => _WateringButtonState();
}

class _WateringButtonState extends State<WateringButton> {

  // Variables
  bool _isPressing = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {

    // Watering button
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressing = true),
        onTapUp: (_) => setState(() => _isPressing = false),
        onTapCancel: () => setState(() => _isPressing = false),
        onTap: () {
          setState(() => _isPressing = true);
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) setState(() => _isPressing = false);
          });
          setState(() => _isPressed = true);
          Future.delayed(const Duration(milliseconds: 2000), () {
            if (mounted) setState(() => _isPressed = false);
          });
          widget.onPressed();
        },

        // Animated button
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isPressing || _isPressed ?Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: _isPressing ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Text(
                _isPressed ? AppLocalizations.of(context)!.wateringPlants : AppLocalizations.of(context)!.wateringButtonText,),
            ),
          ),
      ),
    ),
    );


  }
}
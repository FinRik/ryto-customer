import 'package:flutter/material.dart';

class TripRouteCard extends StatelessWidget {
  final String origin;
  final String destination;
  final VoidCallback? onEdit;

  const TripRouteCard({
    super.key,
    required this.origin,
    required this.destination,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Leaving From?"),
              const SizedBox(height: 8),
              _buildLocationField(context, origin),
            ],
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Going to"),
              const SizedBox(height: 8),
              _buildLocationField(context, destination),
            ],
          ),
        ),
        const SizedBox(width: 7),
        if (onEdit != null) ...[
          FloatingActionButton(
            mini: false,
            elevation: 0,
            shape: const CircleBorder(),
            backgroundColor: Colors.blue,
            onPressed: onEdit,
            child: const Icon(Icons.edit, color: Colors.white),
          ),
        ]
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildLocationField(BuildContext context, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
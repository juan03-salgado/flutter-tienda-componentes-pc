import 'package:flutter/material.dart';

class HomeAdminCard extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final VoidCallback onTap;
  final Color color;

  const HomeAdminCard({
    super.key,
    required this.titulo,
    required this.icono,
    required this.onTap,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(16),
          height: 100,
          child: Row(
            children: [
              Icon(icono, size: 40, color: color),
              const SizedBox(width: 15),
              Expanded(
                child: Text(titulo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16)
            ],
          ),
        ),
      ),
    );
  }

}
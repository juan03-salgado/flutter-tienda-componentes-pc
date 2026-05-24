import 'package:flutter/material.dart';

class ResumenCard extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final String valor;
  final Color color;

  const ResumenCard({
    super.key,
    required this.titulo,
    required this.icono,
    required this.valor,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Icon(icono, color: color, size: 28),
              const SizedBox(height: 5),
              Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(valor, style: const TextStyle(fontSize: 16))
            ],
          ),
        ),
      ),
    );
  }
}
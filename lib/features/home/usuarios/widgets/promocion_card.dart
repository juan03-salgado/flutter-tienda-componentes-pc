import 'package:flutter/material.dart';

class PromocionCard extends StatelessWidget {
  final String descripcion;
  final String imagenUrl;

  const PromocionCard({
    super.key, 
    required this.descripcion,
    required this.imagenUrl
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(image: AssetImage(imagenUrl), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.35)
        ),
      child: Center(
        child: Text(
          descripcion,
          textAlign: TextAlign.center, 
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      ),
    );
  }
}
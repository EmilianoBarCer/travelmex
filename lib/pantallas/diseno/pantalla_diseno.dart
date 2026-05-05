import 'package:flutter/material.dart';

class PantallaDiseno extends StatefulWidget {
  const PantallaDiseno({Key? key}) : super(key: key);

  @override
  State<PantallaDiseno> createState() => _PantallaDisenoState();
}

class _PantallaDisenoState extends State<PantallaDiseno> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Diseño - TravelMex'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // COLORES
              _seccionColores(context),
              const SizedBox(height: 32),

              // TIPOGRAFÍA
              _seccionTipografia(context),
              const SizedBox(height: 32),

              // BOTONES
              _seccionBotones(context),
              const SizedBox(height: 32),

              // TARJETAS
              _seccionTarjetas(context),
              const SizedBox(height: 32),

              // ICONOS
              _seccionIconos(context),
              const SizedBox(height: 32),

              // FORMULARIOS
              _seccionFormularios(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seccionColores(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paleta de Colores',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _colorItem('Primario', Colors.blue.shade700),
        _colorItem('Secundario', Colors.amber),
        _colorItem('Error', Colors.red),
        _colorItem('Success', Colors.green),
        _colorItem('Warning', Colors.orange),
        _colorItem('Background', Colors.grey.shade100),
      ],
    );
  }

  Widget _colorItem(String nombre, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '#${color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seccionTipografia(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipografía',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Headline Large',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          'Headline Small',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          'Title Large',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          'Body Large',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          'Body Medium',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          'Body Small',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _seccionBotones(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Botones',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Botón Elevado'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Botón Outline'),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {},
          child: const Text('Botón Texto'),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.star),
          label: const Text('Botón con Icono'),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _seccionTarjetas(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tarjetas',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tarjeta Simple',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Esta es una tarjeta de componente estándar con contenido de ejemplo.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.blue.shade100,
                child: const Center(
                  child: Icon(Icons.image, size: 64),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tarjeta con Imagen',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tarjeta con imagen principal y contenido debajo.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _seccionIconos(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Iconos',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _iconoItem(Icons.location_on, 'Ubicación'),
            _iconoItem(Icons.star, 'Rating'),
            _iconoItem(Icons.map, 'Mapa'),
            _iconoItem(Icons.rate_review, 'Reseña'),
            _iconoItem(Icons.person, 'Perfil'),
            _iconoItem(Icons.logout, 'Salir'),
            _iconoItem(Icons.edit, 'Editar'),
            _iconoItem(Icons.delete, 'Eliminar'),
          ],
        ),
      ],
    );
  }

  Widget _iconoItem(IconData icono, String nombre) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(icono, color: Colors.blue.shade700),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          nombre,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _seccionFormularios(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Componentes de Formulario',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            hintText: 'Campo de texto',
            prefixIcon: const Icon(Icons.text_fields),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            hintText: 'Campo de búsqueda',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Área de texto',
            prefixIcon: const Icon(Icons.description),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

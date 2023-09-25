import 'package:flutter/material.dart';
import 'package:socket_cliente/views/chat_screen.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final mensaje = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            name: _usernameController.text,
            ip: _ipController.text,
            port: _portController.text,
          ),
        ),
      );

      if (mensaje != null) {
        mostrarSnackBar(context, mensaje);
      }
    }
  }

  void mostrarSnackBar(BuildContext context, String mensaje) {
    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: const Duration(seconds: 5), // Duración del SnackBar
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Iniciar Chat",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration:
                    const InputDecoration(labelText: 'Nombre de usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre de usuario.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ipController,
                decoration: const InputDecoration(labelText: 'Dirección IP'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una dirección IP.';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _portController,
                decoration: const InputDecoration(labelText: 'Puerto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un puerto.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, ingresa un valor numérico para el puerto.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: _submitForm,
        child: const Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }
}

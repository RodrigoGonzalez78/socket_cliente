import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_cliente/models/mensaje.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key, required this.name, required this.ip, required this.port});
  final String name;
  final String ip;
  final String port;
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatBubble> _messages = [];
  late Socket _socket;

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  void _connectToServer() async {
    try {
      _socket = await Socket.connect(widget.ip, int.parse(widget.port));
      _socket.listen(
        (data) {
          String message = utf8.decode(data);
          // Deserializar el mensaje JSON a un objeto Mensaje
          Mensaje receivedMessage = Mensaje.fromJson(jsonDecode(message));

          setState(() {
            _messages.add(ChatBubble(
                nombre: receivedMessage.nombreCliente,
                mensaje: receivedMessage.mensaje,
                hora: receivedMessage.fechaHora));
          });
        },
        onError: (error) {
          Navigator.pop(context, 'Error: $error');
        },
        onDone: () {
          _socket.destroy();
          Navigator.pop(context, 'Conexion cerrada por el servidor.');
        },
      );
    } catch (e) {
      Navigator.pop(context, 'Error al conectar al servidor: $e');
    }
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      // Crear un objeto Mensaje y convertirlo a JSON
      Mensaje mensaje = Mensaje(
          nombreCliente: widget.name,
          mensaje: _textController.text,
          fechaHora: "${DateTime.now().hour}:${DateTime.now().minute}");

      String mensajeJson = jsonEncode(mensaje.toJson());

      // Enviar el mensaje JSON
      _socket.write(mensajeJson);

      setState(() {
        _messages.add(ChatBubble(
            nombre: mensaje.nombreCliente,
            mensaje: mensaje.mensaje,
            hora: mensaje.fechaHora));
      });
      _textController.clear();
    }
  }

  @override
  void dispose() {
    _socket.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Socket Chat',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String nombre;
  final String mensaje;
  final String hora;

  const ChatBubble({
    super.key,
    required this.nombre,
    required this.mensaje,
    required this.hora,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$nombre - $hora',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            mensaje,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

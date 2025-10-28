import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:gerador_de_senha/widgets/password_result_widget.dart';
import 'package:gerador_de_senha/widgets/protected_route.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  int _passwordLength = 12;
  bool _includeLowercase = true;
  bool _includeUppercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  bool _showOptions = false;
  bool _isGenerating = false;
  String _generatedPassword = '';

  // URL da API externa
  static const String _apiUrl =
      'https://safekey-api-a1bd9aa97953.herokuapp.com/generate';

  Future<String> _generatePasswordFromAPI() async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'length': _passwordLength,
          'include_lowercase': _includeLowercase,
          'include_uppercase': _includeUppercase,
          'include_numbers': _includeNumbers,
          'include_symbols': _includeSymbols,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['password'] ?? '';
      } else {
        throw Exception('Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback para geração local em caso de erro na API
      return _generatePasswordLocal();
    }
  }

  String _generatePasswordLocal() {
    String chars = '';
    if (_includeLowercase) chars += 'abcdefghijklmnopqrstuvwxyz';
    if (_includeUppercase) chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (_includeNumbers) chars += '0123456789';
    if (_includeSymbols) chars += '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    if (chars.isEmpty) return '';

    final rnd = DateTime.now().millisecondsSinceEpoch;
    return List.generate(
      _passwordLength,
      (index) => chars[(rnd + index) % chars.length],
    ).join();
  }

  Future<void> _savePassword() async {
    if (_generatedPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gere uma senha primeiro!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Mostra dialog para pedir o nome da senha
    final name = await _showSaveDialog();
    if (name == null || name.isEmpty) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário não autenticado!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('passwords')
          .add({
            'name': name,
            'password': _generatedPassword,
            'createdAt': FieldValue.serverTimestamp(),
          });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha salva com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> _showSaveDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A3E),
        title: const Text(
          'Salvar senha',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Nome da senha',
            hintText: 'Ex: Senha do Wifi',
            labelStyle: TextStyle(color: Colors.blue),
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _generatePassword() async {
    setState(() => _isGenerating = true);

    try {
      final password = await _generatePasswordFromAPI();
      setState(() {
        _generatedPassword = password;
        _passwordController.text = password;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar senha: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProtectedRoute(
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: const Text('Gerador de Senhas'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF2A2A3E),
                    title: const Text(
                      'Informações do App',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      'Gerador de Senhas Seguro\n\nVersão 1.0.0\n\nDesenvolvido com Flutter e Firebase',
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Fechar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Widget de resultado da senha
              PasswordResultWidget(
                password: _generatedPassword,
                onRegenerate: _generatePassword,
              ),

              const SizedBox(height: 20),

              // Link para mostrar/ocultar opções
              GestureDetector(
                onTap: () {
                  setState(() => _showOptions = !_showOptions);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _showOptions ? 'Ocultar opções' : 'Mostrar opções',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _showOptions
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),

              // Opções de configuração (com animação)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _showOptions ? null : 0,
                child: _showOptions
                    ? _buildOptionsPanel()
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 30),

              // Botão gerar senha
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _generatePassword,
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.auto_fix_high),
                  label: Text(
                    _isGenerating ? 'Gerando...' : 'Gerar Senha',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _savePassword,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.save, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildOptionsPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Controle de tamanho
          Text(
            'Tamanho da senha: $_passwordLength',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Slider(
            value: _passwordLength.toDouble(),
            min: 4,
            max: 50,
            divisions: 46,
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            onChanged: (value) {
              setState(() => _passwordLength = value.round());
            },
          ),

          const SizedBox(height: 20),

          // Opções de caracteres
          const Text(
            'Tipos de caracteres:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          _buildToggleOption(
            'Incluir letras minúsculas',
            _includeLowercase,
            (value) => setState(() => _includeLowercase = value!),
          ),

          _buildToggleOption(
            'Incluir letras maiúsculas',
            _includeUppercase,
            (value) => setState(() => _includeUppercase = value!),
          ),

          _buildToggleOption(
            'Incluir números',
            _includeNumbers,
            (value) => setState(() => _includeNumbers = value!),
          ),

          _buildToggleOption(
            'Incluir símbolos',
            _includeSymbols,
            (value) => setState(() => _includeSymbols = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Switch(value: value, onChanged: onChanged, activeColor: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

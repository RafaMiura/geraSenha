import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordResultWidget extends StatefulWidget {
  final String password;
  final VoidCallback? onCopy;
  final VoidCallback? onRegenerate;

  const PasswordResultWidget({
    super.key,
    required this.password,
    this.onCopy,
    this.onRegenerate,
  });

  @override
  State<PasswordResultWidget> createState() => _PasswordResultWidgetState();
}

class _PasswordResultWidgetState extends State<PasswordResultWidget> {
  bool _isPasswordVisible = false;
  bool _isCopied = false;

  Future<void> _copyToClipboard() async {
    if (widget.password.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: widget.password));
      setState(() {
        _isCopied = true;
      });

      // Mostra feedback visual
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha copiada para a área de transferência!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );

      // Reset do estado após 2 segundos
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isCopied = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isCopied ? Colors.green : Colors.grey,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Senha Gerada',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Text(
              widget.password.isEmpty
                  ? 'Senha não informada'
                  : _isPasswordVisible
                  ? widget.password
                  : '•' * widget.password.length,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'monospace',
                color: widget.password.isEmpty ? Colors.grey : Colors.white,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: widget.password.isNotEmpty
                      ? _copyToClipboard
                      : null,
                  icon: Icon(
                    _isCopied ? Icons.check : Icons.copy,
                    color: _isCopied ? Colors.green : Colors.white,
                  ),
                  label: Text(
                    _isCopied ? 'Copiado!' : 'Copiar',
                    style: TextStyle(
                      color: _isCopied ? Colors.green : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCopied
                        ? Colors.green.withOpacity(0.2)
                        : Colors.blue,
                    foregroundColor: _isCopied ? Colors.green : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (widget.onRegenerate != null)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.onRegenerate,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text(
                      'Regenerar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

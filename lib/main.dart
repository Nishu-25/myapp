import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double? _operand1;
  String? _operator;
  bool _justEvaluated = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _expression = '';
        _operand1 = null;
        _operator = null;
        _justEvaluated = false;
      } else if (value == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
        _justEvaluated = false;
      } else if (value == '+' || value == '−' || value == '×' || value == '÷') {
        _operand1 = double.tryParse(_display);
        _operator = value;
        _expression = '${_formatResult(_operand1!)} $value';
        _justEvaluated = false;
        // Prepare for next operand
        _display = '0';
      } else if (value == '=') {
        if (_operand1 != null && _operator != null) {
          final double? operand2 = double.tryParse(_display);
          if (operand2 == null) return;
          _expression = '${_formatResult(_operand1!)} $_operator ${_formatResult(operand2)} =';
          double result;
          switch (_operator) {
            case '+':
              result = _operand1! + operand2;
              break;
            case '−':
              result = _operand1! - operand2;
              break;
            case '×':
              result = _operand1! * operand2;
              break;
            case '÷':
              if (operand2 == 0) {
                _display = 'Error';
                _operand1 = null;
                _operator = null;
                _justEvaluated = true;
                return;
              }
              result = _operand1! / operand2;
              break;
            default:
              return;
          }
          _display = _formatResult(result);
          _operand1 = null;
          _operator = null;
          _justEvaluated = true;
        }
      } else if (value == '.') {
        if (_justEvaluated) {
          _display = '0.';
          _justEvaluated = false;
          return;
        }
        if (!_display.contains('.')) {
          _display = '$_display.';
        }
      } else {
        // Digit
        if (_justEvaluated) {
          _display = value;
          _justEvaluated = false;
        } else if (_display == '0') {
          _display = value;
        } else {
          if (_display.length < 15) {
            _display = '$_display$value';
          }
        }
      }
    });
  }

  String _formatResult(double value) {
    if (value == value.truncate()) {
      return value.truncate().toString();
    }
    // Limit decimal places to 8
    String result = value.toStringAsFixed(8);
    // Trim trailing zeros
    result = result.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    return result;
  }

  Widget _buildButton(String label, {Color? bgColor, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Material(
          color: bgColor ?? const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _onButtonPressed(label),
            child: SizedBox.expand(
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: textColor ?? Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color operatorColor = Color(0xFFFF9F0A);
    const Color topButtonColor = Color(0xFF3A3A3C);
    const Color digitColor = Color(0xFF2C2C2E);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Display
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_expression.isNotEmpty)
                      Text(
                        _expression,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _display,
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Button grid
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  children: [
                    Expanded(child: Row(children: [
                      _buildButton('C', bgColor: topButtonColor, textColor: Colors.white),
                      _buildButton('⌫', bgColor: topButtonColor, textColor: Colors.white),
                      _buildButton('%', bgColor: topButtonColor, textColor: Colors.white),
                      _buildButton('÷', bgColor: operatorColor),
                    ])),
                    Expanded(child: Row(children: [
                      _buildButton('7', bgColor: digitColor),
                      _buildButton('8', bgColor: digitColor),
                      _buildButton('9', bgColor: digitColor),
                      _buildButton('×', bgColor: operatorColor),
                    ])),
                    Expanded(child: Row(children: [
                      _buildButton('4', bgColor: digitColor),
                      _buildButton('5', bgColor: digitColor),
                      _buildButton('6', bgColor: digitColor),
                      _buildButton('−', bgColor: operatorColor),
                    ])),
                    Expanded(child: Row(children: [
                      _buildButton('1', bgColor: digitColor),
                      _buildButton('2', bgColor: digitColor),
                      _buildButton('3', bgColor: digitColor),
                      _buildButton('+', bgColor: operatorColor),
                    ])),
                    Expanded(child: Row(children: [
                      _buildButton('0', bgColor: digitColor),
                      _buildButton('.', bgColor: digitColor),
                      _buildButton('=', bgColor: operatorColor),
                    ])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🔥 Responsive helpers
double scale(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return (width / 375).clamp(0.85, 1.3);
}

double r(double size, BuildContext context) {
  return size * scale(context);
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final int _length = 4;

  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  int _time = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(_length, (_) => TextEditingController());
    _focusNodes = List.generate(_length, (_) => FocusNode());

    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _time = 30;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_time == 0) {
        timer.cancel();
      } else {
        setState(() {
          _time--;
        });
      }
    });
  }

  void _onChanged(String val, int i) {
    if (val.isNotEmpty) {
      _controllers[i].text = val[val.length - 1];

      if (i < _length - 1) {
        _focusNodes[i + 1].requestFocus();
      }
    } else {
      if (i > 0) {
        _focusNodes[i - 1].requestFocus();
      }
    }

    final code = _controllers.map((e) => e.text).join();
    if (code.length == _length) {
      _submit(code);
    }
  }

  void _submit(String code) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Code: $code")),
    );
  }

  Widget _box(int i) {
    return SizedBox(
      width: r(60, context),
      height: r(65, context),
      child: TextField(
        controller: _controllers[i],
        focusNode: _focusNodes[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        cursorColor: Colors.transparent,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          fontSize: r(22, context),
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(r(14, context)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(r(14, context)),
            borderSide: BorderSide(color: Colors.blue, width: r(2, context)),
          ),
        ),
        onChanged: (v) => _onChanged(v, i),
      ),
    );
  }

  String _format(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return "$m:$sec";
  }

  void _resend() {
    for (var c in _controllers) {
      c.clear();
    }

    _focusNodes[0].requestFocus();
    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Code resent")),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r(24, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: r(20, context)),

              CircleAvatar(
                radius: r(20, context),
                backgroundColor: Colors.grey.shade200,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: r(20, context)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              SizedBox(height: r(40, context)),

              Text(
                "Enter the code",
                style: TextStyle(
                  fontSize: r(26, context),
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: r(10, context)),

              Text(
                "Enter the 4 digit code we sent to your email",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: r(14, context),
                ),
              ),

              SizedBox(height: r(40, context)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_length, (i) => _box(i)),
              ),

              SizedBox(height: r(40, context)),

              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r(18, context),
                    vertical: r(8, context),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(r(20, context)),
                  ),
                  child: Text(
                    _format(_time),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: r(16, context),
                    ),
                  ),
                ),
              ),

              SizedBox(height: r(20, context)),

              Center(
                child: GestureDetector(
                  onTap: _time == 0 ? _resend : null,
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      fontSize: r(16, context),
                      color: _time == 0 ? Colors.blue : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
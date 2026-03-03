// import 'package:flutter/material.dart';
//
// import 'country_selector.dart';
//
// class CountryInputField extends StatefulWidget {
//   const CountryInputField({super.key});
//
//   @override
//   State<CountryInputField> createState() => _CountryInputFieldState();
// }
//
// class _CountryInputFieldState extends State<CountryInputField> {
//   final TextEditingController controller = TextEditingController();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         CountrySelector(
//           onCountrySelect: (code) {
//             print("Selected Country Code: ${code.countryCode}");
//             print("Selected Country Flag: ${code.flagEmoji}");
//           },
//         ),
//         SizedBox(width: 6),
//         Expanded(
//           child: TextFormField(
//             controller: controller,
//             keyboardType: TextInputType.phone,
//             obscureText: false,
//             validator: (val) {
//               if (val?.isEmpty ?? true) {
//                 return "This field cannot be empty";
//               }
//               return null;
//             },
//             onChanged: (val) {},
//             inputFormatters: [],
//             decoration: InputDecoration(
//               filled: false,
//               // fillColor: const Color(0xFF3E3E3E),
//               hintText: "000 000 000",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(100),
//                 borderSide: BorderSide(
//                   width: 1,
//                   color: Color(0xffE5E5E6),
//                 ),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(100),
//                 borderSide: BorderSide(
//                   width: 1,
//                   color: Color(0xffE5E5E6),
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(100),
//                 borderSide: BorderSide(
//                   width: 1,
//                   color: Color(0xffE5E5E6),
//                 ),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(100),
//                 borderSide: BorderSide(
//                   width: 1,
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';

import 'country_selector.dart'; // ← your existing file

class CountryInputField extends StatefulWidget {
  const CountryInputField({super.key, required this.onChanged, this.label, this.labelTip, this.labelStyle});

  final Function(String) onChanged;
  final String? label;
  final String? labelTip;
  final TextStyle? labelStyle;

  @override
  State<CountryInputField> createState() => _CountryInputFieldState();
}

class _CountryInputFieldState extends State<CountryInputField> {
  final TextEditingController controller = TextEditingController();

  String? _errorText;

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field cannot be empty";
    }
    // Add more phone validation rules here if needed
    // e.g. length, only digits, etc.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if(widget.label != null)
        Row(
          children: [
            Text(
              widget.label!,
              style: const TextStyle(
                // color: Color(0xff696E7E),
                color: Color(0xff090909),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ).merge(widget.labelStyle ?? const TextStyle()),
            ),
            if (widget.labelTip != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Tooltip(
                  message: widget.labelTip,
                  child: const Icon(
                    Icons.info_outline,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CountrySelector(
              onCountrySelect: (code) {
                print("Selected Country Code: ${code.countryCode}");
                print("Selected Country Flag: ${code.flagEmoji}");
              },
            ),
            const SizedBox(width: 6),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.phone,
                validator: (val) {
                  // Always return null here → we handle error manually
                  final error = _validatePhone(val);
                  setState(() => _errorText = error);
                  return null;
                },
                onChanged: (val) {
                  // Optional: live validation while typing
                  final error = _validatePhone(val);
                  if (_errorText != error) {
                    setState(() => _errorText = error);
                  }
                },
                decoration: InputDecoration(
                  filled: false,
                  hintText: "000 000 000",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color(0xffE5E5E6),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color(0xffE5E5E6),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color(0xffE5E5E6),
                    ),
                  ),
                  // We remove error border — we'll show red manually
                  errorBorder: null,
                  focusedErrorBorder: null,
                ),
              ),
            ),
          ],
        ),

        // ← Error message appears here (left aligned)
        if (_errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 12), // align under phone field or adjust
            child: Text(
              _errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // Optional: call this when user presses "Next" / "Submit"
  bool validate() {
    final isValid = _validatePhone(controller.text) == null;
    setState(() {
      _errorText = isValid ? null : _validatePhone(controller.text);
    });
    return isValid;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
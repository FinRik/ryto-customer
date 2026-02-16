// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:flutter/material.dart';
//
// class CountryCodeSelector extends StatefulWidget {
//   final String? label, labelTip;
//   final void Function(CountryCode) onChanged;
//   final String? initialSelection;
//   final EdgeInsets? margin;
//   final TextStyle? labelStyle;
//
//   const CountryCodeSelector({
//     super.key,
//     this.label,
//     this.labelTip,
//     required this.onChanged,
//     this.initialSelection,
//     this.margin,
//     this.labelStyle,
//   });
//
//   @override
//   State<CountryCodeSelector> createState() => _CountryCodeSelectorState();
// }
//
// class _CountryCodeSelectorState extends State<CountryCodeSelector> {
//   late String? selectedCountry;
//
//   @override
//   void initState() {
//     selectedCountry = widget.initialSelection;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, String>> jsonList = codes;
//
//     List<CountryCode> elements =
//     jsonList.map((json) => CountryCode.fromJson(json)).toList();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (widget.label != null)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Row(
//               children: [
//                 Text(
//                   widget.label!,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w300,
//                   ).merge(widget.labelStyle ?? const TextStyle()),
//                 ),
//                 if (widget.labelTip != null)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Tooltip(
//                       message: widget.labelTip,
//                       child: const Icon(
//                         Icons.info_outline,
//                         size: 15,
//                         color: Colors.black,
//                       ),
//                     ),
//                   )
//               ],
//             ),
//           ),
//         Container(
//           constraints: const BoxConstraints(minHeight: 60),
//           decoration: BoxDecoration(
//             color: const Color(0xFF3E3E3E),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.25),
//               width: 1,
//             ),
//           ),
//           child: Padding(
//               padding: const EdgeInsets.only(
//                 left: 10.0,
//                 top: 8.0,
//                 right: 0.0,
//                 bottom: 8.0,
//               ),
//               child: PopupMenuButton(
//                 padding: EdgeInsets.zero,
//                 onSelected: handleClick,
//                 color: Colors.transparent,
//                 elevation: 0.0,
//                 offset: const Offset(32, 0),
//                 shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10))),
//                 child: AbsorbPointer(
//                   absorbing: true,
//                   child: Container(
//                     constraints: const BoxConstraints(minWidth: 90),
//                     child: CountryCodePicker(
//                       padding: EdgeInsets.zero,
//                       flagDecoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(3)),
//                       onChanged: _onCountryChange,
//                       textStyle:
//                       Theme.of(context).textTheme.bodyMedium!.copyWith(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       builder: (countryCode) {
//                         if (countryCode != null) {
//                           return Row(
//                             children: [
//                               Container(
//                                 margin: const EdgeInsets.only(right: 4.0),
//                                 clipBehavior: Clip.hardEdge,
//                                 width: 32,
//                                 height: 18,
//                                 decoration: BoxDecoration(
//                                     boxShadow: <BoxShadow>[
//                                       BoxShadow(
//                                           offset: const Offset(1, 1),
//                                           spreadRadius: 1.5,
//                                           blurRadius: 1.5,
//                                           color: Colors.grey.shade200),
//                                     ],
//                                     borderRadius: BorderRadius.circular(4.0),
//                                     image: DecorationImage(
//                                         fit: BoxFit.cover,
//                                         image: AssetImage(
//                                           countryCode.flagUri!,
//                                           package: 'country_code_picker',
//                                         ))),
//                               ),
//                               // Text(
//                               // "${countryCode.dialCode}",
//                               // style: const TextStyle(
//                               // color: Colors.black, fontWeight: FontWeight.w500),
//                               // ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Icon(
//                                   Icons.keyboard_arrow_down,
//                                   color:
//                                   Theme.of(context).colorScheme.secondary,
//                                   size: 28,
//                                 ),
//                               ),
//                             ],
//                           );
//                         }
//                       },
//                       hideMainText: true,
//                       initialSelection: selectedCountry,
//                       showCountryOnly: false,
//                       showOnlyCountryWhenClosed: false,
//                       showFlagDialog: false,
//                       enabled: false,
//                     ),
//                   ),
//                 ),
//                 itemBuilder: (BuildContext context) {
//                   return <PopupMenuEntry<CountryCode>>[
//                     PopupMenuItem<CountryCode>(
//                       child: Material(
//                         elevation: 2.0,
//                         borderRadius: BorderRadius.circular(10),
//                         child: Container(
//                           height: 250,
//                           width: 200,
//                           decoration: ShapeDecoration(
//                               color: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10))),
//                           child: Scrollbar(
//                             child: ListView.builder(
//                               padding: const EdgeInsets.only(top: 10),
//                               itemCount: elements.length,
//                               itemBuilder: (context, index) {
//                                 final choice = elements[index];
//                                 return PopupMenuItem<CountryCode>(
//                                   value: choice,
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         margin:
//                                         const EdgeInsets.only(right: 4.0),
//                                         clipBehavior: Clip.hardEdge,
//                                         width: 32,
//                                         height: 18,
//                                         decoration: BoxDecoration(
//                                             boxShadow: <BoxShadow>[
//                                               BoxShadow(
//                                                   offset: const Offset(1, 1),
//                                                   spreadRadius: 1.5,
//                                                   blurRadius: 1.5,
//                                                   color: Colors.grey.shade200),
//                                             ],
//                                             borderRadius:
//                                             BorderRadius.circular(4.0),
//                                             image: DecorationImage(
//                                                 fit: BoxFit.cover,
//                                                 image: AssetImage(
//                                                   choice.flagUri!,
//                                                   package:
//                                                   'country_code_picker',
//                                                 ))),
//                                       ),
//                                       Expanded(
//                                         child: Text(
//                                           "${choice.name}",
//                                           style: const TextStyle(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ];
//                 },
//               )),
//         ),
//       ],
//     );
//   }
//
//   void _onCountryChange(CountryCode countryCode) {
//     print("New Country selected: $countryCode");
//   }
//
//   void handleClick(CountryCode value) {
//     print("Country selected: ${value.toString()}");
//     setState(() {
//       selectedCountry = value.code;
//     });
//     if (value.dialCode != null) {
//       widget.onChanged(value);
//     }
//   }
// }

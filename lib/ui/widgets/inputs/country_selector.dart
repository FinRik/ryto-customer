import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

typedef OnCountrySelect = void Function(Country code);

class CountrySelector extends StatefulWidget {
  const CountrySelector({super.key, required this.onCountrySelect});

  final OnCountrySelect onCountrySelect;

  @override
  State<CountrySelector> createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  Country? selectedCountry;

  void selectCountry() {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: 500, // Optional. Country list modal height
        //Optional. Sets the border radius for the bottomsheet.
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        //Optional. Styles the search field.
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
        setState(() {
          selectedCountry = country;
          widget.onCountrySelect(country);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectCountry,
      child: Container(
        height: 50,
        width: 109,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: BoxBorder.all(
            width: 1,
            color: Color(0xffE5E5E6),
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(selectedCountry?.flagEmoji ?? "🇳🇬"),
            SizedBox(width: 4),
            Text("+${selectedCountry?.phoneCode ?? "234"}", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16,)
          ],
        ),
      ),
    );
  }
}

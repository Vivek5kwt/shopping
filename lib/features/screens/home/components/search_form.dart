import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shop/constants.dart';
import 'package:shop/features/screens/search/view/search_screen.dart';

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);

class SearchForm extends StatelessWidget {
  const SearchForm({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController search = TextEditingController();
    return Form(
      child: TextFormField(
        controller: search,
        // onSaved: (value) {},
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Search items...",
          border: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          errorBorder: outlineInputBorder,
          prefixIcon: GestureDetector(
            onTap: () => Get.to(() => SearchScreen(query: search.text)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: SvgPicture.asset("assets/icons/Search.svg"),
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Center(
                  child: Image.asset("assets/icons/filter.png", height: 35),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

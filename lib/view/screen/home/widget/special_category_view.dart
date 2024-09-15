import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/special_category_product_view_all_screen.dart';

class SpecialCategory {
  final String name;
  final String image;
  final int? id;
  SpecialCategory({required this.id, required this.image, required this.name});
}

class SpecialCategoryView extends StatelessWidget {
  final bool isHomePage;
  SpecialCategoryView({Key? key, required this.isHomePage}) : super(key: key);

  List<SpecialCategory> specialCategories = [
    SpecialCategory(id: 4, image: 'fpo.jpeg', name: 'FPO/FPC'),
    SpecialCategory(id: 6, image: 'bachat.jpeg', name: 'Mahila Bachat Gat'),
    SpecialCategory(id: null, image: 'special.jpeg', name: 'Special Category'),
    SpecialCategory(id: 11, image: 'prison.jpeg', name: 'Prison'),
    SpecialCategory(id: 1, image: 'millet.jpeg', name: 'Millet'),
    SpecialCategory(id: 16, image: 'government.jpeg', name: 'Government Organization'),

  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        primary: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: specialCategories.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final cat = specialCategories[index];
          return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                width: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (cat.id == null) return;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SpecialCategoryProductScreen(
                                id: cat.id!, name: cat.name)));
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                              'assets/images/special_category/${cat.image}',
                              fit: BoxFit.cover,
                              height: 150)),
                    ),
                    const SizedBox(height: 4),
                    Text(cat.name)
                  ],
                ),
              ));
        },
      ),
    );
  }
}

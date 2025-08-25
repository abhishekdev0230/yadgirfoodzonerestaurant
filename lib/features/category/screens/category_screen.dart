import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryModel? categoryModel;
  const CategoryScreen({super.key, required this.categoryModel});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  @override
  void initState() {
    Get.find<CategoryController>().getCategoryList(null);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: CustomAppBarWidget(title: 'categories'.tr),

      body: GetBuilder<CategoryController>(builder: (categoryController) {

        List<CategoryModel>? categories;

        if(categoryController.categoryList != null) {
          categories = [];
          categories.addAll(categoryController.categoryList!);
        }

        return categories != null ? categories.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await Get.find<CategoryController>().getCategoryList(null);
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.05), spreadRadius: 0, blurRadius: 5)],
                    border: Border.all(width: 1, color: Theme.of(context).primaryColor.withValues(alpha: 0.08)),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeExtraSmall),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: CustomImageWidget(
                          image: '${categories![index].imageFullUrl}',
                          height: 60, width: 65, fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(categories[index].name!, style: robotoMedium),
                      subtitle: Text(
                        categories[index].productsCount! > 0 ? '${categories[index].productsCount} ${'foods_are_available'.tr}' : 'no_food_available'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                      ),

                      trailing: SizedBox(
                        width: 25,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          categories[index].childesCount! > 0 ? Icon(categoryController.selectedCategoryIndex == index && categoryController.isExpanded  ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 24, color: Theme.of(context).textTheme.bodyLarge!.color) : const SizedBox(),
                        ]),
                      ),

                      onExpansionChanged: (value) {
                        categoryController.expandedUpdate(value);
                        categoryController.setSelectedCategoryIndex(index);
                      },

                      children: [
                        categories[index].childes!.isNotEmpty ? Container(
                          margin: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            itemCount: categories[index].childes?.length,
                            itemBuilder: (context, subIndex) {
                              return Column(
                                children: [
                                  Row(children: [
                                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                      Text(categories?[index].childes![subIndex].name ?? '', style: robotoMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                      Text(
                                        categories![index].childes![subIndex].productsCount! > 0 ? '${categories[index].childes![subIndex].productsCount} ${'foods_are_available'.tr}' : 'no_food_available'.tr,
                                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                                      ),

                                    ])),
                                  ]),

                                  subIndex != categories[index].childes!.length - 1 ? Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.5), height: 20,) : const SizedBox(),
                                ],
                              );
                            },
                          ),
                        ) : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ) : Center(child: Text('no_category_found'.tr)) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
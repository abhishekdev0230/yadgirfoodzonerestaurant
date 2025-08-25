import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_tool_tip_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/controllers/expense_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/widgets/expense_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/custom_print_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {

  final TextEditingController _searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<ExpenseController>().initSetDate();
    Get.find<ExpenseController>().setOffset(1);

    Get.find<ExpenseController>().getExpenseList(
      offset: Get.find<ExpenseController>().offset.toString(),
      from: Get.find<ExpenseController>().from, to: Get.find<ExpenseController>().to,
      searchText: Get.find<ExpenseController>().searchText,
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<ExpenseController>().expenses != null
          && !Get.find<ExpenseController>().isLoading) {
        int pageSize = (Get.find<ExpenseController>().pageSize! / 10).ceil();
        if (Get.find<ExpenseController>().offset < pageSize) {
          Get.find<ExpenseController>().setOffset(Get.find<ExpenseController>().offset+1);
          customPrint('end of the page');
          Get.find<ExpenseController>().showBottomLoader();
          Get.find<ExpenseController>().getExpenseList(
            offset: Get.find<ExpenseController>().offset.toString(),
            from: Get.find<ExpenseController>().from, to: Get.find<ExpenseController>().to,
            searchText: Get.find<ExpenseController>().searchText,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(
        title: 'expense_report'.tr,
        menuWidget: CustomToolTip(
          message: 'you_are_now_viewing_one_month_of_data_to_view_more_data_click_the_filter_button'.tr,
          preferredDirection: AxisDirection.down,
          child: Icon(Icons.info, size: 20, color: Theme.of(context).textTheme.bodyLarge!.color),
        ),
      ),

      body: GetBuilder<ExpenseController>(builder: (expenseController) {
        return Column(children: [

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Row(children: [

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    //color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.4)),
                  ),
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                  child: GetBuilder<ExpenseController>(builder: (expenseController) {
                    return TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'search_with_order_id'.tr,
                        hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                        contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall + 2),
                        suffixIcon: IconButton(
                          icon: Icon(expenseController.searchMode ? Icons.clear : CupertinoIcons.search, color: Theme.of(context).hintColor),
                          onPressed: (){
                            if(!expenseController.searchMode){
                              if(_searchController.text.isNotEmpty){
                                expenseController.setSearchText(offset: '1', from: Get.find<ExpenseController>().from, to: Get.find<ExpenseController>().to, searchText: _searchController.text);
                              }else{
                                showCustomSnackBar('your_search_box_is_empty'.tr);
                              }
                            }else if(expenseController.searchMode){
                              _searchController.text = '';
                              expenseController.setSearchText(offset: '1', from: Get.find<ExpenseController>().from, to: Get.find<ExpenseController>().to, searchText: _searchController.text);
                            }
                          },
                        ),
                      ),
                      onSubmitted: (value){
                        if(value.isNotEmpty){
                          expenseController.setSearchText(offset: '1', from: Get.find<ExpenseController>().from, to: Get.find<ExpenseController>().to, searchText: value);
                        }else{
                          showCustomSnackBar('your_search_box_is_empty'.tr);
                        }
                      },
                    );
                  }),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              InkWell(
                onTap: () => expenseController.showDatePicker(context),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: expenseController.from != null && expenseController.to != null ? Theme.of(context).primaryColor : null,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        border: expenseController.from != null && expenseController.to != null ? null : Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.4)),
                      ),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Icon(Icons.calendar_today_outlined, color: expenseController.from != null && expenseController.to != null ? Theme.of(context).cardColor : Theme.of(context).hintColor, size: 20),
                    ),

                    expenseController.from != null && expenseController.to != null ? Positioned(
                      right: -3, top: -3,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).cardColor, width: 1),
                        ),
                      ),
                    ) : const SizedBox(),

                  ],
                ),
              ),

            ]),
          ),

          expenseController.from != null && expenseController.to != null ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            Text('from'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              child: Text(DateConverter.convertDateToDate(expenseController.from!), style: robotoBold),
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text('to'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              child: Text(DateConverter.convertDateToDate(expenseController.to!), style: robotoBold),
            ),

          ]) : const SizedBox(),

          Expanded(
            child: expenseController.expenses != null ? expenseController.expenses!.isNotEmpty ? ListView.builder(
              controller: scrollController,
              itemCount: expenseController.expenses!.length,
              shrinkWrap: true,
              itemBuilder: (context, index){
                return ExpenseCardWidget(expense: expenseController.expenses![index]);
            }) : Center(child: Text('no_expense_found'.tr, style: robotoMedium)) : const Center(child: CircularProgressIndicator()),
          ),

          expenseController.isLoading ? Center(child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : const SizedBox(),

        ]);
      }),
    );
  }
}
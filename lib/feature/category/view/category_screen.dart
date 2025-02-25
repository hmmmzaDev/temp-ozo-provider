
import 'package:get/get.dart';
import 'package:demandium_provider/utils/core_export.dart';


class AllServicesScreen extends StatefulWidget {
  const AllServicesScreen({super.key});

  @override
  State<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen> {

  @override
  void initState() {

    ServiceCategoryController controller   = Get.find();
    controller.menuScrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );
    controller.menuScrollController!.scrollToIndex(0, preferPosition: AutoScrollPosition.middle);
    controller.menuScrollController!.highlight(0);

    controller.getCategoryList();
    controller.changeCategory(0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Get.isDarkMode? Theme.of(context).colorScheme.surface : Theme.of(context).primaryColor.withOpacity(0.05),
      appBar: MainAppBar(title: 'available_services',color:  Theme.of(context).primaryColor,),

      body: GetBuilder<ServiceCategoryController>( builder: (allServiceController) {
        if (allServiceController.isLoading && allServiceController.serviceCategoryList.isEmpty) {
          return const CategorySubcategoryShimmer();
        } else {
          return allServiceController.serviceCategoryList.isEmpty?

        SizedBox(height: Get.height*.8,
          child: Center(
            child: NoDataScreen(text: "no_available_service".tr,type: NoDataType.service),
          ),

        ): Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [

                const SizedBox(height: Dimensions.paddingSizeDefault,),

                Container(
                  width: 110,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:BorderRadius.only(
                      bottomRight:  allServiceController.selectedCategory == 0 ? const Radius.circular(15) : const Radius.circular(0)
                    )
                  ),
                  child: Column(children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: Text("categories".tr,style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                        overflow: TextOverflow.ellipsis
                      ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ],),
                ),
                Expanded(
                  child: SizedBox(
                    width: 110,
                    child: ListView.builder(
                      itemCount: allServiceController.serviceCategoryList.length,
                      controller: allServiceController.menuScrollController,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context,index){
                        return GestureDetector(
                          child: AutoScrollTag(
                            controller: allServiceController.menuScrollController!,
                            key: ValueKey(index),
                            index: index,
                            child: Column(
                              children: [
                                CategoryItem(
                                  index: index,
                                  image: allServiceController.serviceCategoryList[index].imageFullPath.toString(),
                                  title: allServiceController.serviceCategoryList[index].name.toString(),
                                  selectedCategory:  allServiceController.serviceCategoryList[allServiceController
                                      .selectedCategory].name.toString(),
                                ),
                                index == allServiceController.serviceCategoryList.length - 1 ? Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.only(
                                      topRight: allServiceController.selectedCategory ==
                                          allServiceController.serviceCategoryList.length -1 ?
                                      const Radius.circular(Dimensions.paddingSizeDefault) : const Radius.circular(0),
                                    )
                                  ),
                                ): const SizedBox(),
                              ],
                            ),
                          ),
                          onTap: () async {
                            allServiceController.changeCategory(index);
                            allServiceController.getSubCategoryList(offset: 1, isFromPagination: false);
                            await allServiceController.menuScrollController!.scrollToIndex(
                                index, preferPosition: AutoScrollPosition.middle,
                                duration: const Duration(milliseconds: 1000)
                            );
                            await  allServiceController.menuScrollController!.highlight(index);

                          },
                        );
                      },
                    ),
                  ),
                ),

              ],
            ),

            Expanded(
              child: Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault*3,left: Dimensions.paddingSizeExtraSmall+2),
                child: SizedBox(
                  child: SubCategoryView(subCategoryList: allServiceController.serviceSubCategoryList),
                ),
              ),
            )
          ],
        );
        }},
      ),
    );
  }
}

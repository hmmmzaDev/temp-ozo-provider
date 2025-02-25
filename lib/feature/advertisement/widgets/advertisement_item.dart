import 'package:get/get.dart';
import 'package:demandium_provider/utils/core_export.dart';

class AdvertisementItem extends StatelessWidget {
  final AdvertisementData advertisementData;
  const AdvertisementItem({
    super.key, required this.advertisementData,});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdvertisementController>(builder: (advertisementController){

      String adsStatus = advertisementController.getAdvertisementStatus(advertisementData.status, advertisementData.startDate!, advertisementData.endDate!);
      bool isExpired = advertisementController.isAdvertisementExpired(advertisementData.endDate!);

      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(Get.isDarkMode?0.5:1),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: Get.find<ThemeController>().darkTheme ? null : lightShadow,
        ),
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start , children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
              Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall+3,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween , crossAxisAlignment: CrossAxisAlignment.start, children: [ Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("ad".tr,
                        style: ubuntuMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.7),
                        ),
                      ),
                      Text(" # ${advertisementData.readableId}",
                        style: ubuntuBold.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.8),
                          fontSize: Dimensions.fontSizeLarge,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault,),
                      if(advertisementController.currentIndex==0) Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraSmall -1,
                                horizontal: Dimensions.paddingSizeSmall,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Get.isDarkMode?Colors.grey.withOpacity(0.2):
                                ColorResources.buttonBackgroundColorMap[adsStatus],
                              ),
                              child: Center(
                                child: Text(adsStatus.tr,
                                  style:ubuntuMedium.copyWith( fontSize: 12,
                                    color:ColorResources.buttonTextColorMap[adsStatus],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: Dimensions.paddingSizeSmall,),

                            isExpired ? Expanded(
                              child: Text('(${'expired'.tr})', maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                              ),
                            ): const SizedBox()
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                  Text("${advertisementData.type}".tr,
                    style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall + 2,  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),),

              PopupMenuButton<PopupMenuModel>(
                shape:  RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault,)),
                  side: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.1))
                ),
                surfaceTintColor: Theme.of(context).cardColor,
                position: PopupMenuPosition.under, elevation: 8,
                shadowColor: Theme.of(context).hintColor.withOpacity(0.3),
                itemBuilder: (BuildContext context) {
                  return advertisementController.getPopupMenuList(advertisementData.status!).map((PopupMenuModel option) {
                    return PopupMenuItem<PopupMenuModel>(
                      onTap: ()async{

                        if(option.title == "edit_ads"){
                          Get.to(()=>CreateAdvertisementScreen(isEditScreen: true, advertisementData: advertisementData));
                        }

                        else if (option.title == 'view_ads'){
                          Get.to(()=> AdvertisementDetailsScreen(id: advertisementData.id ?? "",));
                        }

                        else if(option.title == "delete_ads"){
                          advertisementData.status == 'running' ?
                          showCustomBottomSheet(child: ConfirmationBottomSheet(
                            image: Images.cautionDialogIcon, title: "can't_delete_dialog_title",
                            description: "can't_delete_dialog_description", status: option.title,
                            confirmButtonText: "okay",
                            isShowNotNowButton: false,
                            yesButtonPressed: () async{
                              Get.back();
                            },
                          )) : showCustomBottomSheet(child: ConfirmationBottomSheet(
                            image: Images.deleteDialogIcon, title: "confirm_delete_dialog_title",
                            description: "confirm_delete_dialog_description", status: option.title,
                            yesButtonPressed: () async{
                              await Get.find<AdvertisementController>().deleteAdvertisement(id: advertisementData.id ?? "");
                            },
                          ));
                        }

                        else if(option.title == 'pause_ads'){
                          Get.find<AdvertisementController>().resetNoteController();
                           showCustomBottomSheet(child: ConfirmationBottomSheet(
                             image: Images.pauseDialogIcon, title: "pause_dialog_title",
                             description: "pause_dialog_description", status: option.title,
                             yesButtonPressed: () async{
                               if(advertisementController.noteFormKey.currentState!.validate()){
                                 await Get.find<AdvertisementController>().changeAdvertisementStatus(id: advertisementData.id ?? "", status: 'paused');
                               }
                             },
                           ));

                        }

                        else if(option.title == 'cancel_ads'){
                          Get.find<AdvertisementController>().resetNoteController();
                          showCustomBottomSheet(child: ConfirmationBottomSheet(
                            image: Images.cancelDialogIcon, title: "cancel_dialog_title",
                            description: "cancel_dialog_description", status: option.title,
                            yesButtonPressed: () async{
                              if(advertisementController.noteFormKey.currentState!.validate()) {
                                await Get.find<AdvertisementController>()
                                    .changeAdvertisementStatus(
                                    id: advertisementData.id ?? "",
                                    status: 'canceled');
                              }
                            },),
                          );
                        }

                        else if(option.title == 'resume_ads'){
                          showCustomBottomSheet(child: ConfirmationBottomSheet(
                            image: Images.resumeDialogIcon, title: "resume_dialog_title",
                            description: "resume_dialog_description", status: option.title, yesTestColor: Theme.of(context).primaryColor,
                            yesButtonPressed: () async{
                              await Get.find<AdvertisementController>().changeAdvertisementStatus(id: advertisementData.id ?? "", status: 'resumed');
                            },),
                          );
                        }

                        else if(option.title == 'copy_ads'){
                          Get.to(()=>CreateAdvertisementScreen(isEditScreen: true, advertisementData: advertisementData, isForResubmit: true));
                        }
                      },
                      value: option,
                      height: 40,
                      child: Row(
                        children: [
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                          Icon(option.icon, size: Dimensions.fontSizeLarge,),
                          const SizedBox(width: Dimensions.paddingSizeSmall,),
                          Text(option.title.tr, style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall
                          ),),
                        ],
                      ),
                    );
                  }).toList();
                },
                child: Icon(Icons.more_vert, color: Theme.of(context).hintColor.withOpacity(0.7),),
              )

            ],
            ),
          ),

          Container(height: 2,width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
              Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(children: [
                    Row(
                      children: [
                        Text("${'ad_created'.tr}: ",
                            style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,   color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6))
                        ),
                        Text(" ${DateConverter.isoStringToLocalDateOnly(advertisementData.createdAt!)}",
                          style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,   color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                          textDirection: TextDirection.ltr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),

                    const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                    Row(
                      children: [
                        Text("${'duration'.tr}: ",
                          style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall ,  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                        ),
                        Text("${DateConverter.stringToLocalDateOnly(advertisementData.startDate ??"")} - ${DateConverter.stringToLocalDateOnly(advertisementData.endDate ??"")}",
                          style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall ,  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                          textDirection: TextDirection.ltr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],),
                ),
                InkWell(
                  onTap: () => Get.to(AdvertisementDetailsScreen(id: advertisementData.id ?? '')),
                  child: Container(
                    margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                    child: Icon(Icons.arrow_forward_rounded, color: Theme.of(context).primaryColor.withOpacity(0.6),),
                  ),
                )
              ],
            ),
          )
        ],),
      );
    });
  }
}

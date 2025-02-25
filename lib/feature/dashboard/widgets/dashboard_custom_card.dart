import 'package:get/get.dart';
import 'package:demandium_provider/utils/core_export.dart';

class TopCardItem extends StatelessWidget {
  final Color cardColor;
  final String amount;
  final String title;
  final double? height;
  final String iconData;
  final Color? curveColor;
  const TopCardItem({super.key,this.curveColor,required this.amount,required this.title,required this.cardColor,this.height,required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: height ,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: cardColor),

        child: Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width*.40,
              decoration:  BoxDecoration(
                borderRadius: const  BorderRadius.only(bottomRight: Radius.circular(280),bottomLeft:Radius.circular(50),topLeft: Radius.circular(50) ),
                color: curveColor!=null?curveColor!:Colors.transparent
              ),
            ),


            Positioned.fill(right: 10, left: 10, top: 20,
              child: Align(
                alignment: Get.find<LocalizationController>().isLtr ?  Alignment.topRight : Alignment.topLeft,
                child: Image.asset(iconData),
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),


              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children:   [
                  Text(amount,
                      style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          color: light.cardColor
                      ),
                    maxLines: 2,

                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                  Text(title,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault,color: light.cardColor),
                    textDirection: TextDirection.ltr, maxLines: 2, overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_avataaar/flutter_avataaar.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_svg/svg.dart';

class AvataaarGenerator extends StatelessWidget {
  final Avataaar avataaar;
  final AvataaarPicture? avataaarPicture;
  final String Function(String key) onTranslateKey;
  final void Function()? onUpdateAvataaar;
  final void Function(Exception exception)? onError;
  final List<Color> colors;
  final Widget Function(
    BuildContext context,
    int index,
    int itemsCount,
    void Function() onTap,
    String currentSelected,
    String type,
    String icon,
    ValueChanged<int> onUpdate,
  )? sectionBuilder;

  AvataaarGenerator({
    Key? key,
    required this.avataaar,
    required this.onTranslateKey,
    this.onUpdateAvataaar,
    this.avataaarPicture,
    this.onError,
    this.colors = Avataaar.defaultBackgroundColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: avataaarPicture ??
              AvataaarPicture.builder(
                avatar: avataaar,
                onError: onError,
              ),
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50.0,
                  padding: EdgeInsets.all(4.0),
                  child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const SizedBox(
                            width: 8.0,
                          ),
                      scrollDirection: Axis.horizontal,
                      itemCount: colors.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            avataaar.backgroundColor = colors[index];
                            onUpdateAvataaar?.call();
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: colors[index],
                                  shape: BoxShape.circle,
                                ),
                                width: 32.0,
                              ),
                              if (avataaar.backgroundColor == colors[index])
                                Transform.translate(
                                  offset: Offset(0.0, -20.0),
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 32.0,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                ),
                //TopType
                typeBuilder(
                    context,
                    TopType.values.indexOf(avataaar.top.topType),
                    TopType.values.length,
                    () {
                      showMaterialScrollPicker<TopType>(
                        context: context,
                        title: onTranslateKey('top'),
                        transformer: (item) => onTranslateKey(
                          topTypeNames[item.index],
                        ),
                        items: TopType.values,
                        selectedItem: avataaar.top.topType,
                        onChanged: (value) {
                          avataaar.top.topType = value;
                          onUpdateAvataaar?.call();
                        },
                      );
                    },
                    onTranslateKey(
                      topTypeNames[avataaar.top.topType.index],
                    ),
                    onTranslateKey('top'),
                    'cowboy_hat',
                    (index) {
                      avataaar.top.topType = TopType.values[index];
                      onUpdateAvataaar?.call();
                    }),
                //HairColor
                if (!(avataaar.top.topType == TopType.noHair ||
                    avataaar.top.topType == TopType.eyepatch ||
                    avataaar.top.topType == TopType.hat ||
                    avataaar.top.topType == TopType.hijab ||
                    avataaar.top.topType == TopType.turban ||
                    avataaar.top.topType == TopType.winterHat1 ||
                    avataaar.top.topType == TopType.winterHat2 ||
                    avataaar.top.topType == TopType.winterHat3 ||
                    avataaar.top.topType == TopType.winterHat4 ||
                    avataaar.top.topType == TopType.longHairFrida ||
                    avataaar.top.topType == TopType.longHairShavedSides))
                  typeBuilder(
                    context,
                    HairColor.values.indexOf(avataaar.top.hairColor),
                    HairColor.values.length,
                    () {
                      showMaterialScrollPicker<HairColor>(
                        context: context,
                        title: onTranslateKey('hair_color'),
                        transformer: (item) => onTranslateKey(hairColorNames[item.index]),
                        items: HairColor.values,
                        selectedItem: avataaar.top.hairColor,
                        onChanged: (value) {
                          avataaar.top.hairColor = value;
                          onUpdateAvataaar?.call();
                        },
                      );
                    },
                    onTranslateKey(hairColorNames[avataaar.top.hairColor.index]),
                    onTranslateKey('hair_color'),
                    'hair_color',
                    (index) {
                      avataaar.top.hairColor = HairColor.values[index];
                      onUpdateAvataaar?.call();
                    },
                  ),

                //HatColor
                if ((avataaar.top.topType == TopType.hijab ||
                    avataaar.top.topType == TopType.turban ||
                    avataaar.top.topType == TopType.winterHat1 ||
                    avataaar.top.topType == TopType.winterHat2 ||
                    avataaar.top.topType == TopType.winterHat3 ||
                    avataaar.top.topType == TopType.winterHat4))
                  typeBuilder(
                    context,
                    HatColor.values.indexOf(avataaar.top.hatColor),
                    HatColor.values.length,
                    () {
                      showMaterialScrollPicker<HatColor>(
                        context: context,
                        title: onTranslateKey('hat_color'),
                        transformer: (item) => onTranslateKey(hatColorNames[item.index]),
                        items: HatColor.values,
                        selectedItem: avataaar.top.hatColor,
                        onChanged: (value) {
                          avataaar.top.hatColor = value;
                          onUpdateAvataaar?.call();
                        },
                      );
                    },
                    onTranslateKey(hatColorNames[avataaar.top.hatColor.index]),
                    onTranslateKey('hat_color'),
                    'cowboy_hat_color',
                    (index) {
                      avataaar.top.hatColor = HatColor.values[index];
                      onUpdateAvataaar?.call();
                    },
                  ),

                //AccessoriesType
                if (avataaar.top.topType != TopType.eyepatch)
                  typeBuilder(
                    context,
                    AccessoriesType.values
                        .indexOf(avataaar.top.accessoriesType),
                    AccessoriesType.values.length,
                    () {
                      showMaterialScrollPicker<AccessoriesType>(
                          context: context,
                          title: onTranslateKey('accessories'),
                          transformer: (item) => onTranslateKey(accessoriesTypeNames[item.index]),
                          items: AccessoriesType.values,
                          selectedItem: avataaar.top.accessoriesType,
                          onChanged: (value) {
                            avataaar.top.accessoriesType = value;
                            onUpdateAvataaar?.call();
                          });
                    },
                    onTranslateKey(accessoriesTypeNames[avataaar.top.accessoriesType.index]),
                    onTranslateKey('accessories'),
                    'bowtie',
                    (index) {
                      avataaar.top.accessoriesType =
                          AccessoriesType.values[index];
                      onUpdateAvataaar?.call();
                    },
                  ),
                //FacialHairType
                if (avataaar.top.topType != TopType.hijab)
                  typeBuilder(
                    context,
                    FacialHairType.values
                        .indexOf(avataaar.top.facialHair.facialHairType),
                    FacialHairType.values.length,
                    () {
                      showMaterialScrollPicker<FacialHairType>(
                        context: context,
                        title: onTranslateKey('facial_hair_type'),
                        transformer: (item) => onTranslateKey(facialHairTypeNames[item.index]),
                        items: FacialHairType.values,
                        selectedItem: avataaar.top.facialHair.facialHairType,
                        onChanged: (value) {
                          avataaar.top.facialHair.facialHairType = value;
                          onUpdateAvataaar?.call();
                        },
                      );
                    },
                    onTranslateKey(facialHairTypeNames[avataaar.top.facialHair.facialHairType.index]),
                    onTranslateKey('facial_hair_type'),
                    'beard',
                    (index) {
                      avataaar.top.facialHair.facialHairType =
                          FacialHairType.values[index];
                      onUpdateAvataaar?.call();
                    },
                  ),
                //FacialHairColor
                if (avataaar.top.topType != TopType.hijab &&
                    avataaar.top.facialHair.facialHairType != FacialHairType.blank)
                  typeBuilder(
                    context,
                    FacialHairColor.values
                        .indexOf(avataaar.top.facialHair.facialHairColor),
                    FacialHairColor.values.length,
                    () {
                      showMaterialScrollPicker<FacialHairColor>(
                        context: context,
                        title: onTranslateKey('facial_hair_color'),
                        transformer: (item) => onTranslateKey(facialHairColorNames[item.index]),
                        items: FacialHairColor.values,
                        selectedItem: avataaar.top.facialHair.facialHairColor,
                        onChanged: (value) {
                          avataaar.top.facialHair.facialHairColor = value;
                          onUpdateAvataaar?.call();
                        },
                      );
                    },
                    onTranslateKey(facialHairColorNames[avataaar.top.facialHair.facialHairColor.index]),
                    onTranslateKey('facial_hair_color'),
                    'beard_color',
                    (index) {
                      avataaar.top.facialHair.facialHairColor =
                          FacialHairColor.values[index];
                      onUpdateAvataaar?.call();
                    },
                  ),

                //ClotheType
                typeBuilder(
                  context,
                  ClotheType.values.indexOf(avataaar.clothes.clotheType),
                  ClotheType.values.length,
                  () {
                    showMaterialScrollPicker<ClotheType>(
                      context: context,
                      title: onTranslateKey('clothes_type'),
                      transformer: (item) => onTranslateKey(clotheTypeNames[item.index]),
                      items: ClotheType.values,
                      selectedItem: avataaar.clothes.clotheType,
                      onChanged: (value) {
                        avataaar.clothes.clotheType = value;
                        onUpdateAvataaar?.call();
                      },
                    );
                  },
                  onTranslateKey(clotheTypeNames[avataaar.clothes.clotheType.index]),
                  onTranslateKey('clothes_type'),
                  'hawaiian-shirt',
                  (index) {
                    avataaar.clothes.clotheType = ClotheType.values[index];
                    onUpdateAvataaar?.call();
                  },
                ),
                //ClotheColor
                if (!(avataaar.clothes.clotheType == ClotheType.blazerShirt ||
                    avataaar.clothes.clotheType == ClotheType.blazerSweater))
                  typeBuilder(
                    context,
                  ClotheColor.values.indexOf(avataaar.clothes.clotheColor),
                  ClotheColor.values.length,
                    () {
                      showMaterialScrollPicker<ClotheColor>(
                        context: context,
                        title: onTranslateKey('clothes_color'),
                        transformer: (item) => onTranslateKey(clotheColorNames[item.index]),
                        items: ClotheColor.values,
                        selectedItem: avataaar.clothes.clotheColor,
                        onChanged: (value) {
                          avataaar.clothes.clotheColor = value;
                          onUpdateAvataaar?.call();
                        },
                      );
                    },
                    onTranslateKey(clotheColorNames[avataaar.clothes.clotheColor.index]),
                    onTranslateKey('clothes_color'),
                    'hawaiian-shirt_color',
                    (index) {
                      avataaar.clothes.clotheColor = ClotheColor.values[index];
                      onUpdateAvataaar?.call();
                    },
                  ),
                //Eyes
                typeBuilder(
                  context,
                  EyeType.values.indexOf(avataaar.eyes.eyeType),
                  EyeType.values.length,
                  () {
                    showMaterialScrollPicker<EyeType>(
                      context: context,
                      title: onTranslateKey('eyes'),
                      transformer: (item) => onTranslateKey(eyeTypeNames[item.index]),
                      items: EyeType.values,
                      selectedItem: avataaar.eyes.eyeType,
                      onChanged: (value) {
                        avataaar.eyes.eyeType = value;
                        onUpdateAvataaar?.call();
                      },
                    );
                  },
                  onTranslateKey(eyeTypeNames[avataaar.eyes.eyeType.index]),
                  onTranslateKey('eyes'),
                  'eye',
                  (index) {
                    avataaar.eyes.eyeType = EyeType.values[index];
                    onUpdateAvataaar?.call();
                  },
                ),
                //EyesBrown
                typeBuilder(
                  context,
                  EyebrowType.values.indexOf(avataaar.eyebrow.eyebrowType),
                  EyebrowType.values.length,
                  () {
                    showMaterialScrollPicker<EyebrowType>(
                      context: context,
                      title: onTranslateKey('eyebrow'),
                      transformer: (item) => onTranslateKey(eyebrowTypeNames[item.index]),
                      items: EyebrowType.values,
                      selectedItem: avataaar.eyebrow.eyebrowType,
                      onChanged: (value) {
                        avataaar.eyebrow.eyebrowType = value;
                        onUpdateAvataaar?.call();
                      },
                    );
                  },
                  onTranslateKey(eyebrowTypeNames[avataaar.eyebrow.eyebrowType.index]),
                  onTranslateKey('eyebrow'),
                  'eyebrows',
                  (index) {
                    avataaar.eyebrow.eyebrowType = EyebrowType.values[index];
                    onUpdateAvataaar?.call();
                  },
                ),
                //Mouth
                typeBuilder(
                  context,
                  MouthType.values.indexOf(avataaar.mouth.mouthType),
                  MouthType.values.length,
                  () {
                    showMaterialScrollPicker<MouthType>(
                      context: context,
                      title: onTranslateKey('mouth'),
                      transformer: (item) => onTranslateKey(mouthTypeNames[item.index]),
                      items: MouthType.values,
                      selectedItem: avataaar.mouth.mouthType,
                      onChanged: (value) {
                        avataaar.mouth.mouthType = value;
                        onUpdateAvataaar?.call();
                      },
                    );
                  },
                  onTranslateKey(mouthTypeNames[avataaar.mouth.mouthType.index]),
                  onTranslateKey('mouth'),
                  'mouth',
                  (index) {
                    avataaar.mouth.mouthType = MouthType.values[index];
                    onUpdateAvataaar?.call();
                  },
                ),
                //Skin
                typeBuilder(
                  context,
                  SkinColor.values.indexOf(avataaar.skin.skinColor),
                  SkinColor.values.length,
                  () {
                    showMaterialScrollPicker<SkinColor>(
                      context: context,
                      title: onTranslateKey('skin'),
                      transformer: (item) => onTranslateKey(skinColorNames[item.index]),
                      items: SkinColor.values,
                      selectedItem: avataaar.skin.skinColor,
                      onChanged: (value) {
                        avataaar.skin.skinColor = value;
                        onUpdateAvataaar?.call();
                      },
                    );
                  },
                  onTranslateKey(skinColorNames[avataaar.skin.skinColor.index]),
                  onTranslateKey('skin'),
                  'wheel',
                  (index) {
                    avataaar.skin.skinColor = SkinColor.values[index];
                    onUpdateAvataaar?.call();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///Used to build the types as a row
  Widget typeBuilder(
    BuildContext context,
    int index,
    int itemsCount,
    void Function() onTap,
    String currentSelected,
    String type,
    String icon,
    ValueChanged<int> onUpdate,
  ) {
    if (sectionBuilder != null) {
      return sectionBuilder!(context, index, itemsCount, onTap, currentSelected,
          type, icon, onUpdate);
    }
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            'lib/assets/svg/$icon.svg',
            package: 'flutter_avataaar',
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              type,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: onTap,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                currentSelected,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

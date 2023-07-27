#!/bin/bash

. variables.sh

clean_temp

cp -vr $CUR_DIR/arch/arm64/configs/exynos9810_defconfig $CUR_DIR/arch/arm64/configs/exynos9810_temp_defconfig
echo "" >> $CUR_DIR/arch/arm64/configs/exynos9810_temp_defconfig
cat $CUR_DIR/arch/arm64/configs/exynos9810-crownlte_defconfig >> $CUR_DIR/arch/arm64/configs/exynos9810_temp_defconfig



make exynos9810_temp_defconfig -j$(nproc --all)
if [ ! -z "$1" ]
then  
  if [ "$1" == "stock" ]; then
    patch_stock
  elif [ "$1" == "aosp" ]; then
	patch_aosp
  fi
fi
if [ -z "$2" ]
then  
  patch_kernelsu
fi
if [ -z "$3" ]
then  
  dts_erofs
else
  dts_ext4
fi

make -j$(nproc --all)

printf $KERNEL_NAME
cp -vr $CUR_DIR/arch/arm64/boot/Image $ZIP_DIR/$KERNEL_NAME/crownlte/zImage
cp -vr $CUR_DIR/arch/arm64/boot/dtb.img $ZIP_DIR/$DTB_NAME/crownlte/dtb.img
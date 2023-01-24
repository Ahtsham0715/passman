import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:passman/Auth/controllers/onbaording_controller.dart';
import 'package:passman/Auth/login_page.dart';
import 'package:passman/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../res/components/custom_text.dart';

class onboardingPage extends GetView<OnboardingController> {
  onboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Bounceable(
          onTap: () {
            if (controller.lastPage == 0) {
              // Get.back();
            } else {
              controller.pageController.previousPage(
                duration: Duration(
                  milliseconds: 100,
                ),
                curve: Curves.easeInOutCubic,
              );
            }
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Color(0XFFd66d75),
          ),
        ),
        actions: [
          Bounceable(
            onTap: () {
              logininfo.put('istutorial', true);

              Get.to(
                () => LoginPage(),
              );
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Skip",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 22.sp,
                    textBaseline: TextBaseline.alphabetic,
                    fontFamily: 'majalla',
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: controller.pageController,
            itemCount: controller.splashInfo.length,
            onPageChanged: (value) {
              controller.update();
              controller.lastPage.value = value;
              controller.pageController.animateToPage(value,
                  duration: Duration(milliseconds: 700),
                  curve: Curves.easeInOutCubic);
            },
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    height: 48.5.h,
                    child: SvgPicture.asset(
                        controller.splashInfo[index]["imageUrl2"]),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 6.w,
                      right: 6.w,
                      top: 2.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 1.5.h,
                        ),
                        CustomText(
                          title: controller.splashInfo[index]['title'],
                          fontsize: 22.sp,
                          fontweight: FontWeight.w700,
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        CustomText(
                          fontweight: FontWeight.w500,
                          fontsize: 18.sp,
                          title: controller.splashInfo[index]['subtitle'],
                        ),
                        SizedBox(
                          height: 3.5.h,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 47.h,
            left: 6.w,
            child: GetBuilder<OnboardingController>(builder: (context) {
              return SmoothPageIndicator(
                controller: controller.pageController,
                count: controller.splashInfo.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 1.2.h,
                  dotWidth: 1.2.h,
                  dotColor: Colors.grey,
                  activeDotColor: Color(0XFFd66d75),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 90.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(
              () {
                return controller.lastPage.value == 2
                    ? FloatingActionButton.extended(
                        backgroundColor: Color(0XFFd66d75),
                        onPressed: () {
                          logininfo.put('istutorial', true);

                          Get.to(
                            () => LoginPage(),
                          );
                        },
                        label: CustomText(
                          title: 'Get Started',
                          fontsize: 20.sp,
                          fontweight: FontWeight.w500,
                          fontcolor: Colors.white,
                        ),
                      )
                    : FloatingActionButton(
                        onPressed: () {
                          if (controller.lastPage.value == 2) {
                            logininfo.put('istutorial', true);
                            Get.to(
                              () => LoginPage(),
                            );
                          } else {
                            controller.pageController.nextPage(
                              duration: Duration(
                                milliseconds: 100,
                              ),
                              curve: Curves.easeInOutCubic,
                            );
                          }
                        },
                        backgroundColor: Color(0XFFd66d75),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                        ),
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}

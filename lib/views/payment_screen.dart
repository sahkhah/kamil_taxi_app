import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxi/views/add_payment_card.dart';
import 'package:taxi/widgets/green_intro_widget_without_logo.dart';

import '../controller/auth_controller.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String cardNumber = '5555 55555 5555 5555';
  String expiryDate = '12/25';
  String cardHolderName = 'Saka Kamil';
  String cvvCode = '123';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AuthController authController = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    //it won't get called unlesss you call it in the initstate
    authController.getUserCard();
    border = OutlineInputBorder(
        borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(children: [
          greenIntroWidgetWithoutLogo(title: 'My Card'),
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            bottom: 80,
            child: Obx(
              (() => ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      String cardNumber = '';
                      String expiryDate = '';
                      String cardHolderName = '';
                      String cvvCode = '';

                      try {
                        cardNumber =
                            authController.userCards.value[index].get('number');
                      } catch (e) {
                        cardNumber = '';
                      }
                      try {
                        expiryDate =
                            authController.userCards.value[index].get('expiry');
                      } catch (e) {
                        expiryDate = '';
                      }
                      try {
                        cardHolderName =
                            authController.userCards.value[index].get('name');
                      } catch (e) {
                        cardHolderName = '';
                      }
                      try {
                        cvvCode =
                            authController.userCards.value[index].get('cvv');
                      } catch (e) {
                        cvvCode = '';
                      }

                      return creditCardWidget(
                          cardBgColor: Colors.black,
                          cardNumber: cardNumber,
                          expiryDate: expiryDate,
                          cardHolderName: cardHolderName,
                          cvvCode: cvvCode,
                          bankName: '',
                          showBackView: isCvvFocused,
                          obscureCardNumber: true,
                          isHolderNameVisible: true,
                          isSwipeGestureEnabled: true,
                          onCreditCardWidgetChange:
                              (CreditCardBrand creditCardBrand) {});
                    }),
                    itemCount: authController.userCards.length,
                  )),
            ),
          ),
          Positioned(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Add new card ',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                onPressed: () {
                  Get.to(() => const AddPaymentCardScreen());
                },
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.green,
                ),
              )
            ],
          ))
        ]),
      ),
    );
  }

  creditCardWidget(
      {required Color cardBgColor,
      required String cardNumber,
      required String expiryDate,
      required cardHolderName,
      required String cvvCode,
      required String bankName,
      required bool showBackView,
      required bool obscureCardNumber,
      required bool isHolderNameVisible,
      required bool isSwipeGestureEnabled,
      required Null Function(dynamic creditCardBrand)
          onCreditCardWidgetChange}) {}
}

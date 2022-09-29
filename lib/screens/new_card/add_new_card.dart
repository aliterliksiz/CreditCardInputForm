import 'package:credit_card_input_form/screens/new_card/components/card_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../contains.dart';
import 'components/card_utils.dart';
import 'components/input_formatters.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({Key? key}) : super(key: key);

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  TextEditingController cardNumberController = TextEditingController();

  CardType cardType = CardType.Invalid;

  void getCardTypeFrmNum() {
    // With in first 6 digits we can identify the type so
    if (cardNumberController.text.length <= 6) {
      String cardNum = CardUtils.getCleanedNumber(cardNumberController.text);
      CardType type = CardUtils.getCardTypeFrmNumber(cardNum);
      if (type != cardType) {
        setState(() {
          cardType = type;
        });
      }
    }
  }

  @override
  void initState() {
    cardNumberController.addListener(
      () {
        getCardTypeFrmNum();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('New Card'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(children: [
            const Spacer(),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: cardNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                      CardNumberInputFormatter()
                    ],
                    decoration: InputDecoration(
                        hintText: 'Card number',
                        suffix: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CardUtils.getCardIcon(cardType),
                        ),
                        prefixIcon: cardType == CardType.Invalid
                            ? null
                            : Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: SvgPicture.asset('assets/icons/card.svg'))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SvgPicture.asset('assets/icons/user.svg'),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(3),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              hintText: 'CVV',
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: SvgPicture.asset('assets/icons/Cvv.svg'),
                              )),
                        ),
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            CardMonthInputFormatter(),
                          ],
                          decoration: InputDecoration(
                              hintText: 'MMYY',
                              prefixIcon: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: SvgPicture.asset('assets/icons/calender.svg'))),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(top: defaultPadding),
              child: OutlinedButton.icon(
                icon: SvgPicture.asset('assets/icons/scan.svg'),
                onPressed: () {},
                label: Text('Scan'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: defaultPadding),
              child: ElevatedButton(onPressed: () {}, child: Text('Add card')),
            )
          ]),
        ),
      ),
    );
  }
}

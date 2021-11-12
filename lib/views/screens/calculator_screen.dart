import 'package:eigital_sample_app/views/components/components.dart';
import 'package:eigital_sample_app/views/res/colours.dart';
import 'package:eigital_sample_app/views/res/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String equation = "";
  double result = 0;
  Parser p = Parser();
  Expression? exp;

  void numPressed(String s) {
    setState(() {
      equation += s;

      if (s == 'AC') {
        equation = "";
        result = 0;
      }
    });
  }

  void equate() {
    if (equation.isEmpty) {
      return;
    }

    String parsedEquation;
    parsedEquation = equation.replaceAll('×', '*');
    parsedEquation = parsedEquation.replaceAll('÷', '/');
    parsedEquation = parsedEquation.replaceAll('−', '-');

    try {
      exp = p.parse(parsedEquation);
      exp!.simplify();
    } on FormatException catch (e) {
      const snackBar = SnackBar(content: Text('Invalid expression'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    ContextModel cm = ContextModel();

    setState(
      () {
        result = exp!.evaluate(EvaluationType.REAL, cm);
        equation = (result.round() == result)
            ? result.toInt().toString()
            : result.toStringAsFixed(3);
      },
    );
  }

  void remove() {
    setState(() {
      equation = equation.isEmpty
          ? equation
          : equation.substring(0, equation.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(child: Container()),
          SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(
                      (result.round() == result)
                          ? '${result.toInt().toString()} ='
                          : '${result.toStringAsFixed(3)} =',
                      textAlign: TextAlign.right,
                      style: kText20TextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            equation,
                            textAlign: TextAlign.right,
                            style: kText30TextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: const Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(
                value: 'AC',
                funct: numPressed,
                isOperator: true,
              ),
              CalcButton(
                isOperator: true,
                value: 'BCK',
                funct: numPressed,
                isIcon: true,
                icon: GestureDetector(
                  child: const Icon(
                    Icons.backspace_outlined,
                    color: kGreyColor,
                  ),
                  onTap: remove,
                ),
              ),
              CalcButton(
                value: '(',
                funct: numPressed,
                isOperator: true,
              ),
              CalcButton(
                value: ')',
                funct: numPressed,
                isOperator: true,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(value: '7', funct: numPressed),
              CalcButton(value: '8', funct: numPressed),
              CalcButton(value: '9', funct: numPressed),
              CalcButton(
                value: '÷',
                funct: numPressed,
                isOperator: true,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(value: '4', funct: numPressed),
              CalcButton(value: '5', funct: numPressed),
              CalcButton(value: '6', funct: numPressed),
              CalcButton(
                value: '×',
                funct: numPressed,
                isOperator: true,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(value: '1', funct: numPressed),
              CalcButton(value: '2', funct: numPressed),
              CalcButton(value: '3', funct: numPressed),
              CalcButton(
                value: '−',
                funct: numPressed,
                isOperator: true,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(value: '.', funct: numPressed),
              CalcButton(value: '0', funct: numPressed),
              CalcButton(
                value: '=',
                funct: equate,
                isOperator: true,
              ),
              CalcButton(
                value: '+',
                funct: numPressed,
                isOperator: true,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

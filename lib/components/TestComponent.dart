import 'package:flutter/material.dart';
import 'package:projetflutterap5/service/FetchDatas.dart';

class TestComponent extends StatefulWidget {
  const TestComponent({super.key});

  @override
  State<TestComponent> createState() => _TestComponentState();
}

class _TestComponentState extends State<TestComponent> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){
          FetchData().testReservationPar(1, true, "AP5", 4, 4);
          },
        child: Text("TestComponent"));
  }
}

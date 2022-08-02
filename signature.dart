import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature/signature.dart'; //signature: ^5.0.1

class PageAssinatura extends StatefulWidget {

  @override
  _PageAssinaturaState createState() => _PageAssinaturaState();
}

class _PageAssinaturaState extends State<PageAssinatura> {

  Size _windowSize = Size(0, 0);
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
  );

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _windowSize = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    ProgressDialog pr = ProgressDialog(context, isDismissible: false, customBody: Controller.getCarregamento());

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(

        body: Column(
          children: [

            SingleChildScrollView(
              child: Column(
                children: [

                  Container(
                    width: _windowSize.width,
                    height: _windowSize.height * 0.81,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.grey.shade200
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [

                        Container(
                          margin: EdgeInsets.only(
                            top: _windowSize.width * 0.2
                          ),
                          width: _windowSize.width * 0.9,
                          height: 3,
                          color: Colors.black38,
                        ),

                        Signature(
                          controller: _controller,
                          height: _windowSize.height * 0.81,
                          backgroundColor: Colors.transparent,
                        ),

                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      top: 20,
                      bottom: 15
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[

                        InkWell(
                          onTap: () {

                            Navigator.pop(context, null);
                          },
                          child: Container(
                            width: 150,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Controller.corLaranja,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            setState(() => _controller.clear());
                          },
                          child: Container(
                            width: 150,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    width: 1,
                                    color: Controller.corLaranja
                                ),
                                color: Colors.white
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Limpar assinatura',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Controller.corLaranja,
                              ),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () async {
                            if (_controller.isNotEmpty) {

                              final Uint8List data = await _controller.toPngBytes();

                              if (data != null) {
                                // print(Image.memory(data));
                                log(base64Encode(data).toString()); //Base64 da imagem PNG sem fundo com a assinatura
                              }
                            }
                          },
                          child: Container(
                            width: 150,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.green,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Finalizar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

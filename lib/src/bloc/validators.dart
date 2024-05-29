// Clase para valdiacioens
import 'dart:async';

mixin Validators {
  // Definimos los String Transformers
  // Ahora vamos a validar el email
  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: ( email, sink ) {
      // Evaluamos con una expresion regular
      String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

      // Creamos la expresion regular segun el patron 
      RegExp regExp = RegExp( pattern );

      if (regExp.hasMatch( email )) {
        sink.add( email );
      } else {
        sink.addError('Email no es correcto');
      }
    }
  );

  // Validamos que la string sea valida
  // Le decimos que informacion fluye, entra y sale
  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: ( password, sink ) {
      if (password.length >= 6) {
        sink.add( password );
      } else {
        sink.addError('Debes escribir mas de 6 caracteres');
      }
    }
  );
}



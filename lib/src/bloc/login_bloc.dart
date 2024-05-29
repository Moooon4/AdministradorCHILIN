// Creamos los string para controlar el correo y la contraseña
import 'dart:async';

import 'package:chilin_administrador/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  // Dos controladores, email y password y privados
  // Los StreamController no son conocidos en rxdart, no trabajan con esos y no existen esos objetos
  // el BehaviorSubject ya tra el broadcast 
  final _emailController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Ocupamos una forma para poder escuchar el string
  // Recuperar los datos del Strem
  Stream<String> get emailStrem    => _emailController.stream.transform( validarEmail );
  Stream<String> get passwordStrem => _passwordController.stream.transform( validarPassword );
  
  // Con la libreria Rxdart vamos a validar si es formulario es valido con un bool
  // mandamos el emailStrem ya validado tambien la pw
  Stream<bool> get formValidStream => 
    Rx.combineLatest2(emailStrem, passwordStrem, (e, p) => true);

  // Getter y Setter
  // Insertar valores al string
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Para obtener el ultimo valor emitido
  // Obtener el ultimo valor ingresado a los streams
  String get email    => _emailController.value;
  String get password => _passwordController.value;


  // Cerramos cuando ya no necesitemos
  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}

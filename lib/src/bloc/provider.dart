// Aqui viene el inheritedWidget
// ignore_for_file: use_key_in_widget_constructors, unnecessary_null_comparison, prefer_conditional_assignment, use_super_parameters
import 'package:flutter/material.dart';
import 'package:chilin_administrador/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget {
  // Propiedad statica
  static Provider? _instancia;

  // Creamos un factory para saber si necesito regresar una instancia de la clase
  // o utilizar la que ya esta existente
  factory Provider({ Key? key, required Widget child }) {
    // Si es igual a null necesitamos crear una nueva instancia
    if( _instancia == null ) {
      // Creamos un constructor privado para prevenir que se pueda inicializar desde afuera
      _instancia = Provider._internal(key: key, child: child);
    }

    return _instancia!;
  }


  // Creamos el constructor privado 
  // Constructor
  Provider._internal({ Key? key, required Widget child })
    : super(key: key, child: child);
      
  final loginBloc = LoginBloc();

  // Sobre escribimos
  // Mas o menos dice que al actualizarse debe notificar a sus hijos
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  // Ocupamos la instancia del LoginBloc
  // Que regrese el estado de esa instancia
  static LoginBloc? of(BuildContext context) {
    final Provider? parentProvider = context.dependOnInheritedWidgetOfExactType<Provider>();
    return parentProvider?.loginBloc;
  }
}

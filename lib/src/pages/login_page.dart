// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_null_aware_operators

import 'package:flutter/material.dart';
// import 'package:chilin_administrador/src/bloc/login_bloc.dart';
import 'package:chilin_administrador/src/bloc/provider.dart';

// ignore: use_key_in_widget_constructors
class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _crearFondo( context ),

          // Que nos permita hacer scroll
          _loginForm( context ),
        ],
      )
    );
  }
  
  Widget _crearFondo( context ) {
    // Obtenemos el 40% de la pantalla
    final size = MediaQuery.of( context ).size;

    final fondoMorado = Container( 
      height: size.height * 0.3,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(59, 53, 53, 1),
            Color.fromRGBO(47, 44, 44, 1),
          ]
        )
      ),
    );

    // Trabajamos los circulos
    final circulos = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );

    return Stack(
      children: [
        fondoMorado,

        Positioned( top: 90, left: 30, child: circulos ),
        Positioned( top: -40, right: -30, child: circulos ),
        Positioned( bottom: -50, right: -10, child: circulos ),   
        Positioned( bottom: 120, right: 20, child: circulos ),  
        Positioned( bottom: -50, left: -20, child: circulos ),   
        
        Container(
          padding: EdgeInsets.only( top: 60 ),
          child: Column(
            children: [
              Icon( Icons.store_outlined, color: Colors.white, size: 100 ),
              SizedBox( height: 10, width: double.infinity, ),
              Text('PUPUSERIA CHILIN', style: TextStyle( color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold ) ),
            ],
          ),
        ),
        
      ],
    );
  }
  
  Widget _loginForm( context ) {
    // La clase creada anteriormente
    // Tenemos acceso a todos los metodos y propiedades que estan definidos en el bloc
    final bloc = Provider.of( context );
    
    final size = MediaQuery.of( context ).size;

    // Me permitira hacer scroll dependiendo el largo que tiene el hijo
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 180,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30),
            padding: EdgeInsets.symmetric(vertical: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, 5),
                  spreadRadius: 3
                )
              ]
            ),
            child: Column(
              children: [
                Text('Ingreso', style: TextStyle( fontSize: 20 ) ),
                SizedBox( height: 60 ),

                // Tanto a Email y Password le vamos a enviar la referencia del Bloc
                _crearEmail( bloc ),
                SizedBox( height: 30 ),
                _crearPassword( bloc ),
                SizedBox( height: 30 ),
                // Se tiene que trabajar la validacion de que si ninguno de los dos inputs de arriba
                // estan validados entonces se tiene que agregar la libreria Rxdart 
                _crearBoton( bloc )
              ],
            ),
          ),
          
          Text('¿Olvidaste la contraseña?'),
          SizedBox( height: 100 )
        ],
      ),
    );
  }
  
  Widget _crearEmail( bloc ) {
    // Vamos a retornar
    // Porque vamos a esuchar todo lo que se escriba para validaciones posteriores
    return StreamBuilder(
      stream: bloc.emailStrem,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon( Icons.alternate_email, color: Colors.deepPurple ),
              hintText: 'ejemplo@correo.com',
              label: Text('Correo electrónico'),
              // Para poner cuantas letras tiene lo que esta escribiendo
              counterText: snapshot.data,
              errorText: snapshot.error != null ? snapshot.error.toString() : null,
            ),

            // Podemos ponernos a escuhar
            onChanged: (value) => bloc.changeEmail( value ),
          ),
        );
      },
    );
  }

  Widget _crearPassword( bloc ) {
    // Vamos a esuchar todo lo que escribe
    return StreamBuilder(
      stream: bloc.passwordStrem,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon( Icons.lock_outline, color: Colors.deepPurple ),
              label: Text('Contraseña'),
              // counterText: snapshot.data,
              errorText: snapshot.error != null ? snapshot.error.toString() : null,
            ),
            // Vamos a estar de meques escuchando los cambios
            onChanged: (value) => bloc.changePassword( value ),
          ),
        );
      },
    );
  }

  Widget _crearBoton( bloc ) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, 
            backgroundColor: Colors.deepPurple, 
            padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.deepPurple),
            ),
            // elevation: 0,
          ),
          child: Text('Ingresar'),
        );    
      },
    );
  }

  // Creamos un metodo privado para obtener los valores
  // no los del input si no los valores ya validados
  _login( bloc , context) {
    // necesitamos imprimir cual es el valor del email y el password
    // print('Email:  ${ bloc.email }');
    // print('Password: ${ bloc.password } ');

    // Navegamos a la otra pagina
    // Navigator.pushNamed( context, 'home'); // Con esto nos va a poner el boton de back, tenemos que usar:
    Navigator.pushReplacementNamed( context, 'home');
  }
}
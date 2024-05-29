// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:chilin_administrador/src/models/pedido_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PedidosPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos pendientes'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () { },
            child: Text(
              'Pedidos finalizados',
              style: TextStyle(
                // Color del texto
                color: Colors.white, 
                // Estilo del texto (negrita)
                fontWeight: FontWeight.bold, 
                // Tamaño del texto
                fontSize: 14, 
              ),
            ),
          ),

          SizedBox(width: 10)
        ],
      ),

      body: _crearListado(),
    );
  }

  // Listamos la informacion desde base de datos
  Widget _crearListado() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('Usuarios').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      // Validación por si tiene los datos cargados o no
      if (snapshot.hasData) {
        final pedidos = snapshot.data!.docs.map((doc) async {
          final usuario = PedidoModel(
            idCliente : doc.id,
            nombre    : doc['nombre'],
            apellido  : doc['apellido'],
            fotoPerfil: doc['fotoPerfil'],
            telefono  : doc['numeroTelefono'],
          );

          final ordenesSnapshot = await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(usuario.idCliente)
            .collection('Ordenes')
            .get();

        ordenesSnapshot.docs.forEach((orden) {
          usuario.idOrden = orden.id;
          usuario.fechaOrden = orden['fechaOrden'];
          usuario.metodoPago = orden['metodoPago'];
          usuario.montoTotal = orden['montoTotal'];
          usuario.estado = orden['estado'];
        });

          // print(usuario.idOrden);
          return usuario;
        });

        return FutureBuilder<List<PedidoModel>>(
          future: Future.wait(pedidos),
          builder: (BuildContext context, AsyncSnapshot<List<PedidoModel>> pedidosSnapshot) {
            if (pedidosSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (pedidosSnapshot.hasError) {
              return Center(child: Text('Error: ${pedidosSnapshot.error}'));
            }
            return ListView.builder(
              itemCount: pedidosSnapshot.data!.length,
              itemBuilder: (context, i) => _crearItem(context, pedidosSnapshot.data![i]),
            );
          },
        );
      } else if (snapshot.hasError) {
        // Retornar un widget de error si ocurre un error en el stream
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        // Retornamos un indicador de carga mientras se obtienen los datos
        return Center(child: CircularProgressIndicator());
      }
    },
  );
  }

  // Creamos el listado de los datos
  Widget _crearItem( context, PedidoModel pedido) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.only(left: 30, bottom: 20, right: 30),
      child: ListTile(
        onTap: () {
          // Navigator.pushNamed(context, 'producto', arguments: producto);
        },
        title: Container(
          padding: EdgeInsets.all(0),
          height: 100, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  pedido.fotoPerfil.isEmpty
                    ? Icon(Icons.account_circle_sharp, size: 30)
                    : CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(pedido.fotoPerfil),
                      ),
                  SizedBox(width: 5),
                  Text(
                    '${pedido.nombre.toUpperCase()} ${pedido.apellido.toUpperCase()}',
                    style: TextStyle( fontWeight: FontWeight.bold,  ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total de productos: 00'),
                        Row(
                          children: [
                            Text('Estado del pedido: En espera '),
                            Icon( Icons.circle_rounded, size: 25.0, color: Colors.red ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text( '\$${pedido.montoTotal.toStringAsFixed(2)}', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 40.0 )),
                      ]
                     )
                  ),
                ],
              ),

            ],
          ),
        ),

      ),
    );
  }

}
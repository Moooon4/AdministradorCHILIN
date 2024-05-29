// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:chilin_administrador/src/models/producto_model.dart';
import 'package:chilin_administrador/src/providers/productos_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:chilin_administrador/src/bloc/provider.dart';

class HomePage extends StatelessWidget {

  // El provider donde se maneja la informacion a base de datos
  final productosProvider = ProductosProvider();

  @override
  Widget build(BuildContext context) {
    // La clase creada anteriormente
    // Tenemos acceso a todos los metodos y propiedades que estan definidos en el bloc
    // final bloc = Provider.of( context );

    return Scaffold(
      appBar:AppBar(
        /*
        leading: Icon(Icons.home_rounded),
        title: Text('Hola, Fernando'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Image.asset(
              'assets/chilin.png',
              width: 130.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
        */
        title: Row(
          children: [
            Image.asset('assets/chilin.png', scale: 4,),
            const SizedBox(
              width: 10.0,
            ),
            const Text(
              '| ',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25, color: Colors.black),
            ),
            const Text(
              'Hola, Fernando',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25, color: Color.fromARGB(250, 220, 165, 50),)/*
              shadows: [Shadow(color: Colors.grey, offset: Offset(2, 2), blurRadius: 1,)]),*/
            )
          ],
        ),
      ),

      // Text('Email: ${ bloc?.email } '),
      // Divider(),
      // Text('Password: ${ bloc?.password }')
  
      body: _crearListado(),

      // Boto para crear un nuevo producto
      floatingActionButton: _crearBoton( context ),
    );
  }

  // Listamos la informacion desde base de datos
  Widget _crearListado() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Productos').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Validación por si tiene los datos cargados o no
        if (snapshot.hasData) {
          final productos = snapshot.data!.docs.map((doc) => ProductoModel(
            id             : doc.id,
            descripcion    : doc['descripcion'],
            estado         : doc['estado'],
            idCategoria    : doc['idCategoria'],
            imagen         : doc['imagen'],
            isFeatured     : doc['isFeatured'],
            nombre         : doc['nombre'],
            nombreCategoria: doc['nombreCategoria'],
            precio         : doc['precio'],
            tipoProducto   : doc['tipoProducto'],
          )).toList();

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem(context, productos[i]),
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

  // Creamos los items individuales 
  Widget _crearItem( context, ProductoModel producto ) {
    // el Dismissible lo agregamos para eliminar algun producto
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(Icons.delete, color: Colors.white, size: 25), // Icono a la izquierda
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.delete, color: Colors.white, size: 25), // Icono a la derecha
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        // Aqui vamos a borrar el items
        productosProvider.borrarProducto( producto.id );
      },

      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.only(left: 20, bottom: 20, right: 20),
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, 'producto', arguments: producto);
          },
          title: Container(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*
                  Expanded (
                    flex: 1, // La imagen ocupa el 50% del ancho
                    child: FadeInImage(
                      fadeInDuration: Duration( milliseconds: 200),
                      height: 180,
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/preloader.gif'),
                      image: NetworkImage(producto.imagen),
                      
                    ),
                  ),
                  */
                  Expanded (
                    flex: 1, // La imagen ocupa el 50% del ancho
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.transparent, // Color del borde
                          width: 2.0, // Ancho del borde
                        ),
                        borderRadius: BorderRadius.circular(25.0), // Bordes redondeados
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18.0), // Bordes redondeados para la imagen
                        child: FadeInImage(
                          fadeInDuration: Duration(milliseconds: 200),
                          height: 180,
                          width: double.infinity, // Para asegurar que la imagen ocupe todo el ancho disponible
                          fit: BoxFit.cover,
                          placeholder: AssetImage('assets/preloader.gif'),
                          image: NetworkImage(producto.imagen),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/error_image.png'); // Imagen de error si la carga falla
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    flex: 1, // El texto ocupa el 50% del ancho
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titulo
                        Center(
                          child: Text(
                            producto.nombre,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
            
                        // Vamos dejando un espacio
                        SizedBox(height: 8),
            
                        // Categoria y Precio
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Widget para la categoría con un icono y texto
                            Row(
                              children: [
                                Icon(Icons.restaurant_menu, size: 15.0, color: Colors.blueGrey),
                                SizedBox(width: 2),
                                Text(
                                  producto.nombreCategoria,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                            // Widget para el precio
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '\$${producto.precio.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 75, 129, 77),
                                ),
                              ),
                            ),
                          ],
                        ),
            
                        // Descripcion
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0), // Redondea los bordes del Container
                            color: Colors.white, // Color de fondo del Container
                          ),
                          padding: EdgeInsets.all(9.0),
                          constraints: BoxConstraints(minHeight: 110,),
                          child:
                          Text(
                            producto.descripcion,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
            
                        // Disponible y Destacado
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Disponible:',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                SizedBox(width: 3),
            
                                if (producto.estado == 'Disponible')
                                Container(
                                  child: Icon( Icons.circle_rounded, size: 10.0, color: Colors.green ),
                                )
                                else
                                Container(
                                  child: Icon( Icons.circle_outlined, size: 10.0, color: Colors.red ),
                                ),
                              ],
                            ),
                            // Widget para el destacado
                            Row(
                              children: [
                                Text(
                                  'Destacado:',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                SizedBox(width: 3),
            
                                if (producto.isFeatured == true)
                                Container(
                                  child: Icon( Icons.star, size: 10.0, color: Colors.green ),
                                )
                                else
                                Container(
                                  child: Icon( Icons.star_border, size: 10.0, color: Colors.green ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearBoton( context ) {
    return Container(
      margin: EdgeInsets.only(left: 30),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, 'pedidos'),
              child: Icon(Icons.assignment_returned_rounded),
              // Cambiamos el color a la aplicacion
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
              heroTag: "Pedidos",
            ),
            FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, 'producto'),
              child: Icon(Icons.add),
              // Cambiamos el color a la aplicacion
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              heroTag: "Agregar",
            ),
          ]
      ),
    );
  }

//  Widget _crearBoton(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(left: 30),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           FloatingActionButton(
//             child: Icon(Icons.edit),
//             backgroundColor: Colors.red,
//             foregroundColor: Colors.white,
//             onPressed: () {
//               // Lógica para el segundo botón (editar) aquí
//             },
//           ),
//           FloatingActionButton(
//             child: Icon(Icons.add),
//             // Cambiamos el color a la aplicacio
//             backgroundColor: Colors.black,
//             foregroundColor: Colors.white,
//             onPressed: () => Navigator.pushNamed(context, 'producto'),
//           ),
//         ],
//       ),
//     );
//   }



}
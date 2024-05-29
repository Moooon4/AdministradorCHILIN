// Este archivo se va a encargar de hacer todas las interacciones en la base de datos
// ignore_for_file: avoid_print, unnecessary_null_comparison, unused_local_variable, avoid_function_literals_in_foreach_calls, unused_import, unused_field, unrelated_type_equality_checks
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:chilin_administrador/src/models/pedido_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PedidosProvider {

  // Future<List<PedidoModel>> cargarPedidos() async {
  //   try {
  //     // Accedemos a la colección "Productos"
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Productos').get();

  //     // Lista para almacenar los productos
  //     List<PedidoModel> productos = [];

  //     // Iteramos sobre los documentos obtenidos
  //     querySnapshot.docs.forEach((doc) {
  //       // Convertimos cada documento a un objeto ProductoModel
  //       PedidoModel producto = PedidoModel(
  //         id: doc.id, // Aquí asignamos el ID del documento
  //         descripcion    : doc['descripcion'],
  //         estado         : doc['estado'],
  //         idCategoria    : doc['idCategoria'],
  //         imagen         : doc['imagen'],
  //         isFeatured     : doc['isFeatured'],
  //         nombre         : doc['nombre'],
  //         nombreCategoria: doc['nombreCategoria'],
  //         precio         : doc['precio'],
  //         tipoProducto   : doc['tipoProducto'],
  //       );

  //       // Agregamos el producto a la lista
  //       productos.add(producto);
  //     });

  //     return productos;
  //   } catch (e) {
  //     // Manejo de errores
  //     print("Error al cargar productos: $e");
  //     return []; // Retorna una lista vacía en caso de error
  //   }
  // }
}
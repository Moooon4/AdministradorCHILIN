// Este archivo se va a encargar de hacer todas las interacciones en la base de datos
// ignore_for_file: avoid_print, unnecessary_null_comparison, unused_local_variable, avoid_function_literals_in_foreach_calls, unused_import, unused_field, unrelated_type_equality_checks
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:chilin_administrador/src/models/producto_model.dart';
// importamos http
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductosProvider {
  // Como necesitamos hacer peticiones HTTP exportamos el paquete en el pubspec.yaml

  // Url de la base de datos de firabase
  final String _url = 'https://pupuseria-chilin-default-rtdb.firebaseio.com';
  
  // Future para subir las imagenes con todo 
  Future<String> subirImagen(File imagen, String idCategoria) async {
    try {
      // Obtener el nombre real del archivo
      String fileName = imagen.path.split('/').last;

      // Determinar la ruta de almacenamiento basada en idCategoria
      String folderPath;
      switch (idCategoria) {
        case '1':
        case '2':
          folderPath = 'Productos/Imagenes/Pupusas';
          break;
        case '3':
          folderPath = 'Productos/Imagenes/Postres';
          break;
        case '4':
          folderPath = 'Productos/Imagenes/Bebidas Heladas';
          break;
        default:
          // Ruta por defecto si no coincide con ningún idCategoria
          folderPath = 'Productos/Imagenes/Pupusas'; 
      }

      // Crear una referencia a la ubicación donde se almacenará la imagen
      Reference storageReference = FirebaseStorage.instance.ref().child('$folderPath/$fileName');

      // Subir la imagen
      UploadTask uploadTask     = storageReference.putFile(imagen);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Obtener la URL de la imagen subida
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      print("Error al subir la imagen: $e");
      return '';
    }
  }

  // Agregamos un producto a la base de datos
  Future<bool> crearProducto(ProductoModel producto, File? imagen) async {
    try {
      // Subir la imagen y obtener la URL si existe una imagen
      if (imagen != null) {
        producto.imagen = await subirImagen(imagen, producto.idCategoria);
      }

      // Referencia a la colección "Productos" en Firestore
      CollectionReference productosRef = FirebaseFirestore.instance.collection('Productos');

      // Validar el tipo de producto y los atributos según la categoría
      String? tipoProducto;
      List<Map<String, dynamic>>? attributosProducto;

      if (producto.idCategoria == '1' || producto.idCategoria == '2') {
        // Para categoría 1 o 2
        tipoProducto = 'ProductType.variable';

        // Agregar atributos adicionales si es necesario
        attributosProducto = [
          {
            'nombre': 'Tipo de Masa',
            'valor': ['Arroz', 'Maiz']
          }
        ];
      } else if (producto.idCategoria == '3' || producto.idCategoria == '4') {
        // Para categoría 3 o 4
        tipoProducto = 'ProductType.single';

        // No es necesario agregar atributos adicionales
        attributosProducto = null;
      }

      // Agregamos un nuevo documento con los datos del producto
      await productosRef.add({
        'descripcion'    : producto.descripcion,
        'estado'         : producto.estado,
        'idCategoria'    : producto.idCategoria,
        'imagen'         : producto.imagen,
        'isFeatured'     : producto.isFeatured,
        'nombre'         : producto.nombre,
        'nombreCategoria': producto.nombreCategoria,
        'precio'         : producto.precio,
        'tipoProducto'   : tipoProducto,

        // Agregar atributos del producto si existen
        if (attributosProducto != null) 'attributosProducto': attributosProducto
      });

      return true;
    } catch (e) {
      // Manejo de errores
      print("Error al crear el producto: $e");
      return false;
    }
  }

  // Editamos un producto
  Future<bool> editarProducto(ProductoModel producto) async {
    try {
      // Referencia al documento que queremos editar
      DocumentReference productoRef = FirebaseFirestore.instance.collection('Productos').doc(producto.id);

      // Actualizamos los campos que deseamos modificar
      await productoRef.update({
        'descripcion'    : producto.descripcion,
        'estado'         : producto.estado,
        'idCategoria'    : producto.idCategoria,
        'isFeatured'     : producto.isFeatured,
        'nombre'         : producto.nombre,
        'nombreCategoria': producto.nombreCategoria,
        'precio'         : producto.precio,
        'tipoProducto'   : producto.tipoProducto
      });

      return true;
    } catch (e) {
      // Manejo de errores
      print("Error al editar el producto: $e");
      return false;
    }
  }

  Future<List<ProductoModel>> cargarProductos() async {
    try {
      // Accedemos a la colección "Productos"
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Productos').get();

      // Lista para almacenar los productos
      List<ProductoModel> productos = [];

      // Iteramos sobre los documentos obtenidos
      querySnapshot.docs.forEach((doc) {
        // Convertimos cada documento a un objeto ProductoModel
        ProductoModel producto = ProductoModel(
          id: doc.id, // Aquí asignamos el ID del documento
          descripcion    : doc['descripcion'],
          estado         : doc['estado'],
          idCategoria    : doc['idCategoria'],
          imagen         : doc['imagen'],
          isFeatured     : doc['isFeatured'],
          nombre         : doc['nombre'],
          nombreCategoria: doc['nombreCategoria'],
          precio         : doc['precio'],
          tipoProducto   : doc['tipoProducto'],
        );

        // Agregamos el producto a la lista
        productos.add(producto);
      });

      return productos;
    } catch (e) {
      // Manejo de errores
      print("Error al cargar productos: $e");
      return []; // Retorna una lista vacía en caso de error
    }
  }
  
  // Vamos a borrar un item aqui
  Future<int> borrarProducto(String id) async {
    // // Necesitamos la url para el listado de los productos
    // final url = '$_url/productos/$id.json';

    // // Cargamos la peticion
    // final resp = await http.delete( Uri.parse(url) );

    try {
      // Referencia al documento que queremos eliminar
      DocumentReference productoRef = FirebaseFirestore.instance.collection('Productos').doc(id);

      // Eliminamos el documento 
      await productoRef.delete();

      return 1; // Éxito al borrar el producto
    } catch (e) {
      // Manejo de errores
      print("Error al borrar el producto: $e");
      return 0; // Error al borrar el producto
    }
  }

}
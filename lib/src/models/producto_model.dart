// ignore_for_file: unnecessary_new
import 'dart:convert';

ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  // Propiedades
  String id;
  String descripcion;
  String estado;
  String idCategoria;
  String imagen;
  bool isFeatured;
  String nombre;
  String nombreCategoria;
  num precio;
  String tipoProducto;

  // Constructor
  ProductoModel({
    this.id              = '',
    this.descripcion     = '',
    this.estado          = '',
    this.idCategoria     = '',
    this.imagen          = '',
    this.isFeatured      = false,
    this.nombre          = '',
    this.nombreCategoria = '',
    this.precio          = 0.0,
    this.tipoProducto    = '',
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
    id             : json["id"],
    descripcion    : json["descripcion"],
    estado         : json["estado"],
    idCategoria    : json["idCategoria"],
    imagen         : json["imagen"],
    isFeatured     : json["isFeatured"],
    nombre         : json["nombre"],
    nombreCategoria: json["nombreCategoria"],
    precio         : json["precio"],
    tipoProducto   : json["tipoProducto"],
  );

  Map<String, dynamic> toMap() {
    return {
      "id"             : id,
      "descripcion"    : descripcion,
      "estado"         : estado,
      "idCategoria"    : idCategoria,
      "imagen"         : imagen,
      "isFeatured"     : isFeatured,
      "nombre"         : nombre,
      "nombreCategoria": nombreCategoria,
      "precio"         : precio,
      "tipoProducto": tipoProducto,
    };
  }

  Map<String, dynamic> toJson() => {
    "id"             : id,
    "descripcion"    : descripcion,
    "estado"         : estado,
    "idCategoria"    : idCategoria,
    "imagen"         : imagen,
    "isFeatured"     : isFeatured,
    "nombre"         : nombre,
    "nombreCategoria": nombreCategoria,
    "precio"         : precio,
    "tipoProducto"   : tipoProducto,
  };
}

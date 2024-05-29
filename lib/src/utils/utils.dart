// Hacemos la funcion para determinar si es un numero
bool isNumeric( String s ) {
  // Validamos si esta vacio
  if ( s.isEmpty ) return false;

  // Se puede parsear?
  final n = num.tryParse( s );
  return ( n == null ) ? false : true;
}
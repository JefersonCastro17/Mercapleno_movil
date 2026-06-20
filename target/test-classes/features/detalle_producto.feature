# language: es
Característica: Visualización del Detalle de Producto en Mercapleno

  Escenario: Validar los detalles de un producto en el catalogo
    Dado que el usuario inicia sesion con correo "pablo@gmail.com" y contrasena "123456"
    Cuando el usuario observa el producto "Pan Bimbo" en el catalogo
    Entonces deberia validar que el precio del producto "Pan Bimbo" sea visible en la tarjeta

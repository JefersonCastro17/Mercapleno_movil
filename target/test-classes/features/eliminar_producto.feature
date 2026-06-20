# language: es
Característica: Eliminar Producto del Carrito en Mercapleno

  Escenario: Eliminar un producto agregado al carrito
    Dado que el usuario inicia sesion con correo "pablo@gmail.com" y contrasena "123456"
    Cuando el usuario agrega el producto "Pan Bimbo" al carrito
    Y decide eliminar el producto "Pan Bimbo" del carrito
    Entonces el usuario deberia ver que su carrito esta vacio con el mensaje "Tu carrito esta vacio"

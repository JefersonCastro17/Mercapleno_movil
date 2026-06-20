# language: es
Característica: Gestion del Carrito de Compras en Mercapleno

  Escenario: Compra exitosa de un producto
    Dado que el usuario inicia sesion con correo "pablo@gmail.com" y contrasena "123456"
    Cuando el usuario agrega el producto "Pan Bimbo" al carrito
    Y el usuario procede a pagar seleccionando el metodo "Efectivo"
    Entonces el usuario deberia ver el ticket de compra con el mensaje "Ticket de Compra Electronico"
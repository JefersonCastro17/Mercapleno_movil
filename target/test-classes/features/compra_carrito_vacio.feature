# language: es
Característica: Intentar comprar con carrito vacío en Mercapleno

Escenario: Visualizar carrito vacío sin productos agregados

Dado que el usuario inicia sesion con correo "pablo@gmail.com" y contrasena "123456"
Cuando el usuario ingresa al carrito de compras
Entonces el usuario deberia ver que su carrito esta vacio con el mensaje "Tu carrito esta vacio"


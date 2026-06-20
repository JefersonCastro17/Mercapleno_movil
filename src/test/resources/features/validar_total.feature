# language: es
Característica: Validar Total de Compra en Mercapleno

  Escenario: Validar que el total calculado en el carrito coincida con el esperado
    Dado que el usuario inicia sesion con correo "pablo@gmail.com" y contrasena "123456"
    Cuando el usuario agrega el producto "Pan Bimbo" al carrito
    Y el usuario agrega el producto "Ariel" al carrito
    Entonces el total mostrado en el carrito deberia ser la suma de sus precios mas impuestos

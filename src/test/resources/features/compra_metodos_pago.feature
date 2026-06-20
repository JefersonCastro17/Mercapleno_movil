# language: es

@compra_metodos_pago
Característica: Compra con distintos métodos de pago en Mercapleno

Esquema del escenario: Compra exitosa usando diferentes medios de pago


Dado que el usuario inicia sesion con correo "pablo@gmail.com" y contrasena "123456"
Cuando el usuario agrega el producto "Pan Bimbo" al carrito
Y el usuario procede a pagar seleccionando el metodo "<metodo>"
Entonces el usuario deberia ver el ticket de compra con el mensaje "Ticket de Compra Electronico"

Ejemplos:
  | metodo   |
  | Efectivo |
  | Tarjeta  |
  | Yape     |
  | Plin     |

# language: es
Característica: Inicio de Sesión en Mercapleno

Escenario: Inicio de sesión exitoso como Cliente
Dado que el usuario abre la pagina de Mercapleno
Cuando ingresa su correo "pablo@gmail.com" y contrasena "123456"
Entonces el usuario deberia ver el catalogo de productos con el titulo "Productos disponibles"

Escenario: Inicio de sesión fallido con credenciales incorrectas
Dado que el usuario abre la pagina de Mercapleno
Cuando ingresa su correo "pablo@gmail.com" y contrasena "clave_incorrecta"
Entonces deberia ver una alerta con el mensaje "Contrasena incorrecta"

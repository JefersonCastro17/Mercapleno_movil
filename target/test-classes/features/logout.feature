# language: es
Característica: Cierre de Sesión en Mercapleno

  Escenario: Cierre de sesión exitoso y retorno al login
    Dado que el usuario inicia sesion con correo "pablo@gmail.com" y contrasena "123456"
    Cuando el usuario decide cerrar sesion
    Entonces deberia retornar a la pantalla de inicio de sesion

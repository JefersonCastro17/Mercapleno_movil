# language: es
Característica: Búsqueda de Productos en Mercapleno

  Escenario: Buscar un producto por su nombre en el catalogo
    Dado que el usuario inicia sesion con correo "pablo@gmail.com" y contrasena "123456"
    Cuando el usuario busca el producto con el nombre "Pan Bimbo"
    Entonces el producto "Pan Bimbo" deberia aparecer en los resultados del catalogo

package com.mercapleno.userinterfaces;

import net.serenitybdd.screenplay.targets.Target;
import org.openqa.selenium.By;

public class CatalogoPage {
    public static final Target TITULO_PRODUCTOS = Target.the("titulo de la pagina de productos")
            .located(By.xpath("//div[contains(@class, 'catalog-title')]/h2"));

    public static final Target BOTON_AGREGAR_AL_CARRITO = Target.the("boton agregar al carrito del producto {0}")
            .locatedBy("//*[contains(@class, 'producto') and contains(@data-name, '{0}')]//button[contains(@class, 'botoncito_producto')]");

    public static final Target BOTON_CARRITO_HEADER = Target.the("boton de ir al carrito en el header")
            .located(By.xpath("//header//button[contains(text(), 'Carrito')]"));

    public static final Target BOTON_CATALOGO_HEADER = Target.the("boton de ir al catalogo en el header")
            .located(By.xpath("//header//button[contains(text(), 'Catálogo')]"));

    public static final Target BOTON_CERRAR_SESION = Target.the("boton de cerrar sesion")
            .located(By.xpath("//button[contains(text(), 'Cerrar Sesión')]"));

    public static final Target INPUT_BUSQUEDA = Target.the("campo de busqueda de productos")
            .located(By.id("nombre"));

    public static final Target SELECT_CATEGORIA = Target.the("selector de categoria de productos")
            .located(By.id("categoria"));

    public static final Target INPUT_PRECIO_MIN = Target.the("campo de precio minimo")
            .located(By.id("precioMin"));

    public static final Target INPUT_PRECIO_MAX = Target.the("campo de precio maximo")
            .located(By.id("precioMax"));

    public static final Target BOTON_LIMPIAR_FILTROS = Target.the("boton limpiar filtros")
            .located(By.id("limpiar"));

    public static final Target NOMBRE_PRODUCTO = Target.the("nombre del producto {0}")
            .locatedBy("//*[contains(@class, 'producto') and contains(@data-name, '{0}')]//*[contains(@class, 'nombre')]");

    public static final Target PRECIO_PRODUCTO = Target.the("precio del producto {0}")
            .locatedBy("//*[contains(@class, 'producto') and contains(@data-name, '{0}')]//*[contains(@class, 'precio')]");

    public static final Target TARJETAS_PRODUCTO = Target.the("lista de tarjetas de producto")
            .located(By.className("producto"));
}

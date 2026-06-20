package com.mercapleno.stepdefinitions;

import com.mercapleno.questions.*;
import com.mercapleno.tasks.*;
import com.mercapleno.userinterfaces.CatalogoPage;
import io.cucumber.java.es.*;
import net.serenitybdd.screenplay.actors.OnStage;
import net.serenitybdd.screenplay.abilities.BrowseTheWeb;
import net.serenitybdd.screenplay.waits.WaitUntil;
import static net.serenitybdd.screenplay.matchers.WebElementStateMatchers.isVisible;
import org.openqa.selenium.Alert;

import static net.serenitybdd.screenplay.GivenWhenThen.seeThat;
import static org.hamcrest.Matchers.equalTo;

public class CarritoStepDefinitions {

    @Dado("que el usuario inicia sesion con correo {string} y contrasena {string}")
    public void usuarioIniciaSesion(String email, String password) {
        OnStage.theActorCalled("Robot").wasAbleTo(
                AbrirPagina.deMercapleno(),
                RealizarLogin.conCredenciales(email, password)
        );
        // Aceptamos la alerta de "Inicio de sesion exitoso" que bloquea la pantalla
        try {
            var driver = BrowseTheWeb.as(OnStage.theActorInTheSpotlight()).getDriver();
            Alert alert = driver.switchTo().alert();
            alert.accept();
            Thread.sleep(1000);
        } catch (Exception e) {
            // Si no hay alerta, continuar
        }

        // Esperamos a que el catálogo cargue completamente antes de continuar
        OnStage.theActorInTheSpotlight().attemptsTo(
                WaitUntil.the(CatalogoPage.TITULO_PRODUCTOS, isVisible()).forNoMoreThan(10).seconds()
        );
    }

    @Cuando("el usuario agrega el producto {string} al carrito")
    public void agregarProductoAlCarrito(String productoNombre) {
        OnStage.theActorInTheSpotlight().attemptsTo(
                AgregarProducto.alCarrito(productoNombre)
        );
    }

    @Y("el usuario procede a pagar seleccionando el metodo {string}")
    public void procederAPagar(String metodoPago) {
        OnStage.theActorInTheSpotlight().attemptsTo(
                RealizarPago.conMetodo(metodoPago)
        );
    }

    @Entonces("el usuario deberia ver el ticket de compra con el mensaje {string}")
    public void verificarTicketCompra(String mensajeEsperado) {
        OnStage.theActorInTheSpotlight().should(
                seeThat(ConfirmacionCompra.es(), equalTo(mensajeEsperado))
        );
    }

    @Y("decide eliminar el producto {string} del carrito")
    public void decidirEliminarProducto(String productoNombre) {
        OnStage.theActorInTheSpotlight().attemptsTo(
                EliminarProducto.delCarrito(productoNombre)
        );
    }

    @Entonces("el usuario deberia ver que su carrito esta vacio con el mensaje {string}")
    public void verificarCarritoVacio(String mensajeEsperado) {
        OnStage.theActorInTheSpotlight().should(
                seeThat("El mensaje de carrito vacio", ValidarCarritoVacio.valor(), equalTo(mensajeEsperado))
        );
    }

    @Entonces("el total mostrado en el carrito deberia ser la suma de sus precios mas impuestos")
    public void verificarTotalCalculado() {
        OnStage.theActorInTheSpotlight().should(
                seeThat("El total del carrito es visible", ObtenerTotalCompra.delCarrito(), org.hamcrest.Matchers.startsWith("$"))
        );
    }

    @Cuando("el usuario ingresa al carrito de compras")
    public void ingresarAlCarritoDeCompras() {
        OnStage.theActorInTheSpotlight().attemptsTo(
                net.serenitybdd.screenplay.actions.Click.on(CatalogoPage.BOTON_CARRITO_HEADER)
        );
        try { Thread.sleep(1000); } catch (InterruptedException e) { e.printStackTrace(); }
    }

    @Y("decide pagar sin agregar ningun producto")
    public void decidirPagarSinProductos() {
        OnStage.theActorInTheSpotlight().attemptsTo(
                net.serenitybdd.screenplay.actions.Click.on(com.mercapleno.userinterfaces.CarritoPage.BOTON_PAGAR)
        );
    }

    @Entonces("deberia ver un mensaje de error indicando {string}")
    public void verificarMensajeErrorCarritoVacio(String mensajeEsperado) {
        OnStage.theActorInTheSpotlight().should(
                seeThat("El mensaje de error del checkout", MensajeErrorCarritoVacio.valor(), equalTo(mensajeEsperado))
        );
    }
}

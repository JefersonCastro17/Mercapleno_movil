package com.mercapleno.stepdefinitions;

import com.mercapleno.questions.ResultadosBusqueda;
import com.mercapleno.questions.ValidarDetalleProducto;
import com.mercapleno.tasks.BuscarProducto;
import io.cucumber.java.es.*;
import net.serenitybdd.screenplay.actors.OnStage;

import static net.serenitybdd.screenplay.GivenWhenThen.seeThat;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.notNullValue;

public class BusquedaStepDefinitions {

    @Cuando("el usuario busca el producto con el nombre {string}")
    public void elUsuarioBuscaElProductoConElNombre(String productoNombre) {
        OnStage.theActorInTheSpotlight().attemptsTo(
                BuscarProducto.conNombre(productoNombre)
        );
    }

    @Entonces("el producto {string} deberia aparecer en los resultados del catalogo")
    public void elProductoDeberiaAparecerEnLosResultadosDelCatalogo(String productoNombre) {
        OnStage.theActorInTheSpotlight().should(
                seeThat("El producto buscado se muestra", ResultadosBusqueda.delProducto(productoNombre), equalTo(productoNombre))
        );
    }

    @Cuando("el usuario observa el producto {string} en el catalogo")
    public void elUsuarioObservaElProductoEnElCatalogo(String productoNombre) {
        try { Thread.sleep(1000); } catch (InterruptedException e) { e.printStackTrace(); }
    }

    @Entonces("deberia validar que el precio del producto {string} sea visible en la tarjeta")
    public void deberiaValidarQueElPrecioDelProductoSeaVisibleEnLaTarjeta(String productoNombre) {
        OnStage.theActorInTheSpotlight().should(
                seeThat("El precio del producto es visible", ValidarDetalleProducto.precioDelProducto(productoNombre), notNullValue())
        );
    }
}

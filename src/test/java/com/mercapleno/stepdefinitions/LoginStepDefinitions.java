package com.mercapleno.stepdefinitions;

import com.mercapleno.questions.*;
import com.mercapleno.tasks.*;
import com.mercapleno.userinterfaces.CatalogoPage;
import io.cucumber.java.Before;
import io.cucumber.java.es.*;
import net.serenitybdd.screenplay.actors.OnStage;
import net.serenitybdd.screenplay.actors.OnlineCast;
import net.serenitybdd.screenplay.abilities.BrowseTheWeb;
import net.serenitybdd.screenplay.waits.WaitUntil;
import static net.serenitybdd.screenplay.matchers.WebElementStateMatchers.isVisible;
import org.openqa.selenium.Alert;

import static net.serenitybdd.screenplay.GivenWhenThen.seeThat;
import static org.hamcrest.Matchers.equalTo;

public class LoginStepDefinitions {

    @Before
    public void prepararEscenario() {
        OnStage.setTheStage(new OnlineCast());
    }

    @Dado("que el usuario abre la pagina de Mercapleno")
    public void abrirPaginaMercapleno() {
        OnStage.theActorCalled("Robot").wasAbleTo(AbrirPagina.deMercapleno());
    }

    @Cuando("ingresa su correo {string} y contrasena {string}")
    public void ingresarCredenciales(String email, String password) {
        OnStage.theActorInTheSpotlight().attemptsTo(
                RealizarLogin.conCredenciales(email, password)
        );
    }

    @Entonces("el usuario deberia ver el catalogo de productos con el titulo {string}")
    public void verificarCatalogoProductos(String tituloEsperado) {
        // Aceptamos la alerta de "Inicio de sesion exitoso" que bloquea la pantalla
        try {
            var driver = BrowseTheWeb.as(OnStage.theActorInTheSpotlight()).getDriver();
            Alert alert = driver.switchTo().alert();
            alert.accept();
            Thread.sleep(1000);
        } catch (Exception e) {
            // Si no hay alerta, continuar
        }
        
        // Esperamos a que el título del catálogo sea visible
        OnStage.theActorInTheSpotlight().attemptsTo(
                WaitUntil.the(CatalogoPage.TITULO_PRODUCTOS, isVisible()).forNoMoreThan(10).seconds()
        );

        OnStage.theActorInTheSpotlight().should(
                seeThat(ValidarLoginExitoso.valor(), equalTo(tituloEsperado))
        );
    }

    @Entonces("deberia ver una alerta con el mensaje {string}")
    public void verificarMensajeAlerta(String mensajeAlertaEsperado) {
        OnStage.theActorInTheSpotlight().should(
                seeThat("El mensaje de la alerta javascript", ValidarMensajeAlerta.valor(), equalTo(mensajeAlertaEsperado))
        );
    }
}

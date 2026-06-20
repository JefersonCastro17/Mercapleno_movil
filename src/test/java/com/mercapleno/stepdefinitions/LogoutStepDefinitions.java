package com.mercapleno.stepdefinitions;

import com.mercapleno.questions.ValidarLogout;
import com.mercapleno.tasks.CerrarSesion;
import io.cucumber.java.es.*;
import net.serenitybdd.screenplay.actors.OnStage;

import static net.serenitybdd.screenplay.GivenWhenThen.seeThat;
import static org.hamcrest.Matchers.equalTo;

public class LogoutStepDefinitions {

    @Cuando("el usuario decide cerrar sesion")
    public void elUsuarioDecideCerrarSesion() {
        OnStage.theActorInTheSpotlight().attemptsTo(
                CerrarSesion.deMercapleno()
        );
    }

    @Entonces("deberia retornar a la pantalla de inicio de sesion")
    public void deberiaRetornarALaPantallaDeInicioDeSesion() {
        OnStage.theActorInTheSpotlight().should(
                seeThat("La visibilidad de la pantalla de login", ValidarLogout.esExitoso(), equalTo(true))
        );
    }
}

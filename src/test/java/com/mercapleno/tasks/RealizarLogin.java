package com.mercapleno.tasks;

import com.mercapleno.userinterfaces.LoginPage;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.actions.Click;
import net.serenitybdd.screenplay.actions.Enter;
import static net.serenitybdd.screenplay.Tasks.instrumented;

public class RealizarLogin implements Task {
    private final String email;
    private final String password;

    public RealizarLogin(String email, String password) {
        this.email = email;
        this.password = password;
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        try { Thread.sleep(1500); } catch (InterruptedException e) { e.printStackTrace(); }
        actor.attemptsTo(
                Enter.theValue(email).into(LoginPage.INPUT_EMAIL),
                Enter.theValue(password).into(LoginPage.INPUT_PASSWORD),
                Click.on(LoginPage.BOTON_INGRESAR)
        );
        try { Thread.sleep(1500); } catch (InterruptedException e) { e.printStackTrace(); }
    }

    public static RealizarLogin conCredenciales(String email, String password) {
        return instrumented(RealizarLogin.class, email, password);
    }
}

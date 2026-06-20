package com.mercapleno.tasks;

import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.actions.Open;
import static net.serenitybdd.screenplay.Tasks.instrumented;

public class AbrirPagina implements Task {
    @Override
    public <T extends Actor> void performAs(T actor) {
        try { Thread.sleep(1500); } catch (InterruptedException e) { e.printStackTrace(); }
        actor.attemptsTo(Open.url("http://localhost:5173"));
    }

    public static AbrirPagina deMercapleno() {
        return instrumented(AbrirPagina.class);
    }
}

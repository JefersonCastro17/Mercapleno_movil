package com.mercapleno.tasks;

import com.mercapleno.userinterfaces.CarritoPage;
import com.mercapleno.userinterfaces.CatalogoPage;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.actions.Click;
import net.serenitybdd.screenplay.actions.SelectFromOptions;
import net.serenitybdd.screenplay.waits.WaitUntil;

import static net.serenitybdd.screenplay.Tasks.instrumented;
import static net.serenitybdd.screenplay.matchers.WebElementStateMatchers.isVisible;

public class RealizarPago implements Task {

    private final String metodoPago;

    public RealizarPago(String metodoPago) {
        this.metodoPago = metodoPago;
    }

    @Override
    public <T extends Actor> void performAs(T actor) {

        String metodoVisible = metodoPago;

        if (metodoPago.equalsIgnoreCase("Tarjeta")) {
            metodoVisible = "Tarjeta de Credito";
        } else if (metodoPago.equalsIgnoreCase("Yape")) {
            metodoVisible = "Nequi";
        } else if (metodoPago.equalsIgnoreCase("Plin")) {
            metodoVisible = "Daviplata";
        }

        actor.attemptsTo(

            // Abrir carrito
            Click.on(CatalogoPage.BOTON_CARRITO_HEADER),

            // Esperar que cargue
            WaitUntil.the(CarritoPage.SELECT_METODO_PAGO, isVisible())
                    .forNoMoreThan(10).seconds(),

            SelectFromOptions.byVisibleText(metodoVisible)
                    .from(CarritoPage.SELECT_METODO_PAGO),

            Click.on(CarritoPage.BOTON_PAGAR)
        );
    }

    public static RealizarPago conMetodo(String metodoPago) {
        return instrumented(RealizarPago.class, metodoPago);
    }
}
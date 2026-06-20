package com.mercapleno.tasks;

import com.mercapleno.userinterfaces.CatalogoPage;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.actions.Enter;
import static net.serenitybdd.screenplay.Tasks.instrumented;

public class BuscarProducto implements Task {
    private final String productoNombre;

    public BuscarProducto(String productoNombre) {
        this.productoNombre = productoNombre;
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        actor.attemptsTo(
                Enter.theValue(productoNombre).into(CatalogoPage.INPUT_BUSQUEDA)
        );
        try { Thread.sleep(1500); } catch (InterruptedException e) { e.printStackTrace(); }
    }

    public static BuscarProducto conNombre(String productoNombre) {
        return instrumented(BuscarProducto.class, productoNombre);
    }
}

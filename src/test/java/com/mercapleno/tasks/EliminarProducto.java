package com.mercapleno.tasks;

import com.mercapleno.userinterfaces.CarritoPage;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.actions.Click;
import static net.serenitybdd.screenplay.Tasks.instrumented;

public class EliminarProducto implements Task {
    private final String productoNombre;

    public EliminarProducto(String productoNombre) {
        this.productoNombre = productoNombre;
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        actor.attemptsTo(
                Click.on(CarritoPage.BOTON_ELIMINAR_PRODUCTO.of(productoNombre))
        );
        try { Thread.sleep(1500); } catch (InterruptedException e) { e.printStackTrace(); }
    }

    public static EliminarProducto delCarrito(String productoNombre) {
        return instrumented(EliminarProducto.class, productoNombre);
    }
}

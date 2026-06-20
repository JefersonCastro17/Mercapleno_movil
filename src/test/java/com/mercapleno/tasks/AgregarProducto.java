package com.mercapleno.tasks;

import com.mercapleno.userinterfaces.CatalogoPage;
import com.mercapleno.userinterfaces.CarritoPage;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.actions.Click;
import static net.serenitybdd.screenplay.Tasks.instrumented;

public class AgregarProducto implements Task {
    private final String productoNombre;

    public AgregarProducto(String productoNombre) {
        this.productoNombre = productoNombre;
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        if (CarritoPage.BOTON_SEGUIR_COMPRANDO.resolveFor(actor).isPresent() &&
            CarritoPage.BOTON_SEGUIR_COMPRANDO.resolveFor(actor).isCurrentlyVisible()) {
            actor.attemptsTo(Click.on(CarritoPage.BOTON_SEGUIR_COMPRANDO));
        }
        actor.attemptsTo(
                Click.on(CatalogoPage.BOTON_AGREGAR_AL_CARRITO.of(productoNombre))
        );
        try { Thread.sleep(500); } catch (InterruptedException e) { e.printStackTrace(); }
    }

    public static AgregarProducto alCarrito(String productoNombre) {
        return instrumented(AgregarProducto.class, productoNombre);
    }
}

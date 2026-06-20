package com.mercapleno.tasks;

import com.mercapleno.userinterfaces.CarritoPage;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.actions.Click;
import static net.serenitybdd.screenplay.Tasks.instrumented;

public class ModificarCantidad implements Task {
    private final String nombreProducto;
    private final String accion;
    private final int veces;

    public ModificarCantidad(String nombreProducto, String accion, int veces) {
        this.nombreProducto = nombreProducto;
        this.accion = accion;
        this.veces = veces;
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        for (int i = 0; i < veces; i++) {
            if ("incrementar".equalsIgnoreCase(accion)) {
                actor.attemptsTo(Click.on(CarritoPage.BOTON_AUMENTAR_CANTIDAD.of(nombreProducto)));
            } else if ("decrementar".equalsIgnoreCase(accion)) {
                actor.attemptsTo(Click.on(CarritoPage.BOTON_REDUCIR_CANTIDAD.of(nombreProducto)));
            }
            try { Thread.sleep(300); } catch (InterruptedException e) { e.printStackTrace(); }
        }
        try { Thread.sleep(500); } catch (InterruptedException e) { e.printStackTrace(); }
    }

    public static ModificarCantidad de(String nombreProducto, String accion, int veces) {
        return instrumented(ModificarCantidad.class, nombreProducto, accion, veces);
    }
}

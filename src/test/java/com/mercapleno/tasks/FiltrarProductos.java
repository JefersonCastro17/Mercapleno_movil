package com.mercapleno.tasks;

import com.mercapleno.userinterfaces.CatalogoPage;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.actions.Enter;
import net.serenitybdd.screenplay.actions.SelectFromOptions;
import static net.serenitybdd.screenplay.Tasks.instrumented;

public class FiltrarProductos implements Task {
    private final String nombre;
    private final String categoria;
    private final String precioMin;
    private final String precioMax;

    public FiltrarProductos(String nombre, String categoria, String precioMin, String precioMax) {
        this.nombre = nombre;
        this.categoria = categoria;
        this.precioMin = precioMin;
        this.precioMax = precioMax;
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        if (nombre != null && !nombre.isEmpty()) {
            actor.attemptsTo(Enter.theValue(nombre).into(CatalogoPage.INPUT_BUSQUEDA));
        }
        if (categoria != null && !categoria.isEmpty()) {
            actor.attemptsTo(SelectFromOptions.byValue(categoria).from(CatalogoPage.SELECT_CATEGORIA));
        }
        if (precioMin != null && !precioMin.isEmpty()) {
            actor.attemptsTo(Enter.theValue(precioMin).into(CatalogoPage.INPUT_PRECIO_MIN));
        }
        if (precioMax != null && !precioMax.isEmpty()) {
            actor.attemptsTo(Enter.theValue(precioMax).into(CatalogoPage.INPUT_PRECIO_MAX));
        }
        try { Thread.sleep(1000); } catch (InterruptedException e) { e.printStackTrace(); }
    }

    public static FiltrarProductos conFiltros(String nombre, String categoria, String precioMin, String precioMax) {
        return instrumented(FiltrarProductos.class, nombre, categoria, precioMin, precioMax);
    }
}

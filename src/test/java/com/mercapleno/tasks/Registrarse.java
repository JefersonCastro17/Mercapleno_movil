package com.mercapleno.tasks;

import com.mercapleno.userinterfaces.RegisterPage;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.actions.Click;
import net.serenitybdd.screenplay.actions.Enter;
import net.serenitybdd.screenplay.actions.SelectFromOptions;
import static net.serenitybdd.screenplay.Tasks.instrumented;

public class Registrarse implements Task {
    private final String nombre;
    private final String apellido;
    private final String tipoDocumento;
    private final String numeroDocumento;
    private final String fechaNacimiento;
    private final String email;
    private final String direccion;
    private final String password;

    public Registrarse(String nombre, String apellido, String tipoDocumento, String numeroDocumento,
                       String fechaNacimiento, String email, String direccion, String password) {
        this.nombre = nombre;
        this.apellido = apellido;
        this.tipoDocumento = tipoDocumento;
        this.numeroDocumento = numeroDocumento;
        this.fechaNacimiento = fechaNacimiento;
        this.email = email;
        this.direccion = direccion;
        this.password = password;
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        actor.attemptsTo(
                Enter.theValue(nombre).into(RegisterPage.INPUT_NOMBRE),
                Enter.theValue(apellido).into(RegisterPage.INPUT_APELLIDO),
                SelectFromOptions.byVisibleText(tipoDocumento).from(RegisterPage.SELECT_TIPO_DOCUMENTO),
                Enter.theValue(numeroDocumento).into(RegisterPage.INPUT_NUMERO_DOCUMENTO),
                Enter.theValue(fechaNacimiento).into(RegisterPage.INPUT_FECHA_NACIMIENTO),
                Enter.theValue(email).into(RegisterPage.INPUT_EMAIL),
                Enter.theValue(direccion).into(RegisterPage.INPUT_DIRECCION),
                Enter.theValue(password).into(RegisterPage.INPUT_PASSWORD),
                Click.on(RegisterPage.BOTON_SUBMIT)
        );
        try { Thread.sleep(1000); } catch (InterruptedException e) { e.printStackTrace(); }
    }

    public static Registrarse conDatos(String nombre, String apellido, String tipoDocumento, String numeroDocumento,
                                       String fechaNacimiento, String email, String direccion, String password) {
        return instrumented(Registrarse.class, nombre, apellido, tipoDocumento, numeroDocumento, fechaNacimiento, email, direccion, password);
    }
}

package com.mercapleno.tasks;

import com.mercapleno.userinterfaces.RecoverPage;
import com.mercapleno.utils.DbHelper;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.actions.Click;
import net.serenitybdd.screenplay.actions.Enter;
import static net.serenitybdd.screenplay.Tasks.instrumented;

public class RecuperarPassword implements Task {
    private final String email;
    private final String newPassword;

    public RecuperarPassword(String email, String newPassword) {
        this.email = email;
        this.newPassword = newPassword;
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        // Step 1: Request reset code
        actor.attemptsTo(
                Enter.theValue(email).into(RecoverPage.INPUT_EMAIL_SOLICITUD),
                Click.on(RecoverPage.BOTON_SOLICITAR)
        );
        try { Thread.sleep(1500); } catch (InterruptedException e) { e.printStackTrace(); }

        // Step 2: Fetch and crack the reset code from DB
        String resetCode = DbHelper.getPasswordResetCodeForEmail(email);

        // Step 3: Fill reset details and submit
        actor.attemptsTo(
                Enter.theValue(email).into(RecoverPage.INPUT_EMAIL_CONFIRMACION),
                Enter.theValue(resetCode).into(RecoverPage.INPUT_CODIGO),
                Enter.theValue(newPassword).into(RecoverPage.INPUT_NUEVA_CONTRASENA),
                Enter.theValue(newPassword).into(RecoverPage.INPUT_CONFIRMAR_CONTRASENA),
                Click.on(RecoverPage.BOTON_ACTUALIZAR)
        );
        try { Thread.sleep(1500); } catch (InterruptedException e) { e.printStackTrace(); }
    }

    public static RecuperarPassword paraEmailYPassword(String email, String newPassword) {
        return instrumented(RecuperarPassword.class, email, newPassword);
    }
}

package com.mercapleno.tasks;

import com.mercapleno.userinterfaces.VerifyPage;
import com.mercapleno.utils.DbHelper;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.actions.Click;
import net.serenitybdd.screenplay.actions.Enter;
import static net.serenitybdd.screenplay.Tasks.instrumented;

public class VerificarEmail implements Task {
    private final String email;

    public VerificarEmail(String email) {
        this.email = email;
    }

    @Override
    public <T extends Actor> void performAs(T actor) {
        // Retrieve and crack verification code from DB
        String verificationCode = DbHelper.getVerificationCodeForEmail(email);

        actor.attemptsTo(
                Enter.theValue(email).into(VerifyPage.INPUT_EMAIL),
                Enter.theValue(verificationCode).into(VerifyPage.INPUT_CODIGO),
                Click.on(VerifyPage.BOTON_VERIFICAR)
        );
        try { Thread.sleep(1000); } catch (InterruptedException e) { e.printStackTrace(); }
    }

    public static VerificarEmail delUsuario(String email) {
        return instrumented(VerificarEmail.class, email);
    }
}

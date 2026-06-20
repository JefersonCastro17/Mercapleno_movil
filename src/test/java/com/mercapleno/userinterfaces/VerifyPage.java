package com.mercapleno.userinterfaces;

import net.serenitybdd.screenplay.targets.Target;
import org.openqa.selenium.By;

public class VerifyPage {
    public static final Target INPUT_EMAIL = Target.the("campo correo electronico a verificar")
            .located(By.id("verifyEmail"));
    public static final Target INPUT_CODIGO = Target.the("campo codigo de verificacion")
            .located(By.id("verificationCode"));
    public static final Target BOTON_VERIFICAR = Target.the("boton verificar correo")
            .located(By.xpath("//form//button[contains(@class, 'submit-btn')]"));
    public static final Target BOTON_REENVIAR = Target.the("boton reenviar codigo")
            .located(By.xpath("//button[contains(text(), 'Reenviar Codigo')]"));
    public static final Target MENSAJE_ALERTA = Target.the("mensaje de alerta de verificacion")
            .located(By.className("message"));
}

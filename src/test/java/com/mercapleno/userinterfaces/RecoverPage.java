package com.mercapleno.userinterfaces;

import net.serenitybdd.screenplay.targets.Target;
import org.openqa.selenium.By;

public class RecoverPage {
    // Paso 1: Solicitud de codigo
    public static final Target INPUT_EMAIL_SOLICITUD = Target.the("campo correo electronico de solicitud")
            .located(By.id("resetEmail"));
    public static final Target BOTON_SOLICITAR = Target.the("boton enviar solicitud de codigo")
            .located(By.xpath("//form//button[contains(@class, 'submit-btn')]"));

    // Paso 2: Actualizacion de contrasena
    public static final Target INPUT_EMAIL_CONFIRMACION = Target.the("campo correo electronico de confirmacion")
            .located(By.id("resetEmailConfirm"));
    public static final Target INPUT_CODIGO = Target.the("campo codigo de recuperacion")
            .located(By.id("resetCode"));
    public static final Target INPUT_NUEVA_CONTRASENA = Target.the("campo nueva contrasena")
            .located(By.id("newPassword"));
    public static final Target INPUT_CONFIRMAR_CONTRASENA = Target.the("campo confirmar contrasena")
            .located(By.id("confirmPassword"));
    public static final Target BOTON_ACTUALIZAR = Target.the("boton actualizar contrasena")
            .located(By.xpath("//form//button[contains(@class, 'submit-btn')]"));

    public static final Target MENSAJE_ALERTA = Target.the("mensaje de alerta de recuperacion")
            .located(By.className("message"));
}

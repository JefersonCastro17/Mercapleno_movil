package com.mercapleno.userinterfaces;

import net.serenitybdd.screenplay.targets.Target;
import org.openqa.selenium.By;

public class RegisterPage {
    public static final Target INPUT_NOMBRE = Target.the("campo nombre")
            .located(By.id("nombre"));
    public static final Target INPUT_APELLIDO = Target.the("campo apellido")
            .located(By.id("apellido"));
    public static final Target SELECT_TIPO_DOCUMENTO = Target.the("selector tipo de documento")
            .located(By.id("id_tipo_identificacion"));
    public static final Target INPUT_NUMERO_DOCUMENTO = Target.the("campo numero de identificacion")
            .located(By.id("numero_identificacion"));
    public static final Target INPUT_FECHA_NACIMIENTO = Target.the("campo fecha de nacimiento")
            .located(By.id("fecha_nacimiento"));
    public static final Target INPUT_EMAIL = Target.the("campo correo electronico")
            .located(By.id("email"));
    public static final Target INPUT_DIRECCION = Target.the("campo direccion")
            .located(By.id("direccion"));
    public static final Target INPUT_PASSWORD = Target.the("campo contrasena")
            .located(By.id("password"));
    public static final Target BOTON_SUBMIT = Target.the("boton enviar registro")
            .located(By.cssSelector("button.submit-btn"));
    public static final Target MENSAJE_ALERTA = Target.the("mensaje de alerta de registro")
            .located(By.className("message"));
}

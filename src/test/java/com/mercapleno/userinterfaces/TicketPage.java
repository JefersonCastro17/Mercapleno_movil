package com.mercapleno.userinterfaces;

import net.serenitybdd.screenplay.targets.Target;
import org.openqa.selenium.By;

public class TicketPage {
    public static final Target TITULO_TICKET = Target.the("titulo de confirmacion del ticket")
            .located(By.className("ticket-header"));

    public static final Target MENSAJE_AGRADECIMIENTO = Target.the("mensaje de agradecimiento de la compra")
            .located(By.className("agradecimiento"));

    public static final Target VALOR_TOTAL = Target.the("valor total del ticket")
            .located(By.cssSelector(".total-final span"));

    public static final Target BOTON_VOLVER_CATALOGO = Target.the("boton volver al catalogo")
            .located(By.className("volver-catalogo-btn"));
}

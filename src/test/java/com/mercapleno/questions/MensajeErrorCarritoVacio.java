package com.mercapleno.questions;

import com.mercapleno.userinterfaces.CarritoPage;
import net.serenitybdd.screenplay.Question;
import net.serenitybdd.screenplay.questions.Text;

public class MensajeErrorCarritoVacio {
    public static Question<String> valor() {
        return actor -> Text.of(CarritoPage.TEXTO_ERROR_CHECKOUT).answeredBy(actor).trim();
    }
}

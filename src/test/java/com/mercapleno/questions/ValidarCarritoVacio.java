package com.mercapleno.questions;

import com.mercapleno.userinterfaces.CarritoPage;
import net.serenitybdd.screenplay.Question;
import net.serenitybdd.screenplay.questions.Text;

public class ValidarCarritoVacio {
    public static Question<String> valor() {
        return actor -> Text.of(CarritoPage.MENSAJE_CARRITO_VACIO).answeredBy(actor).trim();
    }
}

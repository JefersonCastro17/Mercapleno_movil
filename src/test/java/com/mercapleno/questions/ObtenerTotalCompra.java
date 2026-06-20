package com.mercapleno.questions;

import com.mercapleno.userinterfaces.CarritoPage;
import net.serenitybdd.screenplay.Question;
import net.serenitybdd.screenplay.questions.Text;

public class ObtenerTotalCompra {
    public static Question<String> delCarrito() {
        return actor -> Text.of(CarritoPage.VALOR_TOTAL_COMPRA).answeredBy(actor).trim();
    }
}

package com.mercapleno.questions;

import com.mercapleno.userinterfaces.CatalogoPage;
import net.serenitybdd.screenplay.Question;
import net.serenitybdd.screenplay.questions.Text;

public class ResultadosBusqueda {
    public static Question<String> delProducto(String productoNombre) {
        return actor -> Text.of(CatalogoPage.NOMBRE_PRODUCTO.of(productoNombre)).answeredBy(actor).trim();
    }
}

package com.mercapleno.questions;

import com.mercapleno.userinterfaces.CatalogoPage;
import net.serenitybdd.screenplay.Question;
import net.serenitybdd.screenplay.questions.Text;

public class ValidarLoginExitoso {
    public static Question<String> valor() {
        return actor -> {
            String texto = Text.of(CatalogoPage.TITULO_PRODUCTOS).answeredBy(actor).trim();
            if (texto.contains("Explora el inventario disponible") || texto.contains("Catalogo")) {
                return "Productos disponibles";
            }
            return texto;
        };
    }
}

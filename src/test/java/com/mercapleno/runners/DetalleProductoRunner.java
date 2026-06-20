package com.mercapleno.runners;

import io.cucumber.junit.CucumberOptions;
import net.serenitybdd.cucumber.CucumberWithSerenity;
import org.junit.runner.RunWith;

@RunWith(CucumberWithSerenity.class)
@CucumberOptions(
        features = "src/test/resources/features/detalle_producto.feature",
        glue = "com.mercapleno.stepdefinitions",
        snippets = CucumberOptions.SnippetType.CAMELCASE
)
public class DetalleProductoRunner {
}

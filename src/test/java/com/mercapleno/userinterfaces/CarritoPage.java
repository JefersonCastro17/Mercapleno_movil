package com.mercapleno.userinterfaces;

import net.serenitybdd.screenplay.targets.Target;
import org.openqa.selenium.By;

public class CarritoPage {
        public static final Target SELECT_METODO_PAGO = Target.the("selector de metodo de pago")
                        .located(By.id("payment-method"));

        public static final Target BOTON_PAGAR = Target.the("boton de pagar y finalizar compra")
                        .located(By.className("cart-btn--pay"));

        public static final Target BOTON_ELIMINAR_PRODUCTO = Target.the("boton de eliminar producto {0} del carrito")
                        .locatedBy("//article[contains(@class, 'cart-item-row') and .//p[contains(@class, 'cart-item-row__name') and text()='{0}']]//button[contains(text(), 'Eliminar')]");

        public static final Target MENSAJE_CARRITO_VACIO = Target.the("mensaje de carrito vacio")
                        .located(By.xpath("//section[contains(@class, 'cart-empty')]/h2"));

        public static final Target VALOR_TOTAL_COMPRA = Target.the("valor total de la compra en el resumen")
                        .located(By.cssSelector(".cart-totals__total"));

        public static final Target TEXTO_ERROR_CHECKOUT = Target.the("texto de error de checkout")
                        .located(By.className("cart-checkout-error"));

        public static final Target BOTON_SEGUIR_COMPRANDO = Target.the("boton de seguir comprando")
                        .located(By.xpath(
                                        "//button[contains(@class, 'cart-btn--muted') or contains(text(), 'Seguir comprando') or contains(text(), 'Explorar productos')]"));

        public static final Target BOTON_VACIAR_CARRITO = Target.the("boton de vaciar carrito")
                        .located(By.xpath("//button[contains(text(), 'Vaciar carrito')]"));

        public static final Target BOTON_REDUCIR_CANTIDAD = Target.the("boton reducir cantidad de {0}")
                        .locatedBy("//article[contains(@class, 'cart-item-row') and .//p[contains(@class, 'cart-item-row__name') and text()='{0}']]//button[@aria-label='Quitar una unidad']");

        public static final Target BOTON_AUMENTAR_CANTIDAD = Target.the("boton aumentar cantidad de {0}")
                        .locatedBy("//article[contains(@class, 'cart-item-row') and .//p[contains(@class, 'cart-item-row__name') and text()='{0}']]//button[@aria-label='Agregar una unidad']");

        public static final Target CANTIDAD_PRODUCTO = Target.the("cantidad del producto {0} en el carrito")
                        .locatedBy("//article[contains(@class, 'cart-item-row') and .//p[contains(@class, 'cart-item-row__name') and text()='{0}']]//div[contains(@class, 'cart-item-row__qty')]/span");
}

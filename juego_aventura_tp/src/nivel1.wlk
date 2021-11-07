import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import nivel2.*
import utilidades.*

object nivelBloques {

	const prota1 = new Protagonista()

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
			// otros visuals, p.ej. bloques o llaves
			// personaje, es importante que sea el último visual que se agregue
		game.addVisual(prota1)
		game.addVisual(caja)
			// teclado
			// este es para probar, no es necesario dejarlo
		keyboard.t().onPressDo({self.terminar()})
		game.whenCollideDo(prota1, { e => prota1.empujar(e)})
			// teclado movimiento:
		keyboard.up().onPressDo({ prota1.moverArriba() prota1.gastarEnergia()})
		keyboard.down().onPressDo({ prota1.moverAbajo() prota1.gastarEnergia()})
		keyboard.right().onPressDo({ prota1.moverDerecha() prota1.gastarEnergia()})
		keyboard.left().onPressDo({ prota1.moverIzquierda() prota1.gastarEnergia()})
	// en este no hacen falta colisiones
	}

	method terminar() {
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
			// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		game.addVisual(prota1)
			// después de un ratito ...
		game.schedule(2500, { game.clear()
				// cambio de fondo
			game.addVisual(new Fondo(image = "finNivel1.png"))
				// después de un ratito ...
			game.schedule(3000, { // ... limpio todo de nuevo
				game.clear()
					// y arranco el siguiente nivel
				nivelLlaves.configurate()
			})
		})
	}

}


import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import nivel2.*
import utilidades.*

object nivelBloques {

	const prota1 = new Protagonista()
	const cofre1 = new Cofre(position = game.at(2,3))
	const fragmento1 = new FragmentoEspada(position = utilidadesParaJuego.posicionArbitraria(), image = "Fragment_2_golden_sword.png")
	const fragmento2 = new FragmentoEspada(position = utilidadesParaJuego.posicionArbitraria(), image = "Fragment_2_golden_sword.png")
	const fragmento3 = new FragmentoEspada(position = utilidadesParaJuego.posicionArbitraria(), image ="Broken_golden_sword.png" )
	const fragmento4 = new FragmentoEspada(position = utilidadesParaJuego.posicionArbitraria(), image = "Gem_golden_sword.png")
	const energiaIndicador = new IndicadorEnergia(position = game.at(1,0))


	method configurate() {
		
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		
			// otros visuals, p.ej. bloques o llaves
			// personaje, es importante que sea el último visual que se agregue
		//game.addVisual(new VesselMana(position = game.at(1,1)))
		//game.addVisual(new VesselSalud(position = game.at(1,2)))
		game.addVisual(new PocionMana(position = utilidadesParaJuego.posicionArbitraria(), image = "flask_big_blue.png"))
		//game.addVisual(new Monedas(position = game.at(1,4))) 
		//game.addVisual(new CeldaQuitaEnergia(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(cofre1)
		
		//game.addVisual(new Forja(position = game.height() -2))
		game.addVisual(fragmento1)
		game.addVisual(fragmento2)
		game.addVisual(fragmento3)
		game.addVisual(fragmento4)
		
		game.addVisual(energiaIndicador)
		game.addVisual(new IndicadorSalud(position = game.at(0,0)))
		
		game.addVisual(prota1)
			
			
			// teclado
			// este es para probar, no es necesario dejarlo
		keyboard.t().onPressDo({ self.terminar()})
		
		game.whenCollideDo(prota1, {e => prota1.accionar(e)})
			
		// teclado movimiento:
		keyboard.space().onPressDo({game.say(prota1, prota1.informarEstado())})
		
		keyboard.r().onPressDo({prota1.recogerObjetosProximos()})
			
		keyboard.up().onPressDo({ prota1.moverArriba()
			prota1.gastarEnergia()
			energiaIndicador.visualizar(prota1)
		})
		keyboard.down().onPressDo({ prota1.moverAbajo()
			prota1.gastarEnergia()
			energiaIndicador.visualizar(prota1)
		})
		keyboard.right().onPressDo({ prota1.moverDerecha()
			prota1.gastarEnergia()
			energiaIndicador.visualizar(prota1)
		})
		keyboard.left().onPressDo({ prota1.moverIzquierda()
			prota1.gastarEnergia()
			energiaIndicador.visualizar(prota1)
		})
	// en este no hacen falta colisiones
	}

	
	method perder() {
		game.clear()
		
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		
		game.addVisual(prota1)
		
		game.schedule(3500, {game.clear()})
		
		game.addVisual(new Fondo(image = "Pantalla-GameOver.png" ))
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


import wollok.game.*
import personajes.*
import elementos.*
import nivel2.*
import utilidades.*

object nivelBloques {
	
	var property powerUpsEnNivel = 0
	var powerUpsEncendidos = false
	const property soundtrack = new Sound(file = "danzamacabra.mp3")
	const property inicioJuego = new Fondo(image = "Bienvenidos.png")
    // se crean los fragmentos
	const fragmento1 = new FragmentoEspada(image = "Fragment_1_golden_sword.png")
	const fragmento2 = new FragmentoEspada(image = "Fragment_2_golden_sword.png")
	const fragmento3 = new FragmentoEspada(image ="Broken_golden_sword.png" )
	const fragmento4 = new FragmentoEspada(image = "Gem_golden_sword.png")
	
	
	//se crean los indicadores
	const energiaIndicador = new IndicadorEnergia()
	const salud = new IndicadorSalud()

	method configurate() {
		
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo())
		
		//forja
		game.addVisual(forja)
		
		//celdas
		game.addVisual(new CeldaQuitaEnergia())
		game.addVisual(new CeldaAgregaEnergia())
		game.addVisual(new CeldaTeletransportadora())
		game.addVisual(new CeldaAgregaEnergia())
		game.addVisual(new CeldaTeletransportadora())
		game.addVisual(new CeldaTeletransportadora())
		
		
		//escalera y cofres
		game.addVisual(escalera)
		game.addVisual(new Cofre())
		game.addVisual(new Cofre())
		game.addVisual(new Cofre())
		game.addVisual(new Cofre())
		game.addVisual(new Cofre())
		game.addVisual(new Cofre())

		
		
		// fragmentos de espada
		game.addVisual(fragmento1)
		game.addVisual(fragmento2)
		game.addVisual(fragmento3)
		game.addVisual(fragmento4)
		
		
		//indicadores
		game.addVisual(energiaIndicador)
		game.addVisual(salud)
			
		//prota
		game.addVisual(protagonista)
		
		game.onCollideDo(protagonista, {o => protagonista.accionar(o)})
		game.onCollideDo(escalera, {cofre => escalera.reaccionar(cofre)})
		
		game.addVisual(inicioJuego)
		// teclado
		// este es para probar, no es necesario dejarlo
		keyboard.t().onPressDo({ self.terminar()})

		keyboard.i().onPressDo({game.allVisuals().forEach({o => game.say(o, o.toString())})})
		
		keyboard.q().onPressDo({game.say(protagonista,"PowerUps: " + self.powerUpsEnNivel().toString())})
		
		keyboard.space().onPressDo({game.say(protagonista, protagonista.informarEstado())})

		keyboard.x().onPressDo({protagonista.interactuar()})
			
		// teclado movimiento:
		keyboard.f().onPressDo({protagonista.interactuar()})
		
		keyboard.enter().onPressDo({self.reproducir() self.corroborarCantidadPowerUps() self.configurarMovimientoTeclado() game.removeVisual(inicioJuego)})

	}
	
	method reproducir() {
		if (!self.soundtrack().played()) {
			self.soundtrack().shouldLoop(true)
			self.soundtrack().volume(0.6)
			self.soundtrack().play()
		}
	}
	
	method configurarMovimientoTeclado() {
		keyboard.up().onPressDo({ protagonista.moverArriba()
			protagonista.gastarEnergia() self.verificaFinDeNivel() energiaIndicador.visualizar(protagonista)
		})
		keyboard.down().onPressDo({ protagonista.moverAbajo()
			protagonista.gastarEnergia() self.verificaFinDeNivel() energiaIndicador.visualizar(protagonista)
		})
		keyboard.right().onPressDo({ protagonista.moverDerecha()
			protagonista.gastarEnergia() self.verificaFinDeNivel() energiaIndicador.visualizar(protagonista)
		})
		keyboard.left().onPressDo({ protagonista.moverIzquierda()
			protagonista.gastarEnergia() self.verificaFinDeNivel() energiaIndicador.visualizar(protagonista)
		})
	}
	
	method corroborarCantidadPowerUps() {
		game.onTick(8000, "cantidadPowerUps", { => self.detenerEIniciarPowerUps()})
	}
	
	method detenerEIniciarPowerUps() {
		if (self.powerUpsEnNivel() > 15 and powerUpsEncendidos) {
			self.detenerGeneracionDePowerUps() 
		} else if (!powerUpsEncendidos) {
			self.generarPowerUpsEnJuego()
		}
	}
	
	method detenerGeneracionDePowerUps() {
		powerUpsEncendidos = false
		game.removeTickEvent("Monedas")
		game.removeTickEvent("VesselPocion")
		game.removeTickEvent("PocionMana")
	}
	
	method generarPowerUpsEnJuego() {
		powerUpsEncendidos = true
		game.onTick(7000, "PocionMana",{ => game.addVisual(new PocionMana())})
		game.onTick(5000, "Monedas", { => game.addVisual(new Monedas())})
		game.onTick(3000, "VesselPocion", { => game.addVisual(new VesselMana())})
	}
	
	method perder() {
		
		game.clear()
		try {
			self.detenerGeneracionDePowerUps()
		} catch e {
		}
		
		
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		
		game.addVisual(protagonista)
		
		game.addVisual(new Fondo(image = "Pantalla-GameOver.png" ))
		
		soundtrack.stop()
	}
	
	
	method verificaFinDeNivel() {
		if (protagonista.energia() <= 0 or protagonista.salud() <= 0){
			self.perder()
		}
		else if (forja.objetivoLogrado() and escalera.objetivoLogrado()) {
			self.terminar()
		}
	}
	
	method terminar() {
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
		try {
			self.detenerGeneracionDePowerUps()
		} catch e {
		}
		soundtrack.stop()
			// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		game.addVisual(protagonista)
			// después de un ratito ...
		game.schedule(2500, { game.clear()
				// cambio de fondo
			game.addVisual(new Fondo(image = "finNivel1.png"))
				// después de un ratito ...
			game.schedule(3000, { // ... limpio todo de nuevo
				game.clear()
					// y arranco el siguiente nivel
				nivelMonedas.configurate()
			})
		})
	}

}


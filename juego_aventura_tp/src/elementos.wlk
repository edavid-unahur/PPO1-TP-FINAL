import wollok.game.*
import personajes.*
import utilidades.*
import personajes.*
import nivel1.*
import nivel2.*

class PowerUp {
	var property position 
	method reaccionar(personaje) {
		game.removeVisual(self)
	}
	method esMovible() {return true}
}

class PocionMana inherits PowerUp{
    const property image = "flask_big_blue.png"
	override method reaccionar(personaje) {super(personaje) personaje.energia(personaje.energia() + 10)}
}

class VesselMana inherits PowerUp {
	const property image = "flask_blue.png"
	override method reaccionar(personaje) {super(personaje) personaje.energia(personaje.energia() + 5)}
}

class PocionSalud inherits PowerUp {
	const property image = "flask_big_red.png"
	override method reaccionar(personaje) {super(personaje) personaje.salud(personaje.salud() + 15)}
}

class VesselSalud inherits PowerUp {
	const property image = "flask_red.png"
	override method reaccionar(personaje) {super(personaje) personaje.salud(personaje.salud() + 5)}
}

class Monedas inherits PowerUp {
	const property image = "coin_anim_f0.png"
	override method reaccionar(personaje) {super(personaje) personaje.dinero(personaje.dinero() + 5) nivelLlaves.aparecerSalida()}
}

class MonedaSanguinaria inherits PowerUp {
	const property image = "monedaSanguinaria.png"
	override method reaccionar(personaje) {
		super(personaje) 
		personaje.dinero(personaje.dinero() + 5) 
		personaje.salud(personaje.salud() - 5)
		nivelLlaves.aparecerSalida()
	}
}

class Cofre {
	const property image = "chest_empty_open_anim_f0.png"
	var property position 
	
	method esMovible() {return true}

	method reaccionar(personaje) {
		const newPosition = personaje.direccion().siguiente(position)
		if (newPosition.y() != game.height() and 
			newPosition.x() != game.width() and
			newPosition.x() != -1 and 
			newPosition.y() != -1) {
			
			position = newPosition	
		}
	}

}

class FragmentoEspada {
	const property image = "Broken_golden_sword.png"
	var property position 
	method reaccionar(personaje) {
		personaje.recogerFragmento(self)
		game.removeVisual(self)
	}
	method esMovible() {return true}
}

class CeldaSorpresa {
	const property image = "celdaSorpresa.png"
	var property position
	method reaccionar(personaje) {game.removeVisual(self)}
	method esMovible() {return true} 
}

class CeldaQuitaEnergia inherits CeldaSorpresa {
	override method reaccionar(personaje) {
		super(personaje)
		personaje.energia(personaje.energia() - 15)
	}
}

class CeldaAgregaEnergia inherits CeldaSorpresa {
	override method reaccionar(personaje) {
		super(personaje)
		personaje.energia(personaje.energia() + 30)
	}
}

class CeldaTeletransportadora inherits CeldaSorpresa {
	override method reaccionar(personaje) {
		super(personaje)
		personaje.position(utilidadesParaJuego.posicionArbitraria())
	}
}

class Indicador {
	const property position
	method reaccionar(personaje)
	method visualizar(personaje)
	method esMovible() = false
}

class IndicadorSalud inherits Indicador {
	var property image = "ui_heart_full.png"
	override method reaccionar(personaje){}

	override method visualizar(personaje) {
		if (personaje.salud() <= 50) {
			image = "ui_heart_half.png" 
		} else {
			image = "ui_heart_full.png"
		}
	}
}

class IndicadorEnergia inherits Indicador {
	var property image = "Energia_full.png"
	
	override method reaccionar(personaje){}

	override method visualizar(personaje) {
		if (personaje.energia() <= 50) {
			image = "Energia_half.png"
		} else {
			image = "Energia_full.png"
		}
	}
}


/* object barraDeIndicadores{
	var property position = game.at(0,0)
	var property image = "barra_indicadores.png"
	
	method reaccionar(){}
}
*/
object forja {
	const property image = "wall_fountain_basin_red_anim_f0.png"
	const property position = game.at(13,1)
	var property fragmentos = []
	var property objetivoLogrado = false
	method esMovible() {return false}	
	method reaccionar(personaje) {
		fragmentos.addAll(personaje.fragmentos())
		personaje.dejarFragmentos()
		game.say(self, "Juntaste " + fragmentos.size().stringValue() + " fragmentos, ya casi está todo.")
		if (fragmentos.size() == 4) {
			self.objetivoLogrado(true)
		}
		nivelBloques.verificaFinDeNivel()
	}
}

object escalera {
	const property image = "Escalera.png"
	const property position = game.at(0,13)
	var property cofresPisoInferior = []
	var property objetivoLogrado = false
	
	method esMovible() {return false}
	
	method reaccionar(cofre) {
		cofresPisoInferior.add(cofre)
		game.removeVisual(cofre)
		game.say(self, "Bajaste " + cofresPisoInferior.size().stringValue() + " cofres, dale que falta poco.")
		if (cofresPisoInferior.size() == 3) {
			self.objetivoLogrado(true)
		}
		nivelBloques.verificaFinDeNivel()
	}
}

object escaleraSalida {
	const property image = "Escalera.png"
	const property position = utilidadesParaJuego.posicionArbitraria()
	
	method esMovible() = true
	method reaccionar(personaje) {
		nivelLlaves.verificaFinDeNivel()
	}
}

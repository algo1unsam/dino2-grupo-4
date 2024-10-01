import wollok.game.*

const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.boardGround("fondo.png")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
	
		keyboard.space().onPressDo{ self.jugar()}
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})

		dino.sonidoSalto().volume(0.5)
		
	} 
	
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		dino.morir()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
}

object reloj {
	var property tiempo = 0 
	method text() = tiempo.toString()
    //method textColor() = "00FF00FF"
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo += 1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(1000,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

object cactus {
	var property position = self.posicionInicial()

	method image() = "cactus.png"
	method posicionInicial() = game.at(game.width()-1,suelo.position().y())

	method iniciar(){
		position = self.posicionInicial()
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = game.at(position.x()-1,position.y())
		if (position.x()<0){
			position = self.posicionInicial()
		}
	}
	
	method chocar(){
		juego.terminar()	
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
}

object suelo{

	method position() = game.origin()
	method image() = "suelo.png"
}


object dino {
	var vivo = true
	var property position = game.at(1,suelo.position().y())
	const property sonidoSalto = game.sound("marioSalto.mp3")
	const property sonidoMuerte = game.sound("oof.mp3")
	
	method image() = "dino.png"
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
			self.sonidoSalto().play()
		}
	}
	
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
		self.sonidoMuerte().play()
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}

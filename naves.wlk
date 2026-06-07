class Nave {
  var velocidad
  var direccion
  var combustible

  method acelerar(cant) {
    velocidad = (0.max(velocidad + cant)).min(100000)
  }
  method desacelerar(cant) {
    velocidad = (0.max(velocidad - cant))
  }
  method irHaciaElSol() {direccion = 10}
  method escaparDelSol() {direccion = -10}
  method ponerseParaleloAlSol() {direccion = 0}
  method acercarseUnPocoAlSol() {
    direccion = (direccion + 1).max(10)
  }
  method alejarseUnPocoDelSol() {
    direccion = (direccion - 1).min(-10)
  }

  method prepararViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }
  method cargarCombustible(cant) {combustible += cant}
  method descargarCombustible(cant) {combustible = 0.max(combustible - cant)}

  method estaTranquila() {
    return combustible >= 4000 and velocidad <= 12000
    and self.condicionAdicional()
  }
  method condicionAdicional()
  
  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }
  method escapar()
  method avisar()

  method estaDeRelajo() {
    return self.estaTranquila() and self.tienePocaActividad()
  }

  method tienePocaActividad() = true
}

class NaveBaliza inherits Nave {
  var color = "verde"
  var cambios = 0

  method cambiarColorDeBaliza(colorNuevo) {
    color = colorNuevo
    cambios += 1
    }
  override method prepararViaje() {
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }
  override method condicionAdicional() {
    return color != "rojo"
  }

  override method escapar() {self.irHaciaElSol()}
  override method avisar() {self.cambiarColorDeBaliza("rojo")}

  override method tienePocaActividad() = cambios == 0
}

class NavePasajeros inherits Nave {
  const pasajeros
  var comida
  var bebida
  var racionesServidas

  method cargarComida(cant) {
    comida += cant
    racionesServidas += 1
  }
  method cargarBebida(cant) {bebida += cant}
  method descargarComida(cant) {comida -= cant}
  method descargarBebida(cant) {bebida -= cant}

  override method prepararViaje() {
    self.cargarComida(4 * pasajeros)
    self.cargarBebida(6 * pasajeros)
    self.acercarseUnPocoAlSol()
  }

  override method escapar() {velocidad = velocidad * 2}
  override method avisar() {
    self.descargarComida(pasajeros)
    self.descargarBebida(pasajeros * 2)
  }

  override method tienePocaActividad() = racionesServidas < 50
}

class NaveCombate inherits Nave {
  const mensajes = []

  var estaInvisible
  var misilesDesplegados

  method ponerseInvisible() {estaInvisible = true}
  method ponerseVisible() {estaInvisible = false}
  method estaInvisible() = estaInvisible

  method desplegarMisiles() {misilesDesplegados = true}
  method replegarMisiles() {misilesDesplegados = false}
  method misilesDesplegados() = misilesDesplegados

  method emitirMensaje(mensaje) {mensajes.add(mensaje)}
  method mensajesEmitidos() {return mensajes.size()}
  method primerMensajeEmitido() {return mensajes.first()}
  method ultimoMensajeEmitido() {return mensajes.last()}
  method esEscueta()
  method emitioMensaje(mensaje)

  override method prepararViaje() {
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en mision")
  }

  override method condicionAdicional() = not misilesDesplegados

  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar() {self.emitirMensaje("Amenaza recibida")}
}

class NaveHospital inherits NavePasajeros {
  var quirofanosPreparados

  method prepararQuirofano() {quirofanosPreparados = true}
  method limpiarQuirofano() {quirofanosPreparados = false}
  method quirofanosPreparados() = quirofanosPreparados

  override method condicionAdicional() = not quirofanosPreparados
  
  override method recibirAmenaza() {
    self.escapar()
    self.avisar()
    self.limpiarQuirofano()
  }
}

class NaveSigilosa inherits NaveCombate {
  override method condicionAdicional() = not estaInvisible

  override method escapar() {
    self.escapar()
    self.avisar()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}
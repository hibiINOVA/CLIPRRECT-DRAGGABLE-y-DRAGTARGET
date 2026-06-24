import 'package:flutter/material.dart';

// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║  CLIPRRECT                                                                  ║
// ║  Máscara de recorte con esquinas redondeadas.                               ║
// ║  Envuelve a su hijo y solo muestra la parte que cabe dentro del             ║
// ║  rectángulo redondeado. Es como ponerle un "marco suave" a un widget.       ║
// ║                                                                              ║
// ║  Parámetros clave:                                                          ║
// ║  • borderRadius → radio de las esquinas                                     ║
// ║    (circular, only, horizontal, vertical)                                   ║
// ║  • child        → el widget a recortar (Image, Container, etc.)             ║
// ║  • clipper      → (opcional) recorte personalizado                          ║
// ║  • clipBehavior → calidad del recorte (antiAlias, hardEdge, none)           ║
// ║                                                                              ║
// ║  Usos: avatares, imágenes en tarjetas, botones, cualquier borde suave.      ║
// ╚══════════════════════════════════════════════════════════════════════════════╝
// 
// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║  DRAGGABLE                                                                  ║
// ║  Widget que el usuario puede arrastrar con el dedo.                         ║
// ║  Mientras se arrastra, un "feedback" visual sigue al dedo y el              ║
// ║  original puede atenuarse. Transporta un dato genérico <T>.                 ║
// ║                                                                              ║
// ║  Parámetros clave:                                                          ║
// ║  • data              → el dato que viaja (String, objeto, etc.)             ║
// ║  • feedback          → widget flotante que sigue al dedo                    ║
// ║  • child             → widget en reposo                                     ║
// ║  • childWhenDragging → cómo se ve el original mientras se arrastra         ║
// ║  • delay             → espera antes de activar el drag                     ║
// ║  • onDragStarted / onDragEnd / onDraggableCanceled → callbacks             ║
// ║                                                                              ║
// ║  Variante: LongPressDraggable (requiere mantener presionado).               ║
// ╚══════════════════════════════════════════════════════════════════════════════╝
// 
// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║  DRAGTARGET                                                                 ║
// ║  Zona de destino donde se suelta un Draggable.                              ║
// ║  Detecta cuándo un Draggable está encima y reacciona (cambia color,         ║
// ║  acepta/rechaza el dato, ejecuta acciones al soltar).                       ║
// ║                                                                              ║
// ║  Parámetros clave:                                                          ║
// ║  • onWillAcceptWithDetails → valida si acepta el dato (return true/false)  ║
// ║  • onAcceptWithDetails     → se ejecuta al soltar EL dato                  ║
// ║  • onLeave                 → el Draggable salió sin soltar                 ║
// ║  • builder                 → construye la UI (recibe candidateData,        ║
// ║                               rejectedData)                                ║
// ║                                                                              ║
// ║  Flujo: presionar → feedback → mover → entrar (onWillAccept) →              ║
// ║         soltar (onAccept) / salir (onLeave)                                 ║
// ╚══════════════════════════════════════════════════════════════════════════════╝

void main() {
  runApp(const MiAppEducativa());
}

class MiAppEducativa extends StatelessWidget {
  const MiAppEducativa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ClipRRect & DragTarget',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const PaginaEjemplo(),
    );
  }
}

// =============================================================================
//  PÁGINA PRINCIPAL
//  Contiene las 3 secciones del ejemplo dentro de un scroll vertical.
// =============================================================================

class PaginaEjemplo extends StatelessWidget {
  const PaginaEjemplo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClipRRect & DragTarget — Explicación'),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SeccionClipRRect(),
            SizedBox(height: 32),
            _SeccionDrag(),
            SizedBox(height: 32),
            _SeccionCombinada(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  TEMA 1: CLIPRRECT
//  Compara 3 enfoques: sin recorte, con esquinas redondeadas, y circular.
//  La imagen es la misma; solo cambia el ClipRRect.
// ═══════════════════════════════════════════════════════════════════════════════

class _SeccionClipRRect extends StatelessWidget {
  const _SeccionClipRRect();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── TÍTULO DEL TEMA ───
        const Text(
          '1️⃣  ClipRRect — Recorte con esquinas redondeadas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // ─── DESCRIPCIÓN BREVE ───
        Text(
          'Compara 3 formas de mostrar una imagen con ClipRRect:',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),

        // ─── FILA DE EJEMPLOS: 3 variantes lado a lado ───
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // ── Variante 1: SIN ClipRRect ──
            //   La imagen se muestra directamente, bordes cuadrados.
            //   Útil para ver el "antes" de aplicar el recorte.
            Column(
              children: [
                const Text('Sin ClipRRect',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Image.network(
                  'https://picsum.photos/seed/gato/120/120',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const _Placeholder(color: Colors.red),
                ),
                const SizedBox(height: 6),
                Text('Cuadrado ❌',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),

            // ── Variante 2: ClipRRect con borderRadius: 20 ──
            //   Las 4 esquinas se redondean con radio 20.
            //   El resultado se ve más suave y moderno.
            Column(
              children: [
                const Text('ClipRRect básico',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://picsum.photos/seed/gato/120/120',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const _Placeholder(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 6),
                Text('Redondeado ✅',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),

            // ── Variante 3: ClipRRect circular ──
            //   borderRadius: 50 (mitad del ancho) → círculo perfecto.
            //   Ideal para avatares y fotos de perfil.
            Column(
              children: [
                const Text('ClipRRect circular',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    'https://picsum.photos/seed/gato/120/120',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const _Placeholder(color: Colors.green),
                  ),
                ),
                const SizedBox(height: 6),
                Text('Avatar ⭕',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  TEMA 2: DRAGGABLE + DRAGTARGET
//  Ejemplo interactivo de arrastrar y soltar.
//  Draggable envía un String; DragTarget lo recibe y muestra un SnackBar.
// ═══════════════════════════════════════════════════════════════════════════════

class _SeccionDrag extends StatefulWidget {
  const _SeccionDrag();

  @override
  State<_SeccionDrag> createState() => _SeccionDragState();
}

class _SeccionDragState extends State<_SeccionDrag> {
  // _recibido: true después de soltar el Draggable en el DragTarget.
  //   Cambia la UI a verde "✅ Recibido".
  bool _recibido = false;

  // _hover: true mientras un Draggable está flotando sobre el DragTarget.
  //   Cambia la UI a naranja "📥 Suelta aquí".
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── TÍTULO DEL TEMA ───
        const Text(
          '2️⃣  Draggable + DragTarget — Arrastrar y soltar',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // ─── DESCRIPCIÓN BREVE ───
        Text(
          'Arrastra el cuadro azul hasta la zona gris:',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),

        // ─── FILA PRINCIPAL: Draggable → flecha → DragTarget ───
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // ── DRAGGABLE ──
            //   Widget que el usuario arrastra. Transporta un String como dato.
            //   Parámetros:
            //     • data             → el dato que viaja
            //     • feedback         → lo que flota mientras se arrastra
            //     • child            → el widget en reposo
            //     • childWhenDragging→ cómo se ve el original al arrastrar
            //     • delay            → (opcional) espera antes del drag
            Draggable<String>(
              // data: el dato que recibe el DragTarget al soltar.
              //   Puede ser cualquier tipo (String, int, objeto, etc.).
              data: 'Hola desde Draggable',

              // feedback: widget visual que sigue al dedo mientras se arrastra.
              //   Se recomienda poner Material con elevation para efecto "flotante".
              feedback: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 120,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '✈️ Volando...',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // child: estado en reposo (cuando NO se está arrastrando).
              //   Se ve con color azul sólido y sombra para indicar que es "táctil".
              child: Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  '🟦 Arrástrame',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // ─── FLECHA VISUAL ───
            //   Indica la dirección del arrastre.
            const Icon(Icons.arrow_forward, size: 40, color: Colors.grey),

            // ── DRAGTARGET ──
            //   Zona donde se suelta el Draggable. Detecta presencia y reacciona.
            //   Parámetros:
            //     • onWillAcceptWithDetails → decide si acepta el dato
            //     • onAcceptWithDetails     → se ejecuta al soltar
            //     • onLeave                 → el Draggable salió sin soltar
            //     • builder                 → construye la UI según estado
            DragTarget<String>(
              // onWillAcceptWithDetails: se llama cuando un Draggable entra.
              //   Recibe details.data (el dato) y details.offset (posición).
              //   Retorna true para aceptar, false para rechazar.
              //   Aquí validas si el tipo de dato es correcto.
              onWillAcceptWithDetails: (details) {
                setState(() => _hover = true);
                return true;
              },

              // onLeave: se ejecuta cuando el Draggable sale del área sin soltar.
              //   Útil para resetear el feedback visual (ej: quitar el color naranja).
              onLeave: (_) {
                setState(() => _hover = false);
              },

              // onAcceptWithDetails: se ejecuta cuando el usuario SUELTA dentro.
              //   Aquí procesas el dato recibido (details.data).
              onAcceptWithDetails: (details) {
                setState(() {
                  _recibido = true;
                  _hover = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('📦 Recibido: "${details.data}"'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },

              // builder: construye la UI del DragTarget.
              //   Recibe:
              //     • candidateData → lista de datos flotando encima (vacía = nada)
              //     • rejectedData  → datos rechazados por onWillAccept
              //   La UI cambia según 3 estados:
              //     1. _recibido = true   → verde "✅ Recibido"
              //     2. candidateData > 0  → naranja "📥 Suelta aquí"
              //     3. estado inicial     → gris "📭 Suelta aquí"
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty;

                Color colorFondo;
                String texto;
                IconData icono;

                if (_recibido) {
                  colorFondo = Colors.green;
                  texto = '✅ Recibido';
                  icono = Icons.check_circle;
                } else if (isHovering || _hover) {
                  colorFondo = Colors.orange;
                  texto = '📥 Suelta aquí';
                  icono = Icons.downloading;
                } else {
                  colorFondo = Colors.grey.shade300;
                  texto = '📭 Suelta aquí';
                  icono = Icons.inbox;
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 160,
                  height: 100,
                  decoration: BoxDecoration(
                    color: colorFondo,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isHovering ? Colors.orange.shade700 : Colors.grey.shade400,
                      width: isHovering ? 3 : 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icono, color: Colors.white, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        texto,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ─── BOTÓN DE REINICIO ───
        //   Restaura _recibido y _hover a false para repetir el ejemplo.
        Center(
          child: TextButton.icon(
            onPressed: () => setState(() {
              _recibido = false;
              _hover = false;
            }),
            icon: const Icon(Icons.refresh),
            label: const Text('Reiniciar ejemplo'),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  TEMA 3: CLIPRRECT + DRAGGABLE + DRAGTARGET (Combinados)
//  Integra todo lo aprendido en un solo ejemplo:
//  - Imágenes con ClipRRect (estética) dentro de un Draggable (interacción)
//  - DragTarget que recibe el alimento y lo muestra
// ═══════════════════════════════════════════════════════════════════════════════

// ─── LISTA DE ALIMENTOS ───
//   Datos de ejemplo: cada uno tiene nombre e imagen para arrastrar.
const List<_Alimento> _alimentos = [
  _Alimento('🍔 Hamburguesa', 'https://picsum.photos/seed/hamburguesa/200/200'),
  _Alimento('🍕 Pizza', 'https://picsum.photos/seed/pizzaejemplo/200/200'),
  _Alimento('🍣 Sushi', 'https://picsum.photos/seed/sushiejemplo/200/200'),
];

// ─── MODELO DE DATO ───
//   Representa un alimento con nombre visible y URL de imagen.
class _Alimento {
  final String nombre;
  final String imagenUrl;
  const _Alimento(this.nombre, this.imagenUrl);
}

class _SeccionCombinada extends StatefulWidget {
  const _SeccionCombinada();

  @override
  State<_SeccionCombinada> createState() => _SeccionCombinadaState();
}

class _SeccionCombinadaState extends State<_SeccionCombinada> {
  // _alimentoRecibido: el último _Alimento soltado en el DragTarget.
  //   null = no se ha recibido nada todavía.
  _Alimento? _alimentoRecibido;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── TÍTULO DEL TEMA ───
        const Text(
          '3️⃣  ClipRRect + Draggable + DragTarget — JUNTOS',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // ─── DESCRIPCIÓN BREVE ───
        Text(
          'Arrastra un alimento (con ClipRRect) a la zona de abajo:',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),

        // ─── FILA DE ALIMENTOS ───
        //   Cada alimento se muestra en una tarjeta con ClipRRect,
        //   envuelta en un Draggable<_Alimento>.
        //   Al arrastrar:
        //     • feedback: imagen grande con elevación, también ClipRRect
        //     • childWhenDragging: la tarjeta original se vuelve 30% opaca
        //     • child: la tarjeta normal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _alimentos.map((alimento) {
            return Draggable<_Alimento>(
              data: alimento,

              feedback: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      alimento.imagenUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const _Placeholder(color: Colors.orange),
                    ),
                  ),
                ),
              ),

              childWhenDragging: Opacity(
                opacity: 0.3,
                child: _TarjetaAlimento(alimento: alimento),
              ),

              child: _TarjetaAlimento(alimento: alimento),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // ─── DRAGTARGET ───
        //   Zona de destino que recibe _Alimento.
        //   Muestra 3 estados:
        //     1. Vacío:           icono gris + "Arrastra un alimento aquí"
        //     2. Hovering:        icono naranja + "Suelta aquí tu alimento"
        //     3. Alimento soltado: imagen pequeña + nombre + "servido 🎉"
        DragTarget<_Alimento>(
          onWillAcceptWithDetails: (details) => true,

          onAcceptWithDetails: (details) {
            setState(() {
              _alimentoRecibido = details.data;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('🍽️ ${details.data.nombre} recibido en la mesa'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },

          builder: (context, candidateData, rejectedData) {
            final isHovering = candidateData.isNotEmpty;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: _alimentoRecibido != null
                    ? Colors.green.shade50
                    : (isHovering ? Colors.orange.shade50 : Colors.grey.shade100),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _alimentoRecibido != null
                      ? Colors.green
                      : (isHovering ? Colors.orange : Colors.grey.shade300),
                  width: isHovering ? 3 : 2,
                ),
              ),
              alignment: Alignment.center,
              child: _alimentoRecibido != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _alimentoRecibido!.imagenUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const _Placeholder(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_alimentoRecibido!.nombre} servido 🎉',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 48,
                          color: isHovering
                              ? Colors.orange
                              : Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isHovering
                              ? '📥 Suelta aquí tu alimento'
                              : '🍽️ Arrastra un alimento aquí',
                          style: TextStyle(
                            fontSize: 16,
                            color: isHovering
                                ? Colors.orange.shade700
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),

        const SizedBox(height: 12),

        // ─── BOTÓN DE REINICIO ───
        //   Restaura _alimentoRecibido a null para empezar de nuevo.
        Center(
          child: TextButton.icon(
            onPressed: () => setState(() => _alimentoRecibido = null),
            icon: const Icon(Icons.refresh),
            label: const Text('Reiniciar pedido'),
          ),
        ),
      ],
    );
  }
}

// ─── TARJETA DE ALIMENTO ───
//   Widget reutilizable que muestra una imagen con ClipRRect
//   y el nombre debajo. Usado como child del Draggable en TEMA 3.
class _TarjetaAlimento extends StatelessWidget {
  final _Alimento alimento;

  const _TarjetaAlimento({required this.alimento});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            alimento.imagenUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 80,
              height: 80,
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          alimento.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}

// ─── PLACEHOLDER ───
//   Respaldo visual cuando falla la carga de una imagen de red.
//   Muestra un icono de "imagen rota" con el color especificado.
class _Placeholder extends StatelessWidget {
  final Color color;
  const _Placeholder({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: color.withValues(alpha: 0.2),
      alignment: Alignment.center,
      child: Icon(Icons.broken_image, color: color, size: 40),
    );
  }
}

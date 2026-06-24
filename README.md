# CLIPRRECT · DRAGGABLE · DRAGTARGET

App demo en Flutter que explora tres widgets clave del framework mediante ejemplos interactivos. Todo el código está en [`lib/main.dart`](lib/main.dart).

---

## 1. ClipRRect — Recorte con esquinas redondeadas

Máscara de recorte que envuelve a un hijo y solo muestra la parte que cabe dentro de un rectángulo redondeado. Es como ponerle un "marco suave" a un widget.

### Parámetros clave

| Parámetro | Descripción |
|-----------|-------------|
| `borderRadius` | Radio de las esquinas (`circular`, `only`, `horizontal`, `vertical`) |
| `child` | El widget a recortar (`Image`, `Container`, etc.) |
| `clipper` | (Opcional) Recorte personalizado |
| `clipBehavior` | Calidad del recorte (`antiAlias`, `hardEdge`, `none`) |

### Usos comunes

Avatares, imágenes en tarjetas, botones, cualquier borde suave.

### En esta app

La sección `_SeccionClipRRect` compara tres variantes lado a lado:

1. **Sin ClipRRect** — la imagen se muestra con bordes cuadrados (el "antes").
2. **ClipRRect básico** — `borderRadius: 20` en las 4 esquinas para un aspecto moderno.
3. **ClipRRect circular** — `borderRadius: 50` (mitad del ancho) ideal para fotos de perfil.

---

## 2. Draggable — Arrastrar con el dedo

Widget que el usuario puede arrastrar con el dedo. Mientras se arrastra, un `feedback` visual sigue al dedo y el original puede atenuarse. Transporta un dato genérico `<T>`.

### Parámetros clave

| Parámetro | Descripción |
|-----------|-------------|
| `data` | El dato que viaja (`String`, objeto, etc.) |
| `feedback` | Widget flotante que sigue al dedo |
| `child` | Widget en reposo |
| `childWhenDragging` | Cómo se ve el original mientras se arrastra |
| `delay` | Espera antes de activar el drag |
| `onDragStarted` / `onDragEnd` / `onDraggableCanceled` | Callbacks |

### Variante

**LongPressDraggable** — requiere mantener presionado antes de arrastrar.

### En esta app

La sección `_SeccionDrag` muestra un `Draggable<String>` que envía el mensaje `"Hola desde Draggable"`. Mientras se arrastra, el feedback se ve como un cuadro azul con sombra flotante y el original permanece en su lugar. Al soltar, el dato viaja al `DragTarget`.

---

## 3. DragTarget — Zona de destino

Zona donde se suelta un `Draggable`. Detecta cuándo un elemento está encima y reacciona cambiando de color, aceptando o rechazando el dato, y ejecutando acciones al soltar.

### Parámetros clave

| Parámetro | Descripción |
|-----------|-------------|
| `onWillAcceptWithDetails` | Valida si acepta el dato (`return true/false`) |
| `onAcceptWithDetails` | Se ejecuta al soltar el dato |
| `onLeave` | El `Draggable` salió sin soltar |
| `builder` | Construye la UI (recibe `candidateData`, `rejectedData`) |

### Flujo completo

```
presionar → feedback → mover → entrar (onWillAccept) → soltar (onAccept) / salir (onLeave)
```

### En esta app

La sección `_SeccionDrag` implementa un `DragTarget<String>` con tres estados visuales:

- **Estado inicial** — gris, icono de bandeja vacía.
- **Hover** (Draggable encima) — naranja, icono de descarga, borde más grueso.
- **Recibido** — verde, icono de check, muestra un `SnackBar` con el dato recibido.

Hay un botón **Reiniciar** para repetir el ejemplo.

---

## 4. ClipRRect + Draggable + DragTarget — Ejemplo combinado

La sección `_SeccionCombinada` integra los tres widgets en un solo flujo:

- Tres tarjetas de "alimentos" (`_Alimento` con nombre e imagen).
- Cada tarjeta usa **ClipRRect** para redondear la imagen.
- Cada tarjeta está envuelta en un **Draggable<_Alimento>** que transporta el objeto completo.
- Un **DragTarget** en la parte inferior recibe el alimento y lo muestra con su imagen y nombre.
- Mientras se arrastra, la tarjeta original se vuelve 30% opaca (`childWhenDragging`) y el feedback es una versión más grande con elevación.

### Reinicio

Cada sección incluye un botón para reiniciar el estado y volver a intentar.

---

## Cómo ejecutar

```bash
flutter pub get
flutter run
```

Para compilar para web y desplegar:

```bash
flutter build web --base-href=/CLIPRRECT-DRAGGABLE-y-DRAGTARGET/
```

## Deploy automático

Al hacer push a `main`, un workflow de **GitHub Actions** (`.github/workflows/deploy.yml`) compila la app web y la publica en:

```
https://hibiinova.github.io/CLIPRRECT-DRAGGABLE-y-DRAGTARGET/
```

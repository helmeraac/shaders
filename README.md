# Taller shaders

## Integrantes

| Integrante | github nick |
|------------|-------------|
|      Helmer Andres Avendaño Vargas      |     helmeraac        |

## Objetivo

Utilizar shaders para implementar modelos de luces que simulen una interacción ambiental

## Descripción

Se utiliza el vertex shader para manipular la posicion de los vertices basados en texturas 2d y se utiliza el fragment shader para aplicar modelos de iluminacion con efectos ambientales basados en la distancia de la camara al objeto convincentes para el ojo del espectador.

## Discusión y trabaho futuro

Se logró un efecto creible y satisfactorio en la primera version de la implementación por ahora manejado unicamente con una fuente de luz. Como trabajo futuro se puede hacer la implementación de otras fuentes de luz para que interactuen con el modelo ambiental, ademas de generar un modelo de generación ambiental mas complejo que implemente interacciones fisicas como in/out scattering.

Referencias:
* https://stackoverflow.com/questions/21549456/how-to-implement-a-ground-fog-glsl-shader?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
* http://in2gpu.com/2014/07/22/create-fog-shader/
* https://www.opengl.org/sdk/docs/tutorials/ClockworkCoders/lighting.php
* http://www.opengl-tutorial.org/beginners-tutorials/tutorial-8-basic-shading/
* http://www.opengl-tutorial.org/intermediate-tutorials/tutorial-13-normal-mapping/
* http://fabiensanglard.net/bumpMapping/index.php
* https://www.opengl.org/discussion_boards/showthread.php/171839-How-to-use-a-height-map

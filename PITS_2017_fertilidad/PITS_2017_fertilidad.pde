PImage [][] imagen = new PImage [4][10];
PImage cursor_dedo;
int numero_paginas = 0;
int indice_pagina  = 1;
int indice_pagina_ant;
int idioma = 0;  // 0: cas; 1: gal; 2: ing
int idioma_ant;
int alfa = 0;
int xMouse;
// posición del cursor
  int cursorX;
  int cursorY = 458;
  int cursorW;
// posicion vertical texto ayuda
  int posicionY = 390;
long mili_segundos = 0; 
long segundos_reposo = 300;  //long cuadros_reposo = 3000;
float escalaX, escalaY;
// posicion de los botones
  int [] boton_X = {108, 178, 257, 368, 454, 524};   // frontera de botones
// visibilidad de la información complementarioa
boolean info_activa = false;


void setup()
{
  fullScreen();
  
  frameRate (25);
  
  // factores de escala en función del tamaño de la pantalla
  escalaX = width / 640.0;
  escalaY = height / 480.0;
  
  // Carga las imágenes
  String filename;
  cursor_dedo = loadImage("cursor_dedo.png");
  imagen [0][0] =loadImage("Inicio.png");
  
  for (int i=1; i<10; i++)
  {
    filename = "Castellano_" + nf(i) + ".png";
    imagen [0][i] =loadImage(filename); 
    if (imagen [0][i] == null)
    {
      numero_paginas = i-1;
      break;
    }
    else 
    {
      filename = "Gallego_" + nf(i) + ".png";
      imagen [1][i] =loadImage(filename); 
      filename = "Ingles_" + nf(i) + ".png";
      imagen [2][i] =loadImage(filename); 
    }
  }
  
  // Amplía las imágenes para llenar la pantalla
  cursor_dedo.resize(0, int(cursor_dedo.height * escalaY));
  cursorW = cursor_dedo.width/2;
  
  imagen[0][0].resize(width, height);
  for (int i=0; i < 3; i++)
  {
    for (int j=1; j<=numero_paginas; j++)
    {
      imagen[i][j].resize(width, height);
    }
  }
  
  // Calcula los límites de los botones
  for (int i=0; i<6; i++) boton_X[i] *= escalaX;
  
  // Calcula la posición del cursor
  cursorY *= escalaY;
  
  // Posición texto ayuda
  posicionY *= escalaY;

  idioma = 0;
  indice_pagina = 1;
  idioma_ant = idioma;
  indice_pagina_ant = indice_pagina;
  
  actualiza_imagen();
  
  mili_segundos = millis();
  
  print (numero_paginas);

}

void draw()
{
  noCursor();
  cursorX = boton_X[0]-cursorW + int (float(mouseX * (boton_X[5]-boton_X[0])) / width);
  
  if (alfa <255)
  {
    tint(255);
    image (imagen [idioma_ant][indice_pagina_ant], 0, 0);

    //alfa = 50;
    
    tint (255, alfa);
    image (imagen [idioma][indice_pagina], 0, 0);
    
    alfa +=20;
  }

  else
  {
    idioma_ant = idioma;
    indice_pagina_ant = indice_pagina;
    
    noTint();
    image (imagen [idioma][indice_pagina], 0, 0);
  }
  
  noTint();
  image (cursor_dedo, cursorX,   cursorY);
  
  // vuelve a la pantalla de inciio si no hya interacciones
  if ((millis()-mili_segundos)/1000 > segundos_reposo)
  {
    idioma = 0;
    indice_pagina = 1;
    actualiza_imagen();
  }  
  
  // muestra información de apoyo a los ajustes
  if (info_activa)
  {
    fill (0);
    text ("framerate = " + str(int (frameRate + 0.5)), 50, posicionY);
    text ("tiempo reposo = "+ int((millis()-mili_segundos)/1000), 50, posicionY+20);
    text ("posicionX = " + mouseX + " -> " + cursorX, 50, posicionY+40);
    
    stroke (0);
    strokeWeight (3);
    for (int i=0; i<6; i++) 
    {
      line (boton_X[i], height-100, boton_X[i], height);
      text (boton_X[i], boton_X[i]-10, height-110);
    }
  }
  
}


void mouseClicked() {
  if (millis() > mili_segundos + 1000)
  {
    cursorX = boton_X[0]-cursorW + int (float(mouseX * (boton_X[5]-boton_X[0])) / width);

    if (cursorX < boton_X[1])                    // Página anterior
       {
         if (indice_pagina > 1)
         {
           indice_pagina_ant = indice_pagina;
           indice_pagina--;
           actualiza_imagen();
         }
       }

    else if (cursorX < boton_X[2])               // Elige idioma inglés
       {
         if (idioma != 2) 
         {
           idioma_ant = idioma;
           idioma = 2;
           actualiza_imagen();
         }
       }
  
    else if (cursorX < boton_X[3])               // Elige idioma castellano
       {
         if (idioma != 0)
         {
           idioma_ant = idioma;
           idioma = 0;
           actualiza_imagen();
         }
       }
  
    else if (cursorX < boton_X[4])               // Elige idioma gallego  
       {
         if (idioma != 1) 
         {
           idioma_ant = idioma;
           idioma = 1;
           actualiza_imagen();
         }
       }
       
    else                                 // Página siguiente
      {
        if (indice_pagina < numero_paginas)
        {
          indice_pagina_ant = indice_pagina;
          indice_pagina++;
          actualiza_imagen();
        }
      }
   }
}

void keyPressed() 
{  
  if (key == 'q') info_activa = ! info_activa;
}

void actualiza_imagen()
{
  if (idioma != idioma_ant) indice_pagina = 1;
  alfa = 0;
  
  mili_segundos = millis();

  println ("idioma_ant: "+idioma_ant+"\tidioma: "+idioma+"\tindice_pagina_ant: "+indice_pagina_ant+"\tindice_pagina: "+indice_pagina);

}
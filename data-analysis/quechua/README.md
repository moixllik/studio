# Diccionario Quechua

> Análisis de diccionarios del idioma Quechua, con fuentes en varios formatos, gráficos informativos y conclusiones.

## Índice

1. Definición del problema
2. Plantear los objetivos
3. Obtener los datos
4. Preparar y optimizar los datos
5. Procesar y analizar los datos
6. Conclusiones

## Desarrollo

### 1. Definición del problema

El idioma quechua tiene dos vertientes en el uso de tres o cinco vocales.

### 2. Plantear los objetivos

* Describir las palabras en idioma Quechua según vocales.
* Listar las palabras en el idioma Quechua.
* Clasificar según las vocales más usadas.

### 3. Obtener los datos

El idioma Quechua cuenta con presencia en Internet y se dispone de diccionarios en varios formatos:

* Publicaciones de instituciones o autores individuales en formatos PDF, ePUB, etc.
* En formato para su fácil uso en Internet como Txt, Zip, etc.

```
python3 ./src/get_data.py
```

### 4. Preparar y optimizar los datos

Leer los archivos

```
python3 ./src/read_tsv.py

python3 ./src/read_zip.py

python3 ./src/read_pdf.py
```

### 5. Procesar y analizar los datos

```
python3 ./src/main.py
```

![fig1](./fig-1.png)

### 6. Conclusiones

* De una lista de 28 mil palabras distintas el uso más extendido es el de la vocal A, seguido de la U y finalmente la I.
* En la variante del quechua estudiado se tiene en cuenta las palabras importadas del español, las cuales pueden contener las vocales E y O.

# Parser para diputados

Scrapea el listado de diputados y genera un archivo JSON con esa informacion

## Instalacion

```bash
git clone https://github.com/congresointeractivo/parser-diputados.git
cd parser-diputados
bundle install
```

## Uso

```bash
Usage: parser_diputados.rb [options]
    -o, --output FILENAME            Save the output to a file
```

## Salida

```json
{
  bloques: [
    "COALICION CIVICA ARI - UNEN",
    "COMPROMISO FEDERAL",
    "CONSERVADOR POPULAR",
    "CULTURA, EDUCACION Y TRABAJO",
    ...
  ],
  diputados: [
    {
      apellido: "ABDALA DE MATARAZZO",
      nombre: "NORMA AMANDA",
      provincia: " SANTIAGO DEL ESTERO",
      bloque: "FRENTE CIVICO POR SANTIAGO",
      inicio_mandato: "10/12/2013",
      fin_mandato: "09/12/2017",
      email: "nabdaladem@diputados.gob.ar",
      url: "http://www.diputados.gov.ar/diputados/nabdaladem/",
      imagen_url: "http://www4.hcdn.gob.ar/fotos/nabdaladem.jpg"
    },
    {
      apellido: "ABRAHAM",
      nombre: "ALEJANDRO",
      provincia: " MENDOZA",
      bloque: "FRENTE PARA LA VICTORIA - PJ",
      inicio_mandato: "10/12/2013",
      fin_mandato: "09/12/2017",
      email: "aabraham@diputados.gob.ar",
      url: "http://www.diputados.gov.ar/diputados/aabraham/",
      imagen_url: "http://www4.hcdn.gob.ar/fotos/aabraham.jpg"
    },
    ...
  ]
}
```

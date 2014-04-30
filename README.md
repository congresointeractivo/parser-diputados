# Parser para diputados

Scrapea el listado de diputados y genera un archivo JSON con esa informacion

## Instalacion

```bash
git clone https://github.com/congresointeractivo/parser-diputados.git
cd parser-diputados
bundle install
```
## Ejemplos
```
parser_diputados
```

Otros ejemplos:

```
parser_diputados -o diputados.json
parser_diputados | python -mjson.tool
```


```
parser_diputados_popit 
```

Versión que envía los resultados a la API de PopIt en popit.mysociety.org usando popit-ruby

###Uso: 

```bash
parser_diputados_popit [options]
    -o, --output FILENAME            Save the output to a file
    -i, --instance INSTANCE_NAME    Save data to a PopIt instance in popit.mysociety.org using popit-ruby
    -u, --user USERNAME   API Username
    -p, --password PASSWORD API Password
```


###Ejemplo
```
parser_diputados.rb -i legisladores-ar -u youruser -p yourpassword
```
=======


## Uso

```bash
parser_diputados [options]
  -h, --help            Displays help message
  -o, --output FILENAME Save the output to a file
```

## Salida

TODO

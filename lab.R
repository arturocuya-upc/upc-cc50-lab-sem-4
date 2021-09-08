# instalamos paquetes
#install.packages("rvest")
#install.packages("xml")
#install.packages("XML")

library(rvest)
library(xml)
library(XML)

# Scraping web upc
upc_url <- 'https://pregrado.upc.edu.pe/facultad-de-ingenieria/ciencias-de-la-computacion/'

# leer cada linea de la web
upc_read <- readLines(upc_url, encoding="UTF-8", warn=FALSE)
parsed_upc <- htmlParse(upc_read, encoding="UTF-8")

# separar por parrafos
upc_enter_text <- parsed_upc["//p"]

# numero de parrafos
length(upc_enter_text)

# visualizar contenido de algunos parrafos
upc_enter_text[[10]]

# ver numero de enlaces
length(getHTMLLinks(upc_read))

# numero de tablas
length(readHTMLTable(upc_read))

# no hay tablas. veremos wikipedia
wiki_url <- "https://es.wikipedia.org/wiki/Ayuda:Tablas"
wiki_read <- readLines(wiki_url, encoding="UTF-8", warn=FALSE)
parsed_wiki <- htmlParse(wiki_read, encoding="UTF-8")
wiki_intro_text <- parsed_wiki["//p"]
length(wiki_intro_text)

length(getHTMLLinks(wiki_read))

length(readHTMLTable(wiki_read))

# aqui si hay tablas
names(readHTMLTable(wiki_read))

# un valor distinto a null
readHTMLTable(wiki_read)$"Una tabla ejemplo\n"


# Otro caso, scrapear IMDb
library(xml2)
library(rvest)

pelis <- read_html("https://www.imdb.com/search/title/?count=100&release_date=2020,2020&title_type=feature")

# clasificacion
rank_data_html <- html_nodes(pelis, '.text-primary')
rank_data <- html_text(rank_data_html)
rank_data <- as.numeric(rank_data)
head(rank_data)

# titulos de la pelicula
tit_data_html <- html_nodes(pelis, '.lister-item-header a')
tit_data <- html_text(tit_data_html)
head(tit_data)

# descripción de la pelicula
desc_data_html <- html_nodes(pelis, '.ratings-bar+ .text-muted')
desc_data <- html_text(desc_data_html)
head(desc_data)

# eliminamos \n en cada parrafo
desc_data <- gsub("\n","",desc_data)
head(desc_data)

# duracion de la pelicula
runtime_data_html <- html_nodes(pelis, '.text-muted .runtime')
runtime_data <- html_text(runtime_data_html)
head(runtime_data)

# eliminar "min" de cada elemento y convertir a numerico
runtime_data<-gsub(" min","",runtime_data)
runtime_data <- as.numeric(runtime_data)
head(runtime_data)

# obtener genero de pelicula
genre_data_html <- html_nodes(pelis, '.genre')
genre_data <- html_text(genre_data_html)
head(genre_data)

# eliminar newlines y especios en exceso
genre_data<-gsub("\n","",genre_data) 
genre_data<-gsub(" ","",genre_data)

# tomar solo el primer genero
genre_data<-gsub(",.*","",genre_data)

# convertir cada genero a un factor
genre_data<-as.factor(genre_data)


# obtener calificacion de pelicula
rating_data_html <- html_nodes(pelis,'.ratings-imdb-rating strong') 
rating_data <- html_text(rating_data_html)

# convertir cada texto a numero
rating_data<-as.numeric(rating_data) 


# obtener metascore de pelicula
metascore_data_html <- html_nodes(pelis,'.metascore') 
metascore_data <- html_text(metascore_data_html) 
head(metascore_data) 

# eliminar espacios excedentes y convertir a numerico
metascore_data<-gsub(" ","",metascore_data) 
metascore_data<-as.numeric(metascore_data)
head(metascore_data)

# obtener votos por pelicula
votos_data_html <- html_nodes(pelis,'.sort-num_votes-visible span:nth-child(2)') 
votos_data <- html_text(votos_data_html)

# remover comas y convertir a numero
votos_data<-gsub(",","",votos_data) 
votos_data<-gsub(",","",votos_data) 
head(votos_data)

# obtener gross earning de la pelicula
gross_data_html <- html_nodes(pelis,'.ghost~ .text-muted+ span') 
gross_data <- html_text(gross_data_html) 
head(gross_data)

# eliminar signos $ y M, y convertir a numerico
gross_data<-gsub("M","",gross_data) 
gross_data<-substring(gross_data,2,6)
gross_data<-as.numeric(gross_data)
head(gross_data)

# obtener director de la pelicula
director_data_html <- html_nodes(pelis,'.text-muted+ p a:nth-child(1)') 
director_data <- html_text(director_data_html) 
head(director_data)

# convertir cada director a factor
director_data<-as.factor(director_data) 
head(director_data) 

# obtener actores de la pelicula
actor_data_html <- html_nodes(pelis,'.lister-item-content .ghost+ a') 
actor_data <- html_text(actor_data_html) 
head(actor_data)

# convertir cada actor a factor
actor_data<-as.factor(actor_data) 
head(actor_data)



# almacenar el dataset obtenido
pelis_df<-data.frame(Rank = rank_data, Titulo = tit_data, Runtime = runtime_data,  Genero = genre_data, Director = director_data, Actor = actor_data)

# error: arguments imply differing number of rows: 100, 99 ??
# aquí me quedé. no me dio tiempo de encontrar por qué ocurre este error

# estructura del dataframe
#str(pelis_df)

# guardamos en un csv
#write.csv(pelis_df, 'pelis_df.csv', row.names=TRUE)

# visualización de datos
#install.packages("ggplot2")
#library('ggplot2')
#qplot(data=pelis_df, Runtime, fill=Genero, bins=30, main="Pelicula: Duración vs. Género")







################################################################################
########                     Raccordement des séries                    ########
################################################################################


# Chargement des packages ------------------------------------------------------

library("dygraphs")
library("JDCruncheR")
library("ggplot2")


# Chargement des fonctions -----------------------------------------------------

source("./R/function/utility.R", encoding = "UTF-8")
source("./R/function/best_cut.R", encoding = "UTF-8")
source("./R/function/get_score.R", encoding = "UTF-8")


# Chargement des outputs -------------------------------------------------------

# options(cruncher_bin_directory = "C:/Users/UTZK0M/Software/jwsacruncher-2.2.4/bin")
# getOption("cruncher_bin_directory")
# 
# cruncher_and_param(workspace = "./WS/ws_new.xml",
#                    rename_multi_documents = FALSE, # Pour renommer les dossiers en sortie : pas utile ici
#                    delete_existing_file = TRUE, # Pour remplacer les sorties existantes
#                    policy = "parameters", # Politique de rafraichissement
#                    csv_layout = "vtable", # Format de sortie des tables
#                    log_file = "log.txt"
# )
# 
# cruncher_and_param(workspace = "./WS/ws_anc.xml",
#                    rename_multi_documents = FALSE, # Pour renommer les dossiers en sortie : pas utile ici
#                    delete_existing_file = TRUE, # Pour remplacer les sorties existantes
#                    policy = "parameters", # Politique de rafraichissement
#                    csv_layout = "vtable", # Format de sortie des tables
#                    log_file = "log.txt"
# )


# Récupération des séries ------------------------------------------------------

old_cvs <- read.csv("./WS/ws_anc/Output/SAProcessing-1/series_sa.csv", 
                    sep = ";", check.names = FALSE, dec = ",")[, -1] |> 
    ts(start = 1990, frequency = 12)

new_cvs <- read.csv("./WS/ws_new/Output/SAProcessing-1/series_sa.csv", 
                    sep = ";", check.names = FALSE, dec = ",")[, -1] |> 
    ts(start = 2012, frequency = 12)

brutes <- read.csv("./data/IPI_nace4.csv", 
                   sep = ";", check.names = FALSE)[, -1] |> 
    ts(start = 1990, frequency = 12)

serie_a_expertiser <- intersect(colnames(new_cvs), colnames(old_cvs))
serie_a_recuperer <- c(setdiff(colnames(new_cvs), colnames(old_cvs)), 
                       setdiff(colnames(old_cvs), colnames(new_cvs)))


# Paramètres du raccord --------------------------------------------------------

start2 <- as.Date('2012-01-01')
end2 <- as.Date('2014-12-01')

start2_ts <- date2date_ts(start2)
end2_ts <- date2date_ts(end2)


# Création des graphiques ------------------------------------------------------

id_serie <- serie_a_expertiser[1]

create_graph(id_serie)
create_graph2(id_serie)

get_all_score(id_serie)
get_all_combined_scores(list_id_serie = serie_a_expertiser) |> plot_score()

get_all_contribution() |> 
    window(start = c(2012, 01), end = c(2012, 01)) |> 
    plot_contribution(nb = 5)

get_all_score("RF2342") |> plot_score()


# Création doc rmd -------------------------------------------------------------

rmarkdown::render("./R/Rapport.Rmd")

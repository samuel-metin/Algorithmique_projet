# Chargement du package (nécessaire pour accéder aux fonctions C++ exportées)
library(Algo)

one.simu <- function(n, func, R = 0.25, seed = NULL) {
  
  if (!is.null(seed)) set.seed(seed)
  
  # Génération des données (Liste de vecteurs)
  Z <- lapply(seq_len(n), function(i) c(runif(1), runif(1)))
  
  # Mesure du temps selon la fonction demandée
  # On utilise le switch pour diriger vers la bonne version (R ou C++)
  t <- switch(func,
              # --- Versions R ---
              greedy = system.time(greedy_SetCover(Z, R))[["elapsed"]],
              naive  = system.time(naive_SetCover(Z, R))[["elapsed"]],
              branch = system.time(branch_bound_SetCover(Z, R))[["elapsed"]],
              
              # --- Versions C++ (Ajoutées) ---
              # Noms basés sur ton fichier RcppExports.R
              greedy_cpp = system.time(greedy_SetCover_cpp(Z, R))[["elapsed"]],
              naive_cpp  = system.time(naive_SetCover_cpp(Z, R))[["elapsed"]],
              branch_cpp = system.time(branch_bound_SetCover_cpp(Z, R))[["elapsed"]],
              
              NA # Cas par défaut
  )
  return(t)
}

# Paramètres de simulation
# Attention : Naive R est très lent, on garde des N raisonnables. 
# Pour voir la puissance du C++, on pourrait aller plus haut, mais il faut que R suive pour la comparaison.
vector_n <- c(5L, 8L, 10L, 11L) 
nbRep <- 5L

# Liste complète des 6 algorithmes à tester
funcs <- c("greedy", "naive", "branch", "greedy_cpp", "naive_cpp", "branch_cpp")

# Création de la grille de simulation
res <- expand.grid(n = vector_n, func = funcs, rep = seq_len(nbRep), stringsAsFactors = FALSE)
res$time <- NA_real_

# Boucle d'exécution
for (i in seq_len(nrow(res))) {
  # On utilise un seed unique par itération pour reproductibilité
  # mais différent à chaque ligne pour varier les données
  res$time[i] <- one.simu(res$n[i], func = res$func[i], seed = sample.int(1e6, 1))
}

# Agrégation des résultats (Moyenne)
agg <- aggregate(time ~ n + func, data = res, FUN = mean)

print(agg)

# --- Graphique ---

# Remise en forme pour matplot (Colonnes = Algorithmes)
mat <- reshape(agg, idvar = "n", timevar = "func", direction = "wide")
x <- mat$n
y <- as.matrix(mat[ , grep("^time", names(mat)) ])

# Nettoyage des noms de colonnes pour la légende (enlève "time.")
col_names <- gsub("time\\.", "", colnames(y))

# Tracé
matplot(x, y, type = "b", pch = 19, lty = 1, xaxt = "n",
        xlab = "Taille des données (n)", ylab = "Temps moyen (s)",
        main = "Comparaison R vs C++")

axis(1, at = x, labels = x)

# Légende dynamique
legend("topleft", legend = col_names, 
       col = 1:length(col_names), pch = 19, lty = 1, cex = 0.8)

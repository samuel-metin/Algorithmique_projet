# Fichier: Tests.R
# Ce script lance les simulations et stocke les résultats dans la variable 'res'

# Chargement du package
library(Algo)

# Fonction de simulation unique (Adaptée pour R et C++)
one.simu <- function(n, func, R = 0.25, seed = NULL) {
  
  if (!is.null(seed)) set.seed(seed)
  
  # Génération des données (Liste de vecteurs)
  Z <- lapply(seq_len(n), function(i) c(runif(1), runif(1)))
  
  # Mesure du temps selon la fonction demandée
  # Utilisation de try() pour éviter l'arrêt en cas d'erreur ponctuelle
  t <- switch(func,
              # --- Versions R ---
              greedy = system.time(greedy_SetCover(Z, R))[["elapsed"]],
              naive  = system.time(naive_SetCover(Z, R))[["elapsed"]],
              branch = system.time(branch_bound_SetCover(Z, R))[["elapsed"]],
              
              # --- Versions C++ (Via le package Algo) ---
              greedy_cpp = system.time(greedy_SetCover_cpp(Z, R))[["elapsed"]],
              naive_cpp  = system.time(naive_SetCover_cpp(Z, R))[["elapsed"]],
              branch_cpp = system.time(branch_bound_SetCover_cpp(Z, R))[["elapsed"]],
              
              NA # Par défaut
  )
  return(t)
}

# --- Paramètres de Simulation ---
R_val <- 0.25
nbRep <- 5L

# Définition des scénarios (n) et des algos à tester
# On évite de lancer Naive R sur des n trop grands (>12)
scenarios <- list(
  list(n = c(5L, 8L, 10L),      funcs = c("greedy", "naive", "branch", "greedy_cpp", "naive_cpp", "branch_cpp")),
  list(n = c(12L, 14L),         funcs = c("greedy", "branch", "greedy_cpp", "naive_cpp", "branch_cpp")),
  list(n = c(16L, 18L, 20L),    funcs = c("greedy", "greedy_cpp", "branch_cpp"))
)

# Liste pour stocker les résultats temporaires
res_list <- list()

# Boucle d'exécution
for (scen in scenarios) {
  grid <- expand.grid(n = scen$n, func = scen$funcs, rep = seq_len(nbRep), stringsAsFactors = FALSE)
  grid$time <- NA_real_
  
  for (i in seq_len(nrow(grid))) {
    # Seed unique par répétition pour comparer équitablement
    current_seed <- grid$rep[i] * 1000 + grid$n[i] 
    
    val <- one.simu(n = grid$n[i], func = grid$func[i], R = R_val, seed = current_seed)
    grid$time[i] <- val
  }
  res_list[[length(res_list) + 1]] <- grid
}

# Assemblage du tableau final 'res'
res <- do.call(rbind, res_list)
res <- res[!is.na(res$time), ] # Nettoyage

# Calcul des moyennes pour l'analyse
agg_res <- aggregate(time ~ n + func, data = res, FUN = mean)

# Ajout d'infos pour les graphes
agg_res$Lang <- ifelse(grepl("_cpp", agg_res$func), "C++", "R")
agg_res$Algo <- sub("_cpp", "", agg_res$func)

# tests/test-time.R
# La taille du rayon impacte fortement les temps d'execution R=0.02 favorise naive

one.simu <- function(n, func, R = 0.25, seed = NULL) {
  
  if (!is.null(seed)) set.seed(seed)
  
  # Génération des données (Liste de vecteurs)
  Z <- lapply(seq_len(n), function(i) c(runif(1), runif(1)))
  
  # Mesure du temps selon la fonction demandée
  # On utilise try() pour éviter de planter le knit en cas d'erreur ponctuelle
  # Les fonctions _cpp viennent du package Algo chargé précédemment
  
  t <- switch(func,
              # --- Versions R ---
              greedy = system.time(greedy_SetCover(Z, R))[["elapsed"]],
              naive  = system.time(naive_SetCover(Z, R))[["elapsed"]],
              branch = system.time(branch_bound_SetCover(Z, R))[["elapsed"]],
              
              # --- Versions C++ (Ajoutées) ---
              greedy_cpp = system.time(greedy_SetCover_cpp(Z, R))[["elapsed"]],
              naive_cpp  = system.time(naive_SetCover_cpp(Z, R))[["elapsed"]],
              branch_cpp = system.time(branch_bound_SetCover_cpp(Z, R))[["elapsed"]],
              
              NA # Cas par défaut
  )
  return(t)
}

vector_n <- c(5L,10L)#10L, 15L, 20L, 25L) # taille des Z
nbRep <- 3L
funcs <- c("greedy","naive","branch")

res <- expand.grid(n = vector_n, func = funcs, rep = seq_len(nbRep), stringsAsFactors = FALSE)
res$time <- NA_real_
for (i in seq_len(nrow(res))) {
  res$time[i] <- one.simu(res$n[i], func = res$func[i], seed = sample.int(1e6,1))
}

agg <- aggregate(time ~ n + func, data = res, FUN = mean)
#print(agg)

# plot: mean time vs n for each algo
mat <- reshape(agg, idvar = "n", timevar = "func", direction = "wide")
x <- mat$n
y <- as.matrix(mat[ , grep("^time", names(mat)) ])
matplot(x, y, type = "b", pch = 19, lty = 1, xaxt = "n",
        xlab = "data length", ylab = "mean time (s)")
axis(1, at = x, labels = x)
legend("topleft", legend = funcs, col = 1:length(funcs), pch = 19, lty = 1)

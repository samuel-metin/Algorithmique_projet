
covers_all <- function(solution, coverage, n) {
  covered <- c()
  for (i in 1:n) {
    if (solution[i] == 1) {
      covered <- union(covered, coverage[[i]])
    }
  }
  return(length(covered) == n)
}

branch_bound_SetCover <- function(Z, R) {

  n <- length(Z)

  dist_eucl <- function(a, b) sqrt(sum((a - b)^2))

  coverage <- vector("list", n)
  for (i in 1:n) {
    cov <- c()
    for (j in 1:n) {
      if (dist_eucl(Z[[i]], Z[[j]]) <= R) {
        cov <- c(cov, j)
      }
    }
    coverage[[i]] <- cov
  }

  best_k <<- n + 1
  best_solution <<- rep(0, n)

  explore <- function(depth, solution, k) {
    if (length(solution) == 0) {
      return()
    }
    # si la profondeur depth de ce chemin on a déjà trop d'antennes on abandonne
    if (k >= best_k) return()

    # si on a parcouru le chemin entier (chaque Zi) on met a jour best_k (car k < best_k forcément ici)
    if (depth > n) {
      if (covers_all(solution, coverage, n)) {
        best_k <<- k
        best_solution <<- solution
      }
      return()
    }

    # branche 1 : antenne sur i
    solution[depth] <- 1
    explore(depth + 1, solution, k + 1)

    # branche 2 : pas d’antenne sur i
    solution[depth] <- 0
    explore(depth + 1, solution, k)
  }

  # on explore l'arbre en partant d'en haut, aucune antenne au départ
  explore(depth=1, solution=rep(0, n), k=0)

  return(which(best_solution == 1))
}


Z <- list(
  c(0,0),
  c(1,0),
  c(1,1),
  c(0,1)
)

#branch_bound_SetCover(Z, R = 1.41)

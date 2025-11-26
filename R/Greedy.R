
greedy_SetCover <- function(Z, R) {
  n <- length(Z)

  # distance euclidienne
  dist_eucl <- function(a, b) sqrt(sum((a - b)^2))

  uncovered <- 1:n        # maisons non couvertes au départ
  selected  <- c()        # stations sélectionnées

  while (length(uncovered) > 0) {

    best_station <- NULL
    best_cover <- c()

    # On teste chaque Zi comme future station potentielle
    for (i in 1:n) {

      # Maisons couvertes par une antenne placée en Zi
      cover_i <- c()
      for (j in uncovered) {
        if (dist_eucl(Z[[i]], Z[[j]]) <= R) {
          cover_i <- c(cover_i, j)
        }
      }

      # On garde celle qui couvre le plus
      if (length(cover_i) > length(best_cover)) {
        best_cover <- cover_i
        best_station <- i
      }
    }

    # on ajoute la meilleure station
    selected <- c(selected, best_station)

    # on marque les maisons qu'elle couvre comme "couvertes"
    uncovered <- setdiff(uncovered, best_cover)
  }

  # Résultat
  return(selected)
}

Z <- list(
  c(0,0),
  c(1,0),
  c(1,1),
  c(0,1)
)

#greedy_SetCover(Z, R = 1.4)

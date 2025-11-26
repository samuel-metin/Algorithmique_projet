naive_SetCover <- function(Z, R) {
  # Z : liste de positions des stations candidates
  # R : rayon de couverture
  #
  # Z[[i]] doit être un vecteur numérique, ex : c(x, y)
  #
  # Ex :
  # Z <- list(c(0,0), c(1,0), c(0,2))

  n <- length(Z)

  # fonction distance euclidienne
  dist_eucl <- function(a, b) sqrt(sum((a - b)^2))

  # on teste k = 1, 2, ..., n
  for (k in 1:n) {

    combs <- combn(1:n, k, simplify = FALSE)

    for (stations in combs) {

      # pour chaque point cible z, vérifier s'il est couvert par AU MOINS une station
      all_covered <- TRUE

      for (i in 1:n) {   # i parcourt chaque point z dans Z
        z <- Z[[i]]

        covered <- FALSE
        for (s in stations) {
          if (dist_eucl(z, Z[[s]]) <= R) {
            covered <- TRUE
            break
          }
        }

        # si ce point n'est pas couvert, la combinaison est invalide
        if (!covered) {
          all_covered <- FALSE
          break
        }
      }

      # si tous les points sont couverts → solution optimale trouvée
      if (all_covered) {
        return(stations)
      }
    }
  }
}

Z <- list(
  c(0,0),
  c(1,0),
  c(1,1),
  c(0,1)
)

#naive_SetCover(Z, R = 1.2)

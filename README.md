# Package `Algo` : Set Cover Problem Solver

![Language](https://img.shields.io/badge/Language-R%20%7C%20C%2B%2B-blue)
![License](https://img.shields.io/badge/License-GPL--3-green)

Ce package R implémente plusieurs algorithmes pour résoudre le **Problème de la Couverture par Ensembles (Set Cover Problem)**, un problème d'optimisation combinatoire NP-difficile.

Il a été développé dans le cadre du projet d'Algorithmique du Master 2 Data Science (Université d'Evry).

## Objectifs et Fonctionnalités

Le package propose **3 approches** algorithmiques, chacune implémentée en **R (pur)** (pour la compréhension) et en **C++ (via Rcpp)** (pour la performance) afin de comparer les temps d'exécution.

| Algorithme | Type | Complexité | Description |
| :--- | :--- | :--- | :--- |
| **Naïf (Force Brute)** | Exact | Exponentielle $O(2^n \cdot n^2)$ | Explore toutes les combinaisons possibles. |
| **Branch & Bound** | Exact | Exponentielle $O(2^n)$ (pire cas) | Exploration intelligente de l'arbre avec élagage (Pruning). |
| **Glouton (Greedy)** | Approché | Polynomiale $O(n^3)$ | Heuristique choisissant localement la meilleure station. |

## Installation

Vous pouvez installer la version de développement directement depuis GitHub via la console R :

```r
# Si le package 'remotes' n'est pas installé
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

# Installation du package Algo
remotes::install_github("samuel-metin/Algorithmique_projet")




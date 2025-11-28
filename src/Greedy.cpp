// greedy.cpp

// [[Rcpp::plugins(cpp17)]] 
// [[Rcpp::rng(global)]]

#include <Rcpp.h>
#include <cmath>
#include <vector>
#include "utils.h"
using namespace Rcpp;


// [[Rcpp::export]]
IntegerVector greedy_SetCover_cpp(List Z, double R) {
  int n = Z.size();
  std::vector<int> uncovered(n);
  for(int i=0;i<n;i++) uncovered[i] = i;
  std::vector<int> selected;

  while(!uncovered.empty()) {
    int best_i = -1;
    int best_count = -1;

    for(int i=0;i<n;i++) {
      NumericVector zi = Z[i];
      int cnt = 0;
      for(int j : uncovered) {
        NumericVector zj = Z[j];
        if(dist_eucl(zi,zj) <= R) cnt++;
      }
      if(cnt > best_count) {
        best_count = cnt;
        best_i = i;
      }
    }

    selected.push_back(best_i + 1); // +1 pour R index

    // mettre à jour les maisons non couvertes
    std::vector<int> new_uncovered;
    NumericVector best_z = Z[best_i];
    for(int j : uncovered) {
      NumericVector zj = Z[j];
      if(dist_eucl(best_z, zj) > R) new_uncovered.push_back(j);
    }
    uncovered = new_uncovered;
  }

  return wrap(selected);
}

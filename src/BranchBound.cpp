// [[Rcpp::plugins(cpp17)]] 
// [[Rcpp::rng(global)]]

#include <Rcpp.h>
#include <cmath>
#include <vector>
#include "utils.h"
using namespace Rcpp;

// vérifie si une solution couvre toutes les maisons
bool covers_all(const std::vector<int>& solution,
                const std::vector< std::vector<int> >& coverage,
                int n) {
  std::vector<bool> covered(n, false);
  for(int i=0; i<n; i++) {
    if(solution[i]==1) {
      for(int j : coverage[i]) covered[j] = true;
    }
  }
  for(bool c : covered) if(!c) return false;
  return true;
}

// [[Rcpp::export]]
IntegerVector branch_bound_SetCover_cpp(List Z, double R) {
  int n = Z.size();

  // pré-calcul des couvertures
  std::vector< std::vector<int> > coverage(n);
  for(int i=0;i<n;i++) {
    NumericVector zi = Z[i];
    std::vector<int> cov;
    for(int j=0;j<n;j++) {
      NumericVector zj = Z[j];
      if(dist_eucl(zi,zj) <= R) cov.push_back(j);
    }
    coverage[i] = cov;
  }

  std::vector<int> best_solution(n,0);
  int best_k = n+1;

  // exploration récursive
  std::function<void(int,std::vector<int>&,int)> explore = [&](int depth, std::vector<int>& sol, int k){
    if(k >= best_k) return;
    if(depth >= n) {
      if(covers_all(sol, coverage, n)) {
        best_k = k;
        best_solution = sol;
      }
      return;
    }

    // branche 1 : mettre une antenne
    sol[depth] = 1;
    explore(depth+1, sol, k+1);

    // branche 2 : pas d'antenne
    sol[depth] = 0;
    explore(depth+1, sol, k);
  };

  std::vector<int> solution(n,0);
  explore(0, solution, 0);

  // convertir en indices R 1-based
  std::vector<int> res;
  for(int i=0;i<n;i++) if(best_solution[i]==1) res.push_back(i+1);
  return wrap(res);
}


#include <Rcpp.h>
#include <cmath>
#include <vector>
#include "utils.h"
using namespace Rcpp;


// [[Rcpp::export]]
IntegerVector naive_SetCover_cpp(List Z, double R) {
  int n = Z.size();
  std::vector<int> indices(n);
  for(int i = 0; i < n; i++) indices[i] = i;

  // générer toutes les combinaisons de 1..n
  for(int k = 1; k <= n; k++) {
    std::vector<int> comb(k);
    std::function<bool(int,int)> search = [&](int start,int depth) {
      if(depth == k) {
        // vérifier si tous les points sont couverts
        bool all_covered = true;
        for(int i=0;i<n;i++) {
          NumericVector zi = Z[i];
          bool covered = false;
          for(int s : comb) {
            NumericVector zs = Z[s];
            if(dist_eucl(zi,zs) <= R) { covered = true; break; }
          }
          if(!covered) { all_covered = false; break; }
        }
        if(all_covered) return true;
        else return false;
      }
      for(int i=start;i<n;i++) {
        comb[depth] = i;
        if(search(i+1, depth+1)) return true;
      }
      return false;
    };
    if(search(0,0)) {
      // convertir comb à R index (1-based)
      IntegerVector res(k);
      for(int i=0;i<k;i++) res[i] = comb[i]+1;
      return res;
    }
  }
  return IntegerVector(0); // fallback
}

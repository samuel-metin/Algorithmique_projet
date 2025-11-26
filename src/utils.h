#ifndef UTILS_H
#define UTILS_H

#include <Rcpp.h>
inline double dist_eucl(Rcpp::NumericVector a, Rcpp::NumericVector b) {
  double sum = 0.0;
  for(int i=0;i<a.size();i++){ double d = a[i]-b[i]; sum += d*d; }
  return std::sqrt(sum);
}

#endif

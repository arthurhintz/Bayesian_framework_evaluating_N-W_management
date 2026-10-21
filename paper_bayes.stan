functions {
  // LINEX Loss
  real LINEX(real a, real y, real psi) {
    return exp(psi * (a - y)) - psi * (a - y) - 1;
    //return exp(psi * (a - y));
  }
  
  //Square Loss
  real SL(real a, real y, real psi) {
     return (psi * (a - y)) ^ 2;
  }
  
  // PTL potential function
  real PTL(real a, real y, real psi) {
    return pow(abs(a - y), (psi-1));
  }
  
  // Potential asymetric
  real ASY_POT(real a, real y, real psi){

  real r = a - y;

  if (a > 0)
    return -2 * psi * pow(abs(r), 0.75);
  else
    //return -8 * psi * pow(abs(r), 0.75);
    return exp(psi * (r));
  }

}


data {
  int<lower=0> N;
  int<lower=0> N_test;
  int<lower=1> K;          // number of mixture components (Year)
  array[N] int<lower=1, upper=K> year;   // year id per observation

  //y-data
  vector[N] y; //profit

  //x-data
  vector[N] x1; //Nitrogen
  vector[N] x2; //Irrigation
  
  real psi; 
  
  vector[N_test] act_x1; //N test
  vector[N_test] act_x2; //I test  
}


parameters {
  //unknown parameters
  real b0;
  real b1;
  real b2;
  real b3;
  real b4;
  real b5;

  real<lower=1e-6> sigma;
  real alpha; 
  
  real<lower=0> sigma_u;     // sd of year random intercepts
  vector[K] z_u;              // non-centered year effects
}

transformed parameters {
  vector[N] mu;
  vector[K] u = sigma_u * z_u;   // year random intercepts
  
  for (n in 1:N) {
    mu[n] = b0 + u[year[n]]
            + b1 * x1[n] + b2 * x2[n]
            + b3 * square(x1[n]) + b4 * square(x2[n])
            + b5 * (x1[n] * x2[n]);
  }
}

model {
  
  // Colby 2025 priors Preciptation + irrigation
  target += normal_lpdf(b0 | 236, 15);    // intercept
  target += normal_lpdf(b1 | -6, 11);      // Nitrogen
  target += normal_lpdf(b2 | 60, 13);        // water
  target += normal_lpdf(b3 | -10, 13);     // N ^ 2
  target += normal_lpdf(b4 | -17, 9);    // W ^ 2
  target += normal_lpdf(b5 | -19, 15);   // N * W
  
  
  target += gamma_lpdf(sigma | 1100, 10);
  target += normal_lpdf(alpha | -2, 10); // negative skew (long tail on the left side)
  
  // Likelihood
  target += normal_lpdf(sigma_u | 0, 10);   
  target += normal_lpdf(z_u | 0, 1);           // non-centered parameterization
  target += skew_normal_lpdf(y | mu, sigma, alpha);

}


generated quantities {
  vector[N] y_rep;
  vector[2] b_vec;
  vector[2] x_s;          
  vector[2] eigen_val;
  vector[N_test] grid_pred;
  vector[N_test] loss_linex;
  vector[N_test] loss_ptl;
  vector[N_test] loss_sl;
  
  real profit_opt;
  
  matrix[2, 2] B_mat;
  matrix[2, 2] eigen_vec; 
  
  
  b_vec[1] = b1;
  b_vec[2] = b2;
  
  B_mat[1, 1] = b3;
  B_mat[1, 2] = b5 .* 0.5;
  B_mat[2, 1] = b5 .* 0.5;
  B_mat[2, 2] = b4;
  
  //xs = -0.5 * B^-1 * b
  x_s = -0.5 * (B_mat \ b_vec);
  
  //Canonical analysis
  eigen_val = eigenvalues_sym(B_mat);
  eigen_vec = eigenvectors_sym(B_mat); 
  

  
  // Posterior predictive check
  for (n in 1:N) {
    y_rep[n] = skew_normal_rng(mu[n], sigma, alpha);
  }
  
  // Profit optim
  profit_opt = b0
             + x_s[1] * b1
             + x_s[2] * b2
             + square(x_s[1]) * b3
             + square(x_s[2]) * b4
             + x_s[1] * x_s[2] * b5;
             
             
  // Profit grid predict
  for (i in 1:N_test) {

    grid_pred[i] = b0
                   + act_x1[i] * b1
                   + act_x2[i] * b2
                   + square(act_x1[i]) * b3
                   + square(act_x2[i]) * b4
                   + act_x1[i] * act_x2[i] * b5;

  // profit loss
  loss_linex[i] = LINEX(grid_pred[i], profit_opt, psi);
  loss_ptl[i] = ASY_POT(grid_pred[i], profit_opt, psi);
  loss_sl[i] = SL(grid_pred[i], profit_opt, psi); 
  
  }  
  
}



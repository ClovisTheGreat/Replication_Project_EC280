rm(list = ls())
library(haven)
library(fixest)
library(modelsummary)

# Load data
data <- read_dta("preanalysis_post1930.dta")

# Function to safely get variables matching a pattern
get_vars <- function(pattern, data) {
  vars <- grep(pattern, names(data), value = TRUE)
  if(length(vars) == 0) return(NULL)
  return(vars)
}

# Get variable names matching patterns
d_sy_vars <- get_vars("^d_sy_", data)
cotton_s_vars <- get_vars("^cotton_s_", data)
corn_s_vars <- get_vars("^corn_s_", data)
ld_vars <- get_vars("^ld_", data)
dx_vars <- get_vars("^dx_", data)
dy_vars <- get_vars("^dy_", data)
rug_vars <- get_vars("^rug_", data)
lag1_lnavfarmsize_vars <- get_vars("^lag1_lnavfarmsize_", data)
lag2_lnavfarmsize_vars <- get_vars("^lag2_lnavfarmsize_", data)
lag3_lnavfarmsize_vars <- get_vars("^lag3_lnavfarmsize_", data)
lag4_lnavfarmsize_vars <- get_vars("^lag4_lnavfarmsize_", data)
lag1_lnvalue_equipment_vars <- get_vars("^lag1_lnvalue_equipment_", data)
lag2_lnvalue_equipment_vars <- get_vars("^lag2_lnvalue_equipment_", data)
lag3_lnvalue_equipment_vars <- get_vars("^lag3_lnvalue_equipment_", data)
lag4_lnvalue_equipment_vars <- get_vars("^lag4_lnvalue_equipment_", data)
lag1_lntractors_vars <- get_vars("^lag1_lntractors_", data)
lag1_lnmules_horses_vars <- get_vars("^lag1_lnmules_horses_", data)
lag2_lnmules_horses_vars <- get_vars("^lag2_lnmules_horses_", data)
lag3_lnmules_horses_vars <- get_vars("^lag3_lnmules_horses_", data)
lag4_lnmules_horses_vars <- get_vars("^lag4_lnmules_horses_", data)
lnpcpubwor_vars <- get_vars("^lnpcpubwor_", data)
lnpcaaa_vars <- get_vars("^lnpcaaa_", data)
lnpcrelief_vars <- get_vars("^lnpcrelief_", data)
lnpcndloan_vars <- get_vars("^lnpcndloan_", data)
lnpcndins_vars <- get_vars("^lnpcndins_", data)

# Create base control string
base_controls <- paste(c(d_sy_vars, cotton_s_vars, corn_s_vars, ld_vars, 
                         dx_vars, dy_vars, rug_vars), collapse = " + ")

# Create New Deal controls string
newdeal_controls <- paste(c(lnpcpubwor_vars, lnpcaaa_vars, lnpcrelief_vars, 
                            lnpcndloan_vars, lnpcndins_vars), collapse = " + ")

models <- list()

# Model 1: Equipment value without controls
fml1 <- as.formula(paste0(
  "lnvalue_equipment ~ f_int_1930 + f_int_1935 + f_int_1940 + f_int_1945 + ",
  "f_int_1950 + f_int_1954 + f_int_1960 + f_int_1964 + f_int_1970 + ",
  base_controls, " + ",
  paste(c(lag1_lnvalue_equipment_vars, lag2_lnvalue_equipment_vars, 
          lag3_lnvalue_equipment_vars, lag4_lnvalue_equipment_vars), collapse = " + "),
  " | fips"
))
model1 <- feols(fml1, data = data, weights = ~county_w, cluster = ~fips, collin.rm = TRUE)
models[[1]] <- model1

# Model 2: Equipment value with controls
fml2 <- as.formula(paste0(
  "lnvalue_equipment ~ f_int_1930 + f_int_1935 + f_int_1940 + f_int_1945 + ",
  "f_int_1950 + f_int_1954 + f_int_1960 + f_int_1964 + f_int_1970 + ",
  base_controls, " + ",
  paste(c(lag1_lnvalue_equipment_vars, lag2_lnvalue_equipment_vars, 
          lag3_lnvalue_equipment_vars, lag4_lnvalue_equipment_vars), collapse = " + "),
  " + ", newdeal_controls, " | fips"
))
model2 <- feols(fml2, data = data, weights = ~county_w, cluster = ~fips, collin.rm = TRUE)
models[[2]] <- model2

# Model 3: Tractors without controls
fml3 <- as.formula(paste0(
  "lntractors ~ f_int_1930 + f_int_1935 + f_int_1940 + f_int_1945 + ",
  "f_int_1950 + f_int_1954 + f_int_1960 + f_int_1964 + f_int_1970 + ",
  base_controls, " + ",
  paste(lag1_lntractors_vars, collapse = " + "),
  " | fips"
))
model3 <- feols(fml3, data = data, weights = ~county_w, cluster = ~fips, collin.rm = TRUE)
models[[3]] <- model3

# Model 4: Tractors with controls
fml4 <- as.formula(paste0(
  "lntractors ~ f_int_1930 + f_int_1935 + f_int_1940 + f_int_1945 + ",
  "f_int_1950 + f_int_1954 + f_int_1960 + f_int_1964 + f_int_1970 + ",
  base_controls, " + ",
  paste(lag1_lntractors_vars, collapse = " + "),
  " + ", newdeal_controls, " | fips"
))
model4 <- feols(fml4, data = data, weights = ~county_w, cluster = ~fips, collin.rm = TRUE)
models[[4]] <- model4

# Model 5: Mules/horses without controls
fml5 <- as.formula(paste0(
  "lnmules_horses ~ f_int_1930 + f_int_1935 + f_int_1940 + f_int_1945 + ",
  "f_int_1950 + f_int_1954 + f_int_1960 + f_int_1964 + f_int_1970 + ",
  base_controls, " + ",
  paste(c(lag1_lnmules_horses_vars, lag2_lnmules_horses_vars, 
          lag3_lnmules_horses_vars, lag4_lnmules_horses_vars), collapse = " + "),
  " | fips"
))
model5 <- feols(fml5, data = data, weights = ~county_w, cluster = ~fips, collin.rm = TRUE)
models[[5]] <- model5

# Model 6: Mules/horses with controls
fml6 <- as.formula(paste0(
  "lnmules_horses ~ f_int_1930 + f_int_1935 + f_int_1940 + f_int_1945 + ",
  "f_int_1950 + f_int_1954 + f_int_1960 + f_int_1964 + f_int_1970 + ",
  base_controls, " + ",
  paste(c(lag1_lnmules_horses_vars, lag2_lnmules_horses_vars, 
          lag3_lnmules_horses_vars, lag4_lnmules_horses_vars), collapse = " + "),
  " + ", newdeal_controls, " | fips"
))
model6 <- feols(fml6, data = data, weights = ~county_w, cluster = ~fips, collin.rm = TRUE)
models[[6]] <- model6

# Model 7: Average farm size without controls
fml7 <- as.formula(paste0(
  "lnavfarmsize ~ f_int_1930 + f_int_1935 + f_int_1940 + f_int_1945 + ",
  "f_int_1950 + f_int_1954 + f_int_1960 + f_int_1964 + f_int_1970 + ",
  base_controls, " + ",
  paste(c(lag1_lnavfarmsize_vars, lag2_lnavfarmsize_vars, 
          lag3_lnavfarmsize_vars, lag4_lnavfarmsize_vars), collapse = " + "),
  " | fips"
))
model7 <- feols(fml7, data = data, weights = ~county_w, cluster = ~fips, collin.rm = TRUE)
models[[7]] <- model7

# Model 8: Average farm size with controls
fml8 <- as.formula(paste0(
  "lnavfarmsize ~ f_int_1930 + f_int_1935 + f_int_1940 + f_int_1945 + ",
  "f_int_1950 + f_int_1954 + f_int_1960 + f_int_1964 + f_int_1970 + ",
  base_controls, " + ",
  paste(c(lag1_lnavfarmsize_vars, lag2_lnavfarmsize_vars, 
          lag3_lnavfarmsize_vars, lag4_lnavfarmsize_vars), collapse = " + "),
  " + ", newdeal_controls, " | fips"
))
model8 <- feols(fml8, data = data, weights = ~county_w, cluster = ~fips, collin.rm = TRUE)
models[[8]] <- model8

# Display results in console
etable(models, keep = "f_int_")

# Export to CSV
modelsummary(
  models,
  output = "Table4inR.csv",
  coef_map = c(
    "f_int_1930" = "f_int_1930",
    "f_int_1935" = "f_int_1935",
    "f_int_1940" = "f_int_1940",
    "f_int_1945" = "f_int_1945",
    "f_int_1950" = "f_int_1950",
    "f_int_1954" = "f_int_1954",
    "f_int_1960" = "f_int_1960",
    "f_int_1964" = "f_int_1964",
    "f_int_1970" = "f_int_1970"
  ),
  fmt = 3,
  stars = c('*' = 0.05, '**' = 0.01),
  estimate = "{estimate}",
  statistic = "({std.error})",
  gof_omit = ".*"
)

print("Table exported to Table4inR.csv")
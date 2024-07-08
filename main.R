library(tercen)
library(dplyr, warn.conflicts = FALSE)
library(tidyr, warn.conflicts = FALSE)
library(pheatmap)

ctx = tercenCtx()

mat <- ctx$as.matrix() 

# if
df_col <- ctx$cselect()
mat_colnames <- df_col %>%
  tidyr::unite("name")
colnames(mat) <- mat_colnames$name
df_col <- as.data.frame(df_col, row.names = mat_colnames$name)

df_row <- ctx$rselect()
mat_rownames <- df_row %>%
  tidyr::unite("name")
rownames(mat) <- mat_rownames$name
df_row <- as.data.frame(df_row, row.names = mat_rownames$name)

cluster_rows <- ctx$op.value("Cluster Rows", as.logical, TRUE)
cluster_cols <- ctx$op.value("Cluster Columns", as.logical, TRUE)
legend <- ctx$op.value("Display Legend", as.logical, TRUE)
scale <- ctx$op.value("Scale", as.character, "none")
clustering_method <- ctx$op.value("Clustering Method", as.character, "complete")

show_rownames <- ctx$op.value("Show Row Names", as.logical, FALSE)
show_colnames <- ctx$op.value("Show Column Names", as.logical, FALSE)

filename <- ctx$op.value("Output File Name", as.character, "Heatmap.png")

filename_tmp <- tempfile(fileext = paste0(".", tools::file_ext(filename)))
on.exit(unlink(filename_tmp))

show_row_factors <- ctx$op.value("Show Row Factors", as.logical, FALSE)
show_col_factors <- ctx$op.value("Show Column Factors", as.logical, FALSE)
if(!show_row_factors) df_row <- NA
if(!show_col_factors) df_col <- NA

pheatmap(
  mat,
  cluster_rows = cluster_rows,
  cluster_cols = cluster_cols,
  clustering_distance_rows = "euclidean",
  clustering_distance_cols = "euclidean",
  legend = legend,
  scale = scale,
  clustering_method = clustering_method,
  annotation_row = df_row,
  annotation_col = df_col,
  annotation_names_row = TRUE, 
  annotation_names_col = TRUE,
  show_rownames = show_rownames,
  show_colnames = show_colnames,
  filename = filename_tmp
)

# save plot
tercen::file_to_tercen(file_path = filename_tmp, filename = filename) %>%
  ctx$addNamespace() %>%
  as_relation() %>%
  as_join_operator(list(), list()) %>%
  save_relation(., ctx)

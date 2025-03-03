# nuclear feature table
setwd("C:/Users/Quy/Documents/R/germinal_center/20250207")
getwd()

library(tidyverse)
library(purrr)


# # Read in table & add columns for cell_type, TLS_location & cell_type_location
# df <- read.csv("DeepMel_2X1_ROI2.4.5.6.7_nuc_features_with_marker_status_20250117.csv")
# 
# head(df, 2)
# df1 <- df %>% select(-Unnamed..0.1) %>% 
#   mutate(cell_type = case_when(
#     cd3_status == "positive" & cd20_status == "negative" ~ "T",
#     cd3_status == "negative" & cd20_status == "positive" ~ "B",
#     cd3_status == "positive" & cd20_status == "positive" ~ "DP",
#     cd3_status == "negative" & cd20_status == "negative" ~ "DN"
#                               )
#         ) %>% 
#   mutate(TLS_location = case_when(
#     grepl("inside", nuc_id) ~ "in",
#     grepl("outside", nuc_id) ~ "out"
#                                 )
#         ) %>% 
#   unite("cell_type_location", cell_type, TLS_location, sep = "_", remove = FALSE) %>% 
#   rename(nuc_index = X)
# 
# head(df1, 2)
# unique(df1$cell_type)
# unique(df1$TLS_location)
# unique(df1$cell_type_location)
# 
# count(df1, TLS_location)
# count(df1, cell_type)
# count(df1, cell_type_location)
# 
# table(df1$TLS_location)
# table(df1$cell_type)
# table(df1$cell_type_location)

# write.csv(df1, "DeepMel_2X1_ROI2.4.5.6.7_nuclear_feature_with_cell_type_location_20250117.csv", row.names = FALSE)


# Read in df1 from 20250117
df1 <- read.csv("../20250117/DeepMel_2X1_ROI2.4.5.6.7_nuclear_feature_with_cell_type_location_20250117.csv")

# Read in BoutTout table from 20250117
BoutTout <- read.csv("../20250117/DeepMel_2X1_ROI2.4.5.6.7_nuclear.features_cell.type.location_BoutTout_20250117.csv")


# Select columns of df1 that match columns of BoutTout, filter out DP cells, combine "DN_in" & "DN_out" into "other", then drop cell_type_location column
df <- df1 %>% select(names(BoutTout)) %>% 
  filter(cell_type_location %in% c("B_in" ,"B_out", "T_in", "T_out", "DN_in", "DN_out")) %>%
  mutate(cell_class = ifelse(cell_type_location %in% c("DN_in", "DN_out"), "other", cell_type_location)) %>% 
  select(-cell_type_location)
  
table(df$cell_class)
head(df,2)

# Save table
write.csv(df, "DeepMel_2X1_ROI2.4.5.6.7_nmco.features_cell.class_20250207.csv", row.names = FALSE)

# Use this table to identify MRMR features for Balanced Random Forest classification of 5-class model training!

# 
# # Plot cell counts per cell class:
# df1$cell_type <- factor(df1$cell_type, levels = c("B", "T", "DP", "DN"))
# df1$TLS_location <- factor(df1$TLS_location, levels = c("in", "out"))                       
# df1$cell_type_location <- factor(df1$cell_type_location, levels = c("B_in", "B_out", "T_in", "T_out", "DP_in", "DP_out", "DN_in", "DN_out"))
# 
# tb <- data.frame(
#   cell_type = c("B", "B", "T", "T", "DP", "DP", "DN", "DN"),
#   TLS_location = rep(c("in", "out"), 4),
#   Count = c(count(df1, cell_type_location)$n)
# )
# tb$cell_type <- factor(tb$cell_type, levels = c("B", "T", "DP", "DN"))
# tb$TLS_location <- factor(tb$TLS_location, levels = c("out", "in"))
# 
# pl <- ggplot(tb, aes(x = cell_type, y = Count, fill = TLS_location)) +
#   geom_bar(stat = "identity", width = 0.7) +
#   geom_text(aes(label = Count),
#             position = position_stack(vjust = 0.5),
#             #color = "blue",
#             size = 3
#   ) +
#   scale_fill_manual(values = c("in" = "cornflowerblue", "out" = "orange")) +
#   theme_classic() +
#   theme(axis.text.x = element_text(face = "bold")) +
#   theme(aspect.ratio = 1.5/1) + # reduce space between bars
#   scale_x_discrete(expand = c(0,0)) + scale_y_continuous(expand = c(0,0)) + # remove padding around data from axes
#   labs(title = "Count of each cell class", x = "Cell Type", y = "Count")
# 
# pl
# 
# pdf("DeepMel_2X1_ROI2.4.5.6.7_cell_count_20250118.pdf", width = 4.5, height = 7)
# print(pl)
# dev.off()





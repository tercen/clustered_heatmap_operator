# Clustered Heatmap

##### Description

The `clustered heatmap operator` generates a clustered heatmap as a plot file.

##### Usage

Input|.
---|---
`y-axis`        | numeric, measurement
`row`           | Row stratifying factors 
`column`        | Column stratifying factors 

Settings|.
---|---
`input_var`        | parameter description

Output|.
---|---
`Plot File`        | Output plot

##### Details

This operator uses the `pheatmap()` function from the `pheatmap` R package.

##### See Also

[plot_operator](https://github.com/tercen/plot_operator)

